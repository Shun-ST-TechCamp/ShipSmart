# lib/shipment_converter.rb
require 'csv'
require 'prawn'
require 'java'

# JavaのSwingクラスをインポート
java_import javax.swing.JFrame
java_import javax.swing.JButton
java_import javax.swing.JFileChooser
java_import javax.swing.JOptionPane

# 変換メソッドをインポート
require_relative 'converters/amazon_to_sagawa'
require_relative 'converters/amazon_to_clickpost'
# 他のコンバータファイルも同様にインポートする
# require_relative 'converters/yahoo_to_sagawa'
# require_relative 'converters/rakuten_to_sagawa'

# GUIの設定
frame = JFrame.new("ShipSmart Converter")
@selected_shop = nil
@selected_carrier = nil

# 配送業者の選択ボタン
carrier_button = JButton.new("配送業者を選択")
carrier_label = javax.swing.JLabel.new("配送業者が選択されていません")

carrier_button.add_action_listener do |e|
  options = ["佐川急便", "ヤマト", "郵便局（定型便）", "クリックポスト"]
  selected_option = JOptionPane.showInputDialog(nil, "配送業者を選択してください", "配送業者選択", JOptionPane::QUESTION_MESSAGE, nil, options.to_java, options[0])
  if selected_option
    carrier_label.setText("選択した配送業者: #{selected_option}")
    @selected_carrier = selected_option
  else
    carrier_label.setText("配送業者が選択されていません")
  end
end

# ショップの選択ボタン
shop_button = JButton.new("ショップを選択")
shop_label = javax.swing.JLabel.new("ショップが選択されていません")

shop_button.add_action_listener do |e|
  options = ["アマゾン", "ヤフーショッピング", "楽天"]
  selected_option = JOptionPane.showInputDialog(nil, "ショップを選択してください", "ショップ選択", JOptionPane::QUESTION_MESSAGE, nil, options.to_java, options[0])
  if selected_option
    shop_label.setText("選択したショップ: #{selected_option}")
    @selected_shop = selected_option
  else
    shop_label.setText("ショップが選択されていません")
  end
end

# ファイル選択ボタン
file_button = JButton.new("ファイルを選択")

file_button.add_action_listener do |e|
  unless @selected_shop && @selected_carrier
    JOptionPane.showMessageDialog(nil, "まずショップと配送業者を選択してください", "エラー", JOptionPane::ERROR_MESSAGE)
    return
  end

  file_chooser = JFileChooser.new
  result = file_chooser.show_open_dialog(nil)

  if result == JFileChooser::APPROVE_OPTION
    file = file_chooser.get_selected_file.to_s

    case @selected_carrier
    when "佐川急便"
      case @selected_shop
      when "アマゾン"
        convert_amazon_to_sagawa(file)
      # when "ヤフーショッピング"
      #   convert_yahoo_to_sagawa(file)
      # when "楽天"
      #   convert_rakuten_to_sagawa(file)
      else
        JOptionPane.showMessageDialog(nil, "このショップには対応していません。", "エラー", JOptionPane::ERROR_MESSAGE)
      end
    when "ヤマト"
      # 各ショップに対応するヤマトのコンバータを呼び出す
      # case @selected_shop
      # when "アマゾン"
      #   convert_amazon_to_yamato(file)
      # when "ヤフーショッピング"
      #   convert_yahoo_to_yamato(file)
      # when "楽天"
      #   convert_rakuten_to_yamato(file)
      # else
      #   JOptionPane.showMessageDialog(nil, "このショップには対応していません。", "エラー", JOptionPane::ERROR_MESSAGE)
      # end
    when "郵便局（定型便）"
      # 各ショップに対応する郵便局のコンバータを呼び出す
      # case @selected_shop
      # when "アマゾン"
      #   convert_amazon_to_japanpost(file)
      # when "ヤフーショッピング"
      #   convert_yahoo_to_japanpost(file)
      # when "楽天"
      #   convert_rakuten_to_japanpost(file)
      # else
      #   JOptionPane.showMessageDialog(nil, "このショップには対応していません。", "エラー", JOptionPane::ERROR_MESSAGE)
      # end
    when "クリックポスト"
      case @selected_shop
      when "アマゾン"
        convert_amazon_to_clickpost(file)
      # when "ヤフーショッピング"
      #   convert_yahoo_to_clickpost(file)
      # when "楽天"
      #   convert_rakuten_to_clickpost(file)
      else
        JOptionPane.showMessageDialog(nil, "このショップには対応していません。", "エラー", JOptionPane::ERROR_MESSAGE)
      end
    else
      JOptionPane.showMessageDialog(nil, "配送業者が選択されていません。", "エラー", JOptionPane::ERROR_MESSAGE)
    end
  end
end

# フレームにコンポーネントを追加
frame.add(carrier_button)
frame.add(carrier_label)
frame.add(shop_button)
frame.add(shop_label)
frame.add(file_button)
frame.set_layout(javax.swing.BoxLayout.new(frame.get_content_pane, javax.swing.BoxLayout::Y_AXIS))

frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
frame.set_size(400, 300)
frame.set_visible(true)

# メインスレッドを保持
while true
  sleep 1
end
