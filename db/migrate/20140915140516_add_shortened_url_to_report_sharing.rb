class AddShortenedUrlToReportSharing < ActiveRecord::Migration
  def change
    add_column :report_sharings, :short_url, :string
  end
end
