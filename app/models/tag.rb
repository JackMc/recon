# frozen_string_literal: true
class Tag < ApplicationRecord
  has_many :items, class_name: 'Domain', through: :tagged_items
  has_and_belongs_to_many :domains, join_table: 'tagged_items'

  def self.favourite
    find_or_create_by(name: 'Favourite')
  end
end
