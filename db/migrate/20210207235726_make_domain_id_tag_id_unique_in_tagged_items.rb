# frozen_string_literal: true
class MakeDomainIdTagIdUniqueInTaggedItems < ActiveRecord::Migration[6.1]
  def change
    add_index(:tagged_items, [:domain_id, :tag_id], length: { fqdn: 256 }, unique: true)
  end
end
