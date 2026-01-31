#!/bin/bash
set -e

# カラー出力用
RED='\033[0;31m'
NC='\033[0m' # No Color

# ステージングされたファイルを取得
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# .env.keys がステージングされていないかチェック
if echo "$STAGED_FILES" | grep -qE '\.env\.keys$'; then
  echo -e "${RED}❌ 重大なエラー: .env.keys ファイルはコミットできません！${NC}"
  echo -e "${RED}   このファイルには暗号化キーが含まれており、絶対にコミットしてはいけません。${NC}"
  echo ""
  echo "ステージングから削除してください:"
  echo "  git reset HEAD .env.keys"
  exit 1
fi

exit 0
