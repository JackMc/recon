class AddTypeColumnToScans < ActiveRecord::Migration[6.1]
  def change
    change_table :scans do |t|
      t.string :type
    end

    execute "update scans set type='DomainEnumerationScan' where seed_type='Domain'"
    execute "update scans set type='HttpLivelinessScan' where seed_type='Target'"
  end
end
