#!/bin/bash

# ==============================================================================
# 腳本名稱: find_top_usage.sh
# 功    能: 查找指定路徑下最大的檔案與目錄
# 作    者: 程式夥伴
# 版    本: 1.0
# 使    用: ./find_top_usage.sh [路徑] [顯示數量]
# ==============================================================================

# --- 預設變數 ---

# 如果使用者未提供路徑，預設搜尋根目錄 "/"
SEARCH_PATH=${1:-"/"}

# 如果使用者未提供顯示數量，預設顯示前 20 筆
NUM_LINES=${2:-20}

# --- 函數定義 ---

# 顯示使用說明
usage_help() {
    echo "功能: 在指定路徑下，找出最佔用空間的檔案與目錄。"
    echo "用法: $0 [搜尋路徑] [顯示數量]"
    echo
    echo "參數說明:"
    echo "  [搜尋路徑]    (可選) 你想要檢查的目錄路徑。預設為根目錄 '/'。"
    echo "  [顯示數量]    (可選) 你想要顯示前幾名的結果。預設為 20。"
    echo
    echo "範例:"
    echo "  $0              # 查詢整個系統中最大的 20 個檔案/目錄"
    echo "  $0 /home/user   # 查詢 /home/user 目錄下最大的 20 個檔案/目錄"
    echo "  $0 /var/log 10  # 查詢 /var/log 目錄下最大的 10 個檔案/目錄"
    exit 1
}

# --- 主程式邏輯 ---

# 檢查使用者是否尋求幫助
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage_help
fi

# 檢查提供的路徑是否存在且為目錄
if [ ! -d "$SEARCH_PATH" ]; then
    echo "錯誤: 目錄 '$SEARCH_PATH' 不存在。" >&2
    usage_help
fi

echo "---"
echo "🔍 正在查詢 '$SEARCH_PATH' 中最大的 $NUM_LINES 個檔案與目錄..."
echo "⏳ 這個過程可能需要幾分鐘，特別是查詢根目錄 '/' 時，請耐心等候。"
echo "---"

# 核心指令
# 使用 sudo 是為了確保有權限讀取所有目錄，避免出現大量 "Permission denied" 錯誤訊息
# 如果你只是想查詢自己的家目錄，可以不加 sudo
sudo du -ah "$SEARCH_PATH" 2>/dev/null | sort -hr | head -n "$NUM_LINES"

echo "---"
echo "✅ 查詢完成。"
