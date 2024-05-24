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

def convert_amazon_to_japanpost(file)
  output_pdf = file.sub('.txt', '_japanpost.pdf')
  font_path = File.join(File.dirname(__FILE__), '../ipaexg.ttf')  # フォントファイルのパスを指定

  customers = []

  begin
    csv_content = File.read(file, encoding: 'Shift_JIS:UTF-8')
    csv_content = csv_content.gsub("\r\n", "\n").gsub("\r", "\n")  # 改行コードを統一
    CSV.parse(csv_content, headers: true, col_sep: "\t") do |row|
      customers << {
        name: row['recipient-name'],
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

  generate_japanpost_pdf(customers, output_pdf, font_path)
end

def generate_japanpost_pdf(customers, output_pdf, font_path)
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
          pdf.dash(3, space: 2)
          pdf.stroke_bounds
          pdf.undash
          pdf.move_down 5
          pdf.text "　　〒：#{customer[:postal_code]}"
          pdf.move_down 5  # 1行スペースを追加
          pdf.text "　住所：#{customer[:address1]}"
          pdf.text "　　　　#{customer[:address2]}"
          pdf.text "　　　　#{customer[:address3]}" unless customer[:address3].nil? || customer[:address3].empty?
          pdf.move_down 5  # 1行スペースを追加
          pdf.text "　名前：#{customer[:name]} 様"
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
