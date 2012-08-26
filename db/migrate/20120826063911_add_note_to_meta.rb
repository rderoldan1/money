class AddNoteToMeta < ActiveRecord::Migration
  def change
    add_column :meta, :note, :text
  end
end
