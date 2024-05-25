# lib/sender_info_input.rb
require 'java'

# JavaのSwingクラスをインポート
java_import javax.swing.JFrame
java_import javax.swing.JButton
java_import javax.swing.JTextArea
java_import javax.swing.JLabel
java_import javax.swing.JOptionPane
java_import javax.swing.JScrollPane

# 送り主の情報を入力するためのGUI
class SenderInfoInput
  def initialize
    @frame = JFrame.new("Sender Information")
    @frame.set_size(400, 400)
    @frame.set_layout(nil)

    # ラベルとテキストフィールドの設定
    labels = ["ご依頼主電話番号", "ご依頼主郵便番号", "ご依頼主住所", "ご依頼主アパートマンション", "ご依頼主名", "請求先顧客コード"]
    @text_fields = {}

    labels.each_with_index do |label, index|
      lbl = JLabel.new(label)
      lbl.set_bounds(10, 30 * index + 10, 150, 25)
      @frame.add(lbl)

      txt_area = JTextArea.new
      scroll_pane = JScrollPane.new(txt_area)
      scroll_pane.set_bounds(170, 30 * index + 10, 200, 25)
      @frame.add(scroll_pane)
      @text_fields[label] = txt_area
    end

    # 保存ボタン
    save_button = JButton.new("保存")
    save_button.set_bounds(150, 250, 80, 25)
    save_button.add_action_listener do |e|
      save_sender_info
    end
    @frame.add(save_button)

    @frame.set_default_close_operation(JFrame::HIDE_ON_CLOSE)
    @frame.set_visible(true)
  end

  def save_sender_info
    sender_info = @text_fields.transform_values(&:get_text)
    File.open("sender_info.csv", "w") do |file|
      file.puts "ご依頼主電話番号,ご依頼主郵便番号,ご依頼主住所,ご依頼主アパートマンション,ご依頼主名,請求先顧客コード"
      file.puts sender_info.values.map(&:strip).join(",")
    end
    JOptionPane.show_message_dialog(@frame, "送り主情報が保存されました。")
  end

  def get_sender_info
    sender_info = {}
    CSV.foreach("sender_info.csv", headers: true) do |row|
      sender_info = row.to_h
    end
    sender_info
  end
end
