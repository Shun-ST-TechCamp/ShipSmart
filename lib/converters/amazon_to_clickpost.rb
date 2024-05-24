# lib/converters/amazon_to_clickpost.rb
require 'csv'

def convert_amazon_to_clickpost(file)
  output_file = file.sub('.txt', '_clickpost.csv')
  clickpost_headers = [
    "お届け先郵便番号", "お届け先氏名", "お届け先敬称", "お届け先住所1行目", "お届け先住所2行目",
    "お届け先住所3行目", "お届け先住所4行目", "内容品"
  ]

  CSV.open(output_file, "w", write_headers: true, headers: clickpost_headers) do |csv|
    CSV.foreach(file, headers: true, col_sep: "\t", encoding: 'Shift_JIS:UTF-8') do |row|
      clickpost_row = []
      clickpost_row << row["ship-postal-code"] # お届け先郵便番号
      clickpost_row << row["recipient-name"] # お届け先氏名
      clickpost_row << "様" # お届け先敬称
      clickpost_row << row["ship-state"] # お届け先住所1行目
      clickpost_row << row["ship-address-1"] # お届け先住所2行目
      clickpost_row << row["ship-address-2"] # お届け先住所3行目
      clickpost_row << row["ship-address-3"] # お届け先住所4行目
      clickpost_row << row["product-name"] # 内容品

      csv << clickpost_row
    end
  end

  JOptionPane.showMessageDialog(nil, "CSVファイルが作成されました: #{output_file}")
end
