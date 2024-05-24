# converters/amazon_to_sagawa.rb
require 'csv'
require 'java'
java_import javax.swing.JOptionPane

def convert_amazon_to_sagawa(file)
  output_file = file.sub('.txt', '_sagawa.csv')
  sagawa_headers = [
    "お届け先コード取得区分", "お届け先コード", "お届け先電話番号", "お届け先郵便番号", "お届け先住所１", 
    "お届け先住所２", "お届け先住所３", "お届け先名称１", "お届け先名称２", "お客様管理番号", 
    "お客様コード", "部署ご担当者コード取得区分", "部署ご担当者コード", "部署ご担当者名称", "荷送人電話番号", 
    "ご依頼主コード取得区分", "ご依頼主コード", "ご依頼主電話番号", "ご依頼主郵便番号", "ご依頼主住所１", 
    "ご依頼主住所２", "ご依頼主名称１", "ご依頼主名称２", "荷姿", "品名１", "品名２", "品名３", 
    "品名４", "品名５", "荷札荷姿", "荷札品名１", "荷札品名２", "荷札品名３", "荷札品名４", "荷札品名５", 
    "荷札品名６", "荷札品名７", "荷札品名８", "荷札品名９", "荷札品名１０", "荷札品名１１", "出荷個数", 
    "スピード指定", "クール便指定", "配達日", "配達指定時間帯", "配達指定時間（時分）", "代引金額", "消費税", 
    "決済種別", "保険金額", "指定シール１", "指定シール２", "指定シール３", "営業所受取", "SRC区分", 
    "営業所受取営業所コード", "元着区分", "メールアドレス", "ご不在時連絡先", "出荷日", "お問い合せ送り状No.", 
    "出荷場印字区分", "集約解除指定", "編集０１", "編集０２", "編集０３", "編集０４", "編集０５", "編集０６", 
    "編集０７", "編集０８", "編集０９", "編集１０"
  ]

  CSV.open(output_file, "w", write_headers: true, headers: sagawa_headers) do |csv|
    CSV.foreach(file, headers: true, col_sep: "\t", encoding: 'Shift_JIS:UTF-8') do |row|
      sagawa_row = []
      sagawa_row << "" # お届け先コード取得区分
      sagawa_row << "" # お届け先コード
      sagawa_row << row["buyer-phone-number"] # お届け先電話番号
      sagawa_row << row["ship-postal-code"] # お届け先郵便番号
      sagawa_row << row["ship-state"] # お届け先住所１
      sagawa_row << row["ship-address-1"] # お届け先住所２
      sagawa_row << "#{row['ship-address-2']} #{row['ship-address-3']}".strip # お届け先住所３
      sagawa_row << row["recipient-name"] # お届け先名称１
      sagawa_row << "" # お届け先名称２
      sagawa_row << "" # お客様管理番号
      sagawa_row << "" # お客様コード
      sagawa_row << "" # 部署ご担当者コード取得区分
      sagawa_row << "" # 部署ご担当者コード
      sagawa_row << "" # 部署ご担当者名称
      sagawa_row << "" # 荷送人電話番号
      sagawa_row << "" # ご依頼主コード取得区分
      sagawa_row << "" # ご依頼主コード
      sagawa_row << "" # ご依頼主電話番号
      sagawa_row << "" # ご依頼主郵便番号
      sagawa_row << "" # ご依頼主住所１
      sagawa_row << "" # ご依頼主住所２
      sagawa_row << "" # ご依頼主名称１
      sagawa_row << "" # ご依頼主名称２
      sagawa_row << "" # 荷姿
      sagawa_row << "" # 品名１
      sagawa_row << "" # 品名２
      sagawa_row << "" # 品名３
      sagawa_row << "" # 品名４
      sagawa_row << "" # 品名５
      sagawa_row << "" # 荷札荷姿
      sagawa_row << "" # 荷札品名１
      sagawa_row << "" # 荷札品名２
      sagawa_row << "" # 荷札品名３
      sagawa_row << "" # 荷札品名４
      sagawa_row << "" # 荷札品名５
      sagawa_row << "" # 荷札品名６
      sagawa_row << "" # 荷札品名７
      sagawa_row << "" # 荷札品名８
      sagawa_row << "" # 荷札品名９
      sagawa_row << "" # 荷札品名１０
      sagawa_row << "" # 荷札品名１１
      sagawa_row << "" # 出荷個数
      sagawa_row << "" # スピード指定
      sagawa_row << "" # クール便指定
      sagawa_row << "" # 配達日
      sagawa_row << "" # 配達指定時間帯
      sagawa_row << "" # 配達指定時間（時分）
      sagawa_row << "" # 代引金額
      sagawa_row << "" # 消費税
      sagawa_row << "" # 決済種別
      sagawa_row << "" # 保険金額
      sagawa_row << "" # 指定シール１
      sagawa_row << "" # 指定シール２
      sagawa_row << "" # 指定シール３
      sagawa_row << "" # 営業所受取
      sagawa_row << "" # SRC区分
      sagawa_row << "" # 営業所受取営業所コード
      sagawa_row << "" # 元着区分
      sagawa_row << "" # メールアドレス
      sagawa_row << "" # ご不在時連絡先
      sagawa_row << "" # 出荷日
      sagawa_row << "" # お問い合せ送り状No.
      sagawa_row << "" # 出荷場印字区分
      sagawa_row << "" # 集約解除指定
      sagawa_row << "" # 編集０１
      sagawa_row << "" # 編集０２
      sagawa_row << "" # 編集０３
      sagawa_row << "" # 編集０４
      sagawa_row << "" # 編集０５
      sagawa_row << "" # 編集０６
      sagawa_row << "" # 編集０７
      sagawa_row << "" # 編集０８
      sagawa_row << "" # 編集０９
      sagawa_row << "" # 編集１０

      csv << sagawa_row
    end
  end

  JOptionPane.showMessageDialog(nil, "CSVファイルが作成されました: #{output_file}")
end
