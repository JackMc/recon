class AddTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name
    end

    create_table :tagged_items do |t|
      t.string :item_type
      t.bigint :item_id

      t.bigint :tag_id
    end
  end
end
