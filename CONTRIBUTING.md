# コントリビューションガイド

New Emolgame サイトの開発に参加していただきありがとうございます！
このドキュメントは、リポジトリへの貢献方法・コーディング規約・PR 作成ルールをまとめたものです。

## 目次

- [開発の進め方](#開発の進め方)
- [ブランチ運用](#ブランチ運用)
- [コミットメッセージ](#コミットメッセージ)
- [コーディング規約](#コーディング規約)
- [Lint / Format](#lint--format)
- [PR 作成ルール](#pr-作成ルール)
- [CI](#ci)

## 開発の進め方

1. リポジトリを clone（or fork）
2. `main` から作業ブランチを切る
3. ローカルで動作確認（README の「ローカルでの動作確認」を参照）
4. push して PR を作成
5. レビュー後、`main` にマージ → GitHub Pages が自動デプロイ

## ブランチ運用

- ベースブランチ: `main`
- 作業ブランチ命名: `<type>/<短い説明>` 形式

| Prefix      | 用途                           |
| ----------- | ------------------------------ |
| `feature/`  | 新機能・新ページ追加           |
| `fix/`      | バグ修正                       |
| `docs/`     | ドキュメント / README 更新     |
| `style/`    | デザイン・CSS の調整           |
| `refactor/` | 動作を変えないリファクタリング |
| `chore/`    | 設定ファイル・CI など雑務系    |
| `content/`  | 記事追加・コンテンツ更新       |

例: `feature/add-search`, `fix/header-overflow`, `content/2026-spring-build`

## コミットメッセージ

[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) に準拠することを推奨します。

```
<type>(<scope>): <subject>

例:
feat(builds): 構築記事の絞り込みタグを追加
fix(header): スマホ表示でロゴが折り返す不具合を修正
docs(readme): デプロイ手順を追記
chore(ci): HTMLHint を導入
```

主な type: `feat` / `fix` / `docs` / `style` / `refactor` / `chore` / `ci` / `content`

日本語タイトル可。1行72文字以内推奨。

## コーディング規約

### 共通

- **文字コード**: UTF-8
- **改行コード**: LF
- **インデント**: スペース 2
- **末尾空白**: 削除
- **ファイル末尾**: 改行を入れる

これらは `.editorconfig` で機械的に強制しています。VS Code の場合は [EditorConfig 拡張](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) を入れてください。

### HTML

- DOCTYPE は `<!DOCTYPE html>`
- `<html lang="ja">` を必ず付ける
- 各ページの `<title>` は `ページ名 | New Emolgame` 形式に揃える
- `<img>` には必ず `alt` 属性を付ける
- 属性値はダブルクオートで囲む

### CSS

- カラーパレットは `:root` の CSS 変数（`--sky`, `--yellow`, `--dark` 等）を再利用する
  - 新しい色を直接書かず、必要なら変数を追加してから使う
- 共通スタイルは `style.css`、ページ固有スタイルは各HTMLの `<style>` ブロック内
- スマホ表示（375px〜）でレイアウト崩れがないことを必ず確認する

### ファイル / 命名

- 画像ファイル名: 小文字 + ハイフン区切り（例: `hero-emolga.png`）
- HTML ファイル名: 小文字（例: `tournament.html`）

## Lint / Format

ローカルで実行する場合は Node.js (>= 20)、[`uv`](https://docs.astral.sh/uv/)、[`just`](https://github.com/casey/just) が必要です（`brew install uv just` で導入できます）。

### pre-commit による自動チェック（推奨）

リポジトリには [`pre-commit`](https://pre-commit.com/) の設定が含まれており、`git commit` のタイミングで Prettier / Stylelint / HTMLHint が自動実行されます。clone 後に一度だけ次を実行してください。

```bash
just install-hooks
```

これ以降は `git commit` するたびに変更ファイルだけに対して lint・整形が走ります。整形によりファイルが書き換わった場合はコミットが中断されるので `git add` し直して再コミットしてください。

全ファイルに対して走らせたい場合は次のコマンドを使います（CI と同等のチェック）。

```bash
just pre-commit
```

### 個別レシピ

`just` 経由で必要な lint だけ走らせたい場合は以下のレシピが使えます。

```bash
just lint           # HTML / CSS / フォーマットの lint をまとめて実行
just fmt            # Prettier と Stylelint で自動修正
just lint-html      # HTMLHint
just lint-css       # Stylelint
just lint-format    # Prettier --check
```

### `just` を使わない場合

`npx` で直接実行することもできます。

```bash
npx htmlhint "**/*.html"
npx stylelint "**/*.css"
npx prettier --check "**/*.{html,css,md,json,yml}"

npx prettier --write "**/*.{html,css,md,json,yml}"
npx stylelint --fix "**/*.css"
```

## PR 作成ルール

1. PR テンプレート（`.github/PULL_REQUEST_TEMPLATE.md`）に従って記入する
2. UI 変更がある場合は **Before / After のスクリーンショット** を添付する
3. CI（Lint / Link Check）が通っていることを確認する
4. レビュー → 1人以上の approve でマージ

### マージ方式

- 原則 **Squash and merge** を推奨（履歴をきれいに保つため）
- マージ後は作業ブランチを削除する

## CI

このリポジトリでは GitHub Actions で以下を自動実行します。

| ワークフロー  | トリガー             | 内容                                |
| ------------- | -------------------- | ----------------------------------- |
| Lint          | push / PR (`main`)   | HTMLHint / Stylelint / Prettier     |
| Link Check    | push / PR / 毎週月曜 | lychee による外部リンク切れチェック |
| Lighthouse CI | PR / 手動            | パフォーマンス・SEO・A11y 計測      |

CI が落ちた場合は PR 内のログで詳細を確認してください。

---

ご不明点があれば Issue でお気軽にどうぞ！
