class CreateDomainEnumerationScans < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_enumeration_scans do |t|

      t.timestamps
    end
  end
end
