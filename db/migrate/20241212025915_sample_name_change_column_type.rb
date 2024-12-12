class SampleNameChangeColumnType < ActiveRecord::Migration[7.1]
  def change
    change_column(:photos, :caption, :text)
    change_column(:comments, :body, :text)
  end
end
