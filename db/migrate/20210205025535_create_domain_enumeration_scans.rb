# frozen_string_literal: true
class CreateDomainEnumerationScans < ActiveRecord::Migration[6.1]
  def change
    create_table(:domain_enumeration_scans, &:timestamps)
  end
end
