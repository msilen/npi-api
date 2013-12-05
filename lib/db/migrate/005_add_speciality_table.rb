class AddSpecialityTable < ActiveRecord::Migration
  def self.up
    create_table "specialities" do |t|
      t.string   "name"
      t.timestamps
      t.string   "code"
    end
  end

  def self.down
    drop_table :specialities
  end
end
