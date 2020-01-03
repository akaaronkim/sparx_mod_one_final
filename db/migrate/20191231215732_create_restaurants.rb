class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :category
      t.string :price
      t.float :rating
      t.string :phone
      t.string :address
    end
  end
end
