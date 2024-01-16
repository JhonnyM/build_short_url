class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.text :url
      t.text :title
      t.string :short_url
      t.string :sanitize_url
      t.integer :access_count, null: false,  default: 0
      t.timestamps
    end
  end
end
