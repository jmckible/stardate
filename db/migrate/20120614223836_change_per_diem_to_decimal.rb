class ChangePerDiemToDecimal < ActiveRecord::Migration
  def up
    change_column :items, :per_diem, :decimal, {scale: 2, precision: 10}
    Item.where("start != finish").each do |item|
      item.amortize
      item.save
    end
  end

  def down
    change_column :items, :per_diem, :integer
  end
end
