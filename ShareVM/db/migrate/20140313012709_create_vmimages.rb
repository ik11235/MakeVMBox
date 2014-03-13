class CreateVmimages < ActiveRecord::Migration
  def change
    create_table :vmimages do |t|
      t.string :osname
      t.string :osversion

      t.timestamps
    end
  end
end
