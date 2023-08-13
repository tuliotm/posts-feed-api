class RemoveFilesFromPublications < ActiveRecord::Migration[7.0]
  def change
    remove_column :publications, :files, :string
  end
end
