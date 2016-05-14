class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role,           :integer, default: 0, null: false

    add_column :users, :identification, :integer, default: 0, null: false
    add_column :users, :identified_at, :datetime
  end
end
