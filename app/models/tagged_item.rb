# frozen_string_literal: true
class TaggedItem < ApplicationRecord
  has_many :tags
  has_many :domains, foreign_key: :item_id
end
