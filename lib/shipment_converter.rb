#!/usr/bin/env jruby
require 'csv'
require 'prawn'
require 'java'
require 'fileutils'

# JavaのSwingクラスをインポート
java_import javax.swing.JFrame
java_import javax.swing.JButton
java_import javax.swing.JFileChooser
java_import javax.swing.JOptionPane

def convert_amazon_to_sagawa(file)
  # 佐川急便用のCSV変換ロジックをここに記述
end

def convert_amazon_to_yamato(file)
  # ヤマト用のCSV変換ロジックをここに記述
end

def convert_amazon_to_japanpost(file)
  # 日本郵便用のPDF変換ロジックをここに記述
end

def convert_amazon_to_clickpost(file)
  # クリックポスト用のCSV変換ロジックをここに記述
end

# GUIの設定
frame = JFrame.new("ShipSmart")
button = JButton.new("Amazonファイルを選択")

button.add_action_listener do |e|
  file_chooser = JFileChooser.new
  result = file_chooser.show_open_dialog(nil)

  if result == JFileChooser::APPROVE_OPTION
    file = file_chooser.get_selected_file.to_s
    if ::File.extname(file) == '.txt'
      # 配送業者選択ダイアログの表示
      options = ['佐川急便', 'ヤマト', '日本郵便（定型便）', 'クリックポスト']
      selection = JOptionPane.showInputDialog(frame, "配送業者を選択してください", "配送業者選択", JOptionPane::QUESTION_MESSAGE, nil, options, options[0])
      
      case selection
      when '佐川急便'
        convert_amazon_to_sagawa(file)
      when 'ヤマト'
        convert_amazon_to_yamato(file)
      when '日本郵便（定型便）'
        convert_amazon_to_japanpost(file)
      when 'クリックポスト'
        convert_amazon_to_clickpost(file)
      else
        JOptionPane.showMessageDialog(nil, "不明な配送業者が選択されました。", "エラー", JOptionPane::ERROR_MESSAGE)
      end
    else
      JOptionPane.showMessageDialog(nil, "テキストファイルではありません。", "エラー", JOptionPane::ERROR_MESSAGE)
    end
  end
end

frame.add(button)
frame.set_default_close_operation(JFrame::EXIT_ON_CLOSE)
frame.set_size(400, 300)
frame.set_visible(true)

# メインスレッドを保持
while true
  sleep 1
end