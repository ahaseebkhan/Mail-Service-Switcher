class CreateTableEmail < ActiveRecord::Migration[6.0]
  def change
    create_table :emails do |t|
      t.integer :service
      t.integer :status
      t.json :api_response
      
      t.string :to, null: false
      t.string :to_name, null: false
      t.string :from, null: false
      t.string :from_name, null: false
      t.string :subject, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
