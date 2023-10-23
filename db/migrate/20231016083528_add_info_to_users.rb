class AddInfoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :postal_code, :string
    add_column :users, :address, :text
    add_column :users, :self_introduction, :text
  end
end
