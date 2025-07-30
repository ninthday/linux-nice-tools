#!/bin/bash

# ==============================================================================
# 腳本名稱: disk_analyzer.sh
# 功    能: 硬碟空間分析工具，提供多種功能
# 腳本功能特色
# 全面分析：從整體磁碟使用到具體檔案都能分析
# 安全掃描：自動處理權限問題，避免錯誤訊息
# 智慧排序：結果按大小排序，快速找到佔用空間最大的項目
# 清理建議：提供實用的系統清理命令
# 互動模式：增強版提供選單式操作，更容易使用
# 即時監控：可持續監控磁碟使用變化
# 這個腳本會協助你快速找出系統中的「硬碟空間兇手」，讓你能有效管理和清理不必要的檔案。
# ==============================================================================

# 互動式硬碟空間分析工具

show_menu() {
    echo "===== 硬碟空間分析工具 ====="
    echo "1. 快速概覽"
    echo "2. 詳細目錄分析"
    echo "3. 大檔案搜尋"
    echo "4. 系統清理建議"
    echo "5. 自訂路徑分析"
    echo "6. 即時監控模式"
    echo "0. 退出"
    echo "請選擇功能 (0-6): "
}

quick_overview() {
    echo "快速概覽："
    echo "=========="
    df -h
    echo
    echo "最大目錄 (前5名)："
    du -h --max-depth=1 / 2>/dev/null | sort -hr | head -5
}

detailed_analysis() {
    echo "請輸入要分析的路徑 (預設為 /):"
    read -r path
    path=${path:-/}

    echo "分析路徑: $path"
    echo "=================="
    du -h --max-depth=2 "$path" 2>/dev/null | sort -hr | head -20
}

find_large_files() {
    echo "請輸入最小檔案大小 (例如: 100M, 1G，預設 100M):"
    read -r size
    size=${size:-100M}

    echo "搜尋大於 $size 的檔案："
    echo "======================"
    find / -type f -size +$size -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -15
}

cleanup_suggestions() {
    echo "系統清理建議："
    echo "=============="

    # 計算可清理的空間
    cache_size=$(du -sh /var/cache/apt 2>/dev/null | cut -f1)
    log_size=$(du -sh /var/log 2>/dev/null | cut -f1)

    echo "APT 快取大小: $cache_size"
    echo "日誌檔案大小: $log_size"
    echo

    echo "建議清理命令："
    echo "sudo apt clean          # 清理套件快取"
    echo "sudo apt autoremove     # 移除不需要的套件"
    echo "sudo journalctl --vacuum-time=7d  # 清理舊日誌"

    echo
    echo "是否要執行 apt clean? (y/N):"
    read -r answer
    if [[ $answer =~ ^[Yy]$ ]]; then
        sudo apt clean
        echo "APT 快取已清理"
    fi
}

custom_path_analysis() {
    echo "請輸入要分析的自訂路徑:"
    read -r custom_path

    if [ -d "$custom_path" ]; then
        echo "分析 $custom_path："
        echo "==================="
        du -h --max-depth=1 "$custom_path" 2>/dev/null | sort -hr
    else
        echo "錯誤：路徑不存在或無法存取"
    fi
}

monitor_mode() {
    echo "即時監控模式 (每5秒更新，按 Ctrl+C 停止)："
    echo "==========================================="

    while true; do
        clear
        echo "$(date) - 硬碟使用情況："
        df -h | head -5
        echo
        echo "目前最大程序的磁碟使用："
        du -h --max-depth=1 / 2>/dev/null | sort -hr | head -3
        sleep 5
    done
}

# 主要執行迴圈
while true; do
    show_menu
    read -r choice

    case $choice in
    1) quick_overview ;;
    2) detailed_analysis ;;
    3) find_large_files ;;
    4) cleanup_suggestions ;;
    5) custom_path_analysis ;;
    6) monitor_mode ;;
    0)
        echo "再見！"
        exit 0
        ;;
    *) echo "無效選項，請重新選擇" ;;
    esac

    echo
    echo "按 Enter 繼續..."
    read -r
    clear
done
