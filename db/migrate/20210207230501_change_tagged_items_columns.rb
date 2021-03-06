# frozen_string_literal: true
class ChangeTaggedItemsColumns < ActiveRecord::Migration[6.1]
  def change
    change_table(:tagged_items) do |t|
      t.rename(:item_id, :domain_id)
      t.timestamps
    end
    change_table(:tags, &:timestamps)
  end
end
