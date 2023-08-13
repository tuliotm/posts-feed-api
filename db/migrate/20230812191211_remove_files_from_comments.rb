class RemoveFilesFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :file, :string
  end
end
