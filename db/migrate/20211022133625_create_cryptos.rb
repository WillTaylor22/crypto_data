class CreateCryptos < ActiveRecord::Migration[6.1]
  def change
    create_table :cryptos do |t|
      t.string :name, :null => false
      t.string :ticker, :null => false

      t.timestamps
    end
    add_index :cryptos, :ticker, unique: true
  end
end
