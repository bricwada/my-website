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

# 変更ファイルに対して pre-commit を実行（差分のみ対象）
pre-commit:
    uvx pre-commit run

# 全ファイルに pre-commit を実行（CI 等価のチェック）
# 整形による差分が出た場合は exit 非 0 で終了する
lint:
    uvx pre-commit run --all-files

# 全ファイルに pre-commit を実行して自動修正（差分が出ても exit 0）
fmt:
    -uvx pre-commit run --all-files

# 個別: HTML lint
lint-html:
    uvx pre-commit run htmlhint --all-files

# 個別: CSS lint
lint-css:
    uvx pre-commit run stylelint --all-files

# 個別: Prettier フォーマットチェック / 整形
lint-format:
    uvx pre-commit run prettier --all-files
