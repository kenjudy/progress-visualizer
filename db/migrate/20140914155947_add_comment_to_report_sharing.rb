class AddCommentToReportSharing < ActiveRecord::Migration
  def change
    add_column :report_sharings, :comment, :string
  end
end
