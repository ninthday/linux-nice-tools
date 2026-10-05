#!/bin/bash

# ==============================================================================
# 用途：手動更新 oh-my-pi。
# 原因：官方指令 `omp update` 容易連線逾時，改由 GitHub Releases 下載執行檔覆蓋更新。
# ==============================================================================


set -euo pipefail

# 1. 檢查必要工具
for cmd in curl jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "錯誤: 系統未安裝 $cmd，請先安裝後再執行。" >&2
    exit 1
  fi
done

# 2. 自動偵測架構 (x86_64 或 aarch64)
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)  ASSET_NAME="omp-linux-x64" ;;
  aarch64) ASSET_NAME="omp-linux-arm64" ;;
  *)
    echo "錯誤: 不支援的系統架構: $ARCH" >&2
    exit 1
    ;;
esac

# 3. 取得最新版本號
LATEST_TAG=$(curl -sSf https://api.github.com/repos/can1357/oh-my-pi/releases/latest | jq -r '.tag_name // empty')
if [ -z "$LATEST_TAG" ]; then
  echo "錯誤: 無法取得最新版本號（可能遭遇 GitHub API 頻率限制）。" >&2
  exit 1
fi

echo "目前最新版本是: $LATEST_TAG"

# 4. 檢查當前版本是否已是最新 (omp --version 輸出範例: omp/18.6.1)
CURRENT_BIN=$(command -v omp || true)
if [ -n "$CURRENT_BIN" ]; then
  CURRENT_VERSION="v$("$CURRENT_BIN" --version 2>/dev/null | awk -F'/' '{print $2}')"
  if [ "$CURRENT_VERSION" = "$LATEST_TAG" ]; then
    echo "目前已是最新版本 ($CURRENT_VERSION)，無需更新。"
    exit 0
  fi
else
  # 若未安裝，預設安裝至 ~/.local/bin/omp
  mkdir -p "$HOME/.local/bin"
  CURRENT_BIN="$HOME/.local/bin/omp"
fi

# 5. 下載至暫存檔 (確保離開時自動清理)
TMP_FILE=$(mktemp /tmp/omp.XXXXXX)
trap 'rm -f "$TMP_FILE"' EXIT

echo "正在下載 $ASSET_NAME ($LATEST_TAG)..."
curl -fL --progress-bar -o "$TMP_FILE" \
  "https://github.com/can1357/oh-my-pi/releases/download/${LATEST_TAG}/${ASSET_NAME}"

chmod +x "$TMP_FILE"

# 6. 驗證新下載的 binary 能否正常執行
echo "驗證下載版本..."
"$TMP_FILE" --version >/dev/null

# 7. 備份舊版並替換
if [ -f "$CURRENT_BIN" ]; then
  cp "$CURRENT_BIN" "${CURRENT_BIN}.bak"
fi

mv "$TMP_FILE" "$CURRENT_BIN"
trap - EXIT

echo "更新完成！目前版本："
"$CURRENT_BIN" --version
