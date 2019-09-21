class AddSendAtToEmails < ActiveRecord::Migration[6.0]
  def change
    add_column :emails, :send_at, :datetime
  end
end
