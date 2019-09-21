class CreateWebhookLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :webhook_logs do |t|
      t.integer :service
      t.string :email
      t.string :event
      t.json :response
    
      t.timestamps
    end
  end
end
