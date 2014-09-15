class AddCommentToReportSharing < ActiveRecord::Migration
  def change
    add_column :report_sharings, :comment, :text
  end
end
