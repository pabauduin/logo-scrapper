class CreateLogos < ActiveRecord::Migration[6.1]
  def change
    create_table :logos do |t|
      t.string :company
      t.string :name

      t.timestamps
    end
  end
end
