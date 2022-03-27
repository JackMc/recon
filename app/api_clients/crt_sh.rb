# frozen_string_literal: true
require 'pg'

class CrtSh
  SUBDOMAINS_QUERY = <<~SQL
    WITH ci AS (
        SELECT min(sub.CERTIFICATE_ID) ID,
               min(sub.ISSUER_CA_ID) ISSUER_CA_ID,
               array_agg(DISTINCT sub.NAME_VALUE) NAME_VALUES,
               x509_commonName(sub.CERTIFICATE) COMMON_NAME,
               x509_notBefore(sub.CERTIFICATE) NOT_BEFORE,
               x509_notAfter(sub.CERTIFICATE) NOT_AFTER,
               encode(x509_serialNumber(sub.CERTIFICATE), 'hex') SERIAL_NUMBER
            FROM (SELECT *
                      FROM certificate_and_identities cai
                      WHERE plainto_tsquery('certwatch', $1) @@ identities(cai.CERTIFICATE)
                          AND cai.NAME_VALUE ILIKE ('%' || $1 || '%')
                      LIMIT 10000
                 ) sub
            GROUP BY sub.CERTIFICATE
    )
    SELECT ci.ISSUER_CA_ID,
            ca.NAME ISSUER_NAME,
            ci.COMMON_NAME,
            array_to_string(ci.NAME_VALUES, chr(10)) NAME_VALUE,
            ci.ID ID,
            le.ENTRY_TIMESTAMP,
            ci.NOT_BEFORE,
            ci.NOT_AFTER,
            ci.SERIAL_NUMBER
        FROM ci
                LEFT JOIN LATERAL (
                    SELECT min(ctle.ENTRY_TIMESTAMP) ENTRY_TIMESTAMP
                        FROM ct_log_entry ctle
                        WHERE ctle.CERTIFICATE_ID = ci.ID
                ) le ON TRUE,
             ca
        WHERE ci.ISSUER_CA_ID = ca.ID
        ORDER BY le.ENTRY_TIMESTAMP DESC NULLS LAST;
  SQL

  def self.subdomains(root_domain)
    query("%.#{root_domain}")
  end

  def self.query(domain_pattern)
    retry_count = 5
    begin
      begin
        connection.prepare('subdomains', SUBDOMAINS_QUERY)
      rescue PG::DuplicatePstatement
        # Do nothing, this is expected depending on where in the connection cycle we are.
      end

      results = connection.exec_prepared('subdomains', [domain_pattern])

      results.map { |row| row["name_value"].split("\n") }.compact.flatten.uniq
    rescue PG::ConnectionBad => e
      Rails.logger.info("Connection bad: #{e}")
      reconnect
      retry if retry_count -= 1
    rescue PG::UnableToSend => e
      Rails.logger.info("Unable to send packet: #{e}")
      reconnect
      retry if retry_count -= 1
    rescue
      Rails.logger.info("Other: #{e}")
      retry if retry_count -= 1
    end
  end

  def self.connection
    return @connection if @connection

    reconnect
  end

  def self.reconnect
    @connection = PG.connect(dbname: 'certwatch', host: 'crt.sh', port: 5432, user: 'guest')
  end

  def self.name
    'crt.sh'
  end
end
