class CreateFiats < ActiveRecord::Migration[6.1]
  def change
    create_table :fiats do |t|
      t.string :ticker, :null => false

      t.timestamps
    end
    add_index :fiats, :ticker, unique: true
  end
end
