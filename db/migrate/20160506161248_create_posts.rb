class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.text :description
      t.text :body
      t.integer :state, default: 0, null: false

      t.timestamps null: false
    end
  end
end
