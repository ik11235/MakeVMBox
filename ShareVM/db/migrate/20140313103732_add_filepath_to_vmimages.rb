class AddFilepathToVmimages < ActiveRecord::Migration
  def change
    add_column :vmimages, :filepath, :text
  end
end
