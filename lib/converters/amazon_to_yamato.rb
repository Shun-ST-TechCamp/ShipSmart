# lib/converters/amazon_to_yamato.rb
require 'csv'

def convert_amazon_to_yamato(file, sender_info)
  output_file = file.sub('.txt', '_yamato.csv')
  yamato_headers = [
    "お客様管理番号", "送り状種類", "クール区分", "伝票番号", "出荷予定日", "お届け予定日", "配達時間帯",
    "お届け先コード", "お届け先電話番号", "お届け先電話番号枝番", "お届け先郵便番号", "お届け先住所",
    "お届け先アパートマンション名", "お届け先会社・部門１", "お届け先会社・部門２", "お届け先名", "お届け先名(ｶﾅ)", 
    "敬称", "ご依頼主コード", "ご依頼主電話番号", "ご依頼主電話番号枝番", "ご依頼主郵便番号", "ご依頼主住所", 
    "ご依頼主アパートマンション", "ご依頼主名", "ご依頼主名(ｶﾅ)", "品名コード１", "品名１", "品名コード２", "品名２", 
    "荷扱い１", "荷扱い２", "記事", "ｺﾚｸﾄ代金引換額（税込)", "内消費税額等", "止置き", "営業所コード", "発行枚数", 
    "個数口表示フラグ", "請求先顧客コード", "請求先分類コード", "運賃管理番号", "クロネコwebコレクトデータ登録", 
    "クロネコwebコレクト加盟店番号", "クロネコwebコレクト申込受付番号１", "クロネコwebコレクト申込受付番号２", 
    "クロネコwebコレクト申込受付番号３", "お届け予定ｅメール利用区分", "お届け予定ｅメールe-mailアドレス", 
    "入力機種", "お届け予定ｅメールメッセージ", "お届け完了ｅメール利用区分", "お届け完了ｅメールe-mailアドレス", 
    "お届け完了ｅメールメッセージ", "クロネコ収納代行利用区分", "予備", "収納代行請求金額(税込)", "収納代行内消費税額等", 
    "収納代行請求先郵便番号", "収納代行請求先住所", "収納代行請求先住所（アパートマンション名）", "収納代行請求先会社・部門名１", 
    "収納代行請求先会社・部門名２", "収納代行請求先名(漢字)", "収納代行請求先名(カナ)", "収納代行問合せ先名(漢字)", 
    "収納代行問合せ先郵便番号", "収納代行問合せ先住所", "収納代行問合せ先住所（アパートマンション名）", "収納代行問合せ先電話番号", 
    "収納代行管理番号", "収納代行品名", "収納代行備考", "複数口くくりキー", "検索キータイトル1", "検索キー1", 
    "検索キータイトル2", "検索キー2", "検索キータイトル3", "検索キー3", "検索キータイトル4", "検索キー4", 
    "検索キータイトル5", "検索キー5", "予備", "予備", "投函予定メール利用区分", "投函予定メールe-mailアドレス", 
    "投函予定メールメッセージ", "投函完了メール（お届け先宛）利用区分", "投函完了メール（お届け先宛）e-mailアドレス", 
    "投函完了メール（お届け先宛）メールメッセージ", "投函完了メール（ご依頼主宛）利用区分", "投函完了メール（ご依頼主宛）e-mailアドレス", 
    "投函完了メール（ご依頼主宛）メールメッセージ"
  ]

  CSV.open(output_file, "w", write_headers: true, headers: yamato_headers) do |csv|
    CSV.foreach(file, headers: true, col_sep: "\t", encoding: 'Shift_JIS:UTF-8') do |row|
      yamato_row = []
      yamato_row << "" # お客様管理番号
      yamato_row << sender_info["送り状種類"] # 送り状種類（例：発払い）
      yamato_row << "" # クール区分
      yamato_row << "" # 伝票番号
      yamato_row << sender_info["出荷予定日"] # 出荷予定日
      yamato_row << "" # お届け予定日
      yamato_row << "" # 配達時間帯
      yamato_row << "" # お届け先コード
      yamato_row << row["buyer-phone-number"] # お届け先電話番号
      yamato_row << "" # お届け先電話番号枝番
      yamato_row << row["ship-postal-code"] # お届け先郵便番号
      yamato_row << "#{row["ship-state"]}#{row["ship-address-1"]} #{row['ship-address-2']}".strip# お届け先住所
      yamato_row << row["ship-address-3"] # お届け先アパートマンション名
      yamato_row << "" # お届け先会社・部門１
      yamato_row << "" # お届け先会社・部門２
      yamato_row << row["recipient-name"] # お届け先名
      yamato_row << "" # お届け先名(ｶﾅ)
      yamato_row << "様" # 敬称
      yamato_row << "" # ご依頼主コード
      yamato_row << sender_info["ご依頼主電話番号"] # ご依頼主電話番号
      yamato_row << "" # ご依頼主電話番号枝番
      yamato_row << sender_info["ご依頼主郵便番号"] # ご依頼主郵便番号
      yamato_row << sender_info["ご依頼主住所"] # ご依頼主住所
      yamato_row << sender_info["ご依頼主アパートマンション"] # ご依頼主アパートマンション
      yamato_row << sender_info["ご依頼主名"] # ご依頼主名
      yamato_row << "" # ご依頼主名(ｶﾅ)
      yamato_row << "" # 品名コード１
      yamato_row << row["product-name"][0, 25] # 品名１（最大25文字まで）
      yamato_row << "" # 品名コード２
      yamato_row << "" # 品名２
      yamato_row << "" # 荷扱い１
      yamato_row << "" # 荷扱い２
      yamato_row << "" # 記事
      yamato_row << "" # ｺﾚｸﾄ代金引換額（税込)
      yamato_row << "" # 内消費税額等
      yamato_row << "" # 止置き
      yamato_row << "" # 営業所コード
      yamato_row << "" # 発行枚数
      yamato_row << "" # 個数口表示フラグ
      yamato_row << sender_info["請求先顧客コード"] # 請求先顧客コード
      yamato_row << "" # 請求先分類コード
      yamato_row << sender_info["運賃管理番号"] # 運賃管理番号
      yamato_row << "" # クロネコwebコレクトデータ登録
      yamato_row << "" # クロネコwebコレクト加盟店番号
      yamato_row << "" # クロネコwebコレクト申込受付番号１
      yamato_row << "" # クロネコwebコレクト申込受付番号２
      yamato_row << "" # クロネコwebコレクト申込受付番号３
      yamato_row << "" # お届け予定ｅメール利用区分
      yamato_row << "" # お届け予定ｅメールe-mailアドレス
      yamato_row << "" # 入力機種
      yamato_row << "" # お届け予定ｅメールメッセージ
      yamato_row << "" # お届け完了ｅメール利用区分
      yamato_row << "" # お届け完了ｅメールe-mailアドレス
      yamato_row << "" # お届け完了ｅメールメッセージ
      yamato_row << "" # クロネコ収納代行利用区分
      yamato_row << "" # 予備
      yamato_row << "" # 収納代行請求金額(税込)
      yamato_row << "" # 収納代行内消費税額等
      yamato_row << "" # 収納代行請求先郵便番号
      yamato_row << "" # 収納代行請求先住所
      yamato_row << "" # 収納代行請求先住所（アパートマンション名）
      yamato_row << "" # 収納代行請求先会社・部門名１
      yamato_row << "" # 収納代行請求先会社・部門名２
      yamato_row << "" # 収納代行請求先名(漢字)
      yamato_row << "" # 収納代行請求先名(カナ)
      yamato_row << "" # 収納代行問合せ先名(漢字)
      yamato_row << "" # 収納代行問合せ先郵便番号
      yamato_row << "" # 収納代行問合せ先住所
      yamato_row << "" # 収納代行問合せ先住所（アパートマンション名）
      yamato_row << "" # 収納代行問合せ先電話番号
      yamato_row << "" # 収納代行管理番号
      yamato_row << "" # 収納代行品名
      yamato_row << "" # 収納代行備考
      yamato_row << "" # 複数口くくりキー
      yamato_row << "" # 検索キータイトル1
      yamato_row << "" # 検索キー1
      yamato_row << "" # 検索キータイトル2
      yamato_row << "" # 検索キー2
      yamato_row << "" # 検索キータイトル3
      yamato_row << "" # 検索キー3
      yamato_row << "" # 検索キータイトル4
      yamato_row << "" # 検索キー4
      yamato_row << "" # 検索キータイトル5
      yamato_row << "" # 検索キー5
      yamato_row << "" # 予備
      yamato_row << "" # 予備
      yamato_row << "" # 投函予定メール利用区分
      yamato_row << "" # 投函予定メールe-mailアドレス
      yamato_row << "" # 投函予定メールメッセージ
      yamato_row << "" # 投函完了メール（お届け先宛）利用区分
      yamato_row << "" # 投函完了メール（お届け先宛）e-mailアドレス
      yamato_row << "" # 投函完了メール（お届け先宛）メールメッセージ
      yamato_row << "" # 投函完了メール（ご依頼主宛）利用区分
      yamato_row << "" # 投函完了メール（ご依頼主宛）e-mailアドレス
      yamato_row << "" # 投函完了メール（ご依頼主宛）メールメッセージ

      csv << yamato_row
    end
  end

  JOptionPane.showMessageDialog(nil, "ヤマト用CSVファイルが作成されました: #{output_file}")
end
