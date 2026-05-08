# New Emolgame サイトのタスクランナー
# 使い方: `just <recipe>` / 一覧: `just` または `just --list`

set shell := ["bash", "-cu"]

# レシピ一覧を表示（デフォルト）
default:
    @just --list

# ローカルサーバーを起動（デフォルト: http://localhost:8000/）
# 例: `just up` / `just up 3000`
up port="8000":
    @echo "Serving on http://localhost:{{port}}/"
    uv run python -m http.server {{port}}

# 指定ポートを掴んでいるプロセスを停止（デフォルト: 8000）
# 例: `just down` / `just down 3000`
down port="8000":
    #!/usr/bin/env bash
    set -uo pipefail
    pids=$(lsof -ti :{{port}} 2>/dev/null || true)
    if [ -z "$pids" ]; then
      echo "ポート {{port}} を使用中のプロセスはありません"
    else
      echo "ポート {{port}} を使用中のプロセス (PID: $pids) を停止します"
      kill -9 $pids
      echo "停止しました"
    fi

# pre-commit フックをインストール（初回のみ）
install-hooks:
    uvx pre-commit install

# 全ファイルに pre-commit を実行（CI 等価）
pre-commit:
    uvx pre-commit run --all-files

# すべての lint を実行
lint: lint-html lint-css lint-format

# HTML lint
lint-html:
    npx --yes htmlhint@^1 "**/*.html" --ignore "node_modules/**"

# CSS lint
lint-css:
    npx --yes -p stylelint@^16 -p stylelint-config-standard@^36 stylelint "**/*.css" --ignore-path .gitignore

# Prettier フォーマットチェック
lint-format:
    npx --yes prettier@^3 --check "**/*.{html,css,md,json,yml,yaml}"

# フォーマット・自動修正
fmt:
    npx --yes prettier@^3 --write "**/*.{html,css,md,json,yml,yaml}"
    npx --yes -p stylelint@^16 -p stylelint-config-standard@^36 stylelint "**/*.css" --fix
