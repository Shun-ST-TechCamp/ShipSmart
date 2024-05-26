# lib/converters/amazon_to_japanpost.rb
require 'csv'
require 'prawn'
require 'java'

# JavaのDesktopクラスをインポート
java_import java.awt.Desktop

# mmをポイントに変換するメソッド
class Float
  def mm
    self * 2.83465
  end
end

class Integer
  def mm
    self.to_f.mm
  end
end

def convert_amazon_to_japanpost(file, sender_info)
  output_pdf = file.sub('.txt', '_japanpost.pdf')
  font_path = File.join(File.dirname(__FILE__), '../ipaexg.ttf')  # フォントファイルのパスを指定

  customers = []

  begin
    csv_content = File.read(file, encoding: 'UTF-8')
    csv_content = csv_content.gsub("\r\n", "\n").gsub("\r", "\n")  # 改行コードを統一
    CSV.parse(csv_content, headers: true, col_sep: "\t") do |row|
      customers << {
        name: row['recipient-name'],
        sku: row['sku'],
        postal_code: row['ship-postal-code'],
        address1: row['ship-state'],
        address2: row['ship-address-1'],
        address3: "#{row['ship-address-2']} #{row['ship-address-3']}".strip
      }
    end
  rescue => e
    JOptionPane.showMessageDialog(nil, "テキストファイルの読み込みに失敗しました: #{e.message}", "エラー", JOptionPane::ERROR_MESSAGE)
    return
  end

  generate_japanpost_pdf(customers, output_pdf, font_path, sender_info)
end

def generate_japanpost_pdf(customers, output_pdf, font_path, sender_info)
  Prawn::Document.generate(output_pdf, page_layout: :portrait, margin: [21.5.mm, 18.6.mm]) do |pdf|
    pdf.font_families.update("IPAexGothic" => {
      normal: font_path,
      bold: font_path,
      italic: font_path,
      bold_italic: font_path
    })

    pdf.font("IPAexGothic")
    label_width = 86.4.mm
    label_height = 50.8.mm

    customers.each_slice(10) do |page_customers|
      page_customers.each_with_index do |customer, index|
        x_position = (index % 2) * label_width
        y_position = pdf.bounds.top - (index / 2) * label_height
    
        pdf.bounding_box([x_position, y_position], width: label_width, height: label_height) do
          pdf.move_down 5
          pdf.bounding_box([5.mm, pdf.cursor], width: label_width - 10.mm, height: label_height - 20.mm) do
            pdf.text "#{customer[:sku]}", size: 7, align: :right # 商品の登録番号（文字サイズ7）
            pdf.move_down 5
            pdf.text "送り先", size: 10 # 文字サイズ10
            pdf.text "〒：#{customer[:postal_code]}", size: 10 # 文字サイズ10
            pdf.text "　　#{customer[:address1]}", size: 10 # 文字サイズ10
            pdf.text "　　#{customer[:address2]}", size: 10 # 文字サイズ10
            pdf.text "　　#{customer[:address3]}", size: 10 # 文字サイズ10
            pdf.move_down 5
            pdf.text "　　#{customer[:name]} 様", size: 12 # 文字サイズ10
          end

          # 点線を追加
          pdf.move_down 5
          pdf.dash(3, space: 2)
          pdf.stroke_horizontal_rule
          pdf.undash

          # 送り主情報をボックスの下に配置
          pdf.bounding_box([5.mm, 15.mm], width: label_width - 10.mm, height: 15.mm) do
            pdf.text "〒：#{sender_info['ご依頼主郵便番号']}", size: 7, align: :left # 自分の郵便番号（文字サイズ7）
            pdf.text "　　#{sender_info['ご依頼主住所']}", size: 7, align: :left  # 自分の住所
            pdf.text "　　#{sender_info['ご依頼主アパートマンション']}", size: 7, align: :left
            pdf.text "　　#{sender_info['ショップ名']}", size: 7, align: :left # ショップ名（文字サイズ7）
          end
        end
      end
      pdf.start_new_page unless page_customers.equal?(customers.last(10))
    end
  end

  # PDFを自動的に開く
  if Desktop.isDesktopSupported
    desktop = Desktop.getDesktop
    if desktop.isSupported(Desktop::Action::OPEN)
      begin
        desktop.open(File.new(output_pdf))
      rescue => e
        JOptionPane.showMessageDialog(nil, "PDFの表示に失敗しました: #{e.message}", "エラー", JOptionPane::ERROR_MESSAGE)
      end
    else
      JOptionPane.showMessageDialog(nil, "このシステムではPDFの自動表示がサポートされていません。", "エラー", JOptionPane::ERROR_MESSAGE)
    end
  else
    JOptionPane.showMessageDialog(nil, "このシステムではデスクトップ機能がサポートされていません。", "エラー", JOptionPane::ERROR_MESSAGE)
  end

  JOptionPane.showMessageDialog(nil, "PDFに変換しました: #{output_pdf}")
end
