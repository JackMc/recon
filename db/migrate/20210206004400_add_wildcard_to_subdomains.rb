class AddWildcardToSubdomains < ActiveRecord::Migration[6.1]
  def change
    change_table :domains do |t|
      t.boolean :wildcard
    end
  end
end
