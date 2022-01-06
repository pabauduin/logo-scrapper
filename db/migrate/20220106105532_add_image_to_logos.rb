class AddImageToLogos < ActiveRecord::Migration[6.1]
  def change
    add_column :logos, :image, :string
  end
end
