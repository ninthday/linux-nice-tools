# linux-nice-tools
一些在 linux 中可以運用的小程式


## disk_analyzer.sh

### 設定執行權限及執行：

設定可執行權限：
```bash
chmod +x disk_analyzer.sh
```
執行 Shell Script：
```bash
# 一般權限執行
./disk_analyzer.sh

# 或以 root 權限執行（推薦）
sudo ./disk_analyzer.sh
```

### Script 功能特色
- 全面分析：從整體磁碟使用到具體檔案都能分析
- 安全掃描：自動處理權限問題，避免錯誤訊息
- 智慧排序：結果按大小排序，快速找到佔用空間最大的項目
- 清理建議：提供實用的系統清理命令
- 互動模式：增強版提供選單式操作，更容易使用
- 即時監控：可持續監控磁碟使用變化

這個Shell Script 會協助你快速找出系統中的「硬碟空間兇手」，讓你能有效管理和清理不必要的檔案。

## find_top_usage.sh

執行 Shell Script 情境

### 1. 查詢整個系統（最常用）
這會從根目錄 / 開始找，找出整個系統裡最佔空間的兇手。因為需要讀取系統級的目錄，所以通常需要 sudo。
```bash
sudo ./find_top_usage.sh
```
### 2. 查詢特定目錄
例如，你想看看 /var/log 目錄下是什麼東西佔用了空間。
```bash
sudo ./find_top_usage.sh /var/log
```

### 3. 查詢特定目錄並指定結果數量
例如，只想看 /home 目錄下最大的前 5 名。
```bash
sudo ./find_top_usage.sh /home 5
```
