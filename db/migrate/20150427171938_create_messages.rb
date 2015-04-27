class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	 t.integer :sender_id
    	 t.integer :recipient_id
    	 t.string	:message_text

    	 t.timestamps
    end
  end
end
