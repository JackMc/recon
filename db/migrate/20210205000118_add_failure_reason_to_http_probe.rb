# frozen_string_literal: true
class AddFailureReasonToHttpProbe < ActiveRecord::Migration[6.1]
  def change
    change_table(:http_probes) do |t|
      t.string(:failure_reason)
      t.boolean(:failed)
    end
  end
end
