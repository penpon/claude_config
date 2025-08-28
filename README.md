# Claude Code Configuration

Claude Codeの課金を辞めるので個人的に使っていたファイル群を最後にまとめておこうかなと思いました

エッセンスだけいい具合に抽出していただければと思います

# 📝 使用感・課題

## うまくいった点
- [英語](https://qiita.com/ussu_ussu_ussu/items/8fc321c16ba8644576a7) + [XML](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags)の組み合わせ: 多分品質向上した
- **bossとworkerのワークフロー**: 役割明確化により、コンテキストウインドウの効率的な活用ができた
- **TDD + RGRCサイクル + worktreeの組み合わせ**: 品質向上に加え、メインブランチを汚すことがなくなった
- **GitHub Actions連携**: markdownでタスク管理をしていたときもあったが、Issueの方が管理しやすかった

## 課題だった点
- **エージェントの活用不足**: 公式のcode-review-specialist程度しか使ってなかった
- **フックの動作不安定**: フローを忘却して自動化スクリプトが期待通りに動かないことがしばしば
- **設定の複雑化**: 煩雑になり管理がめんどくさくなった
- **rate limit対応**: Claude Codeの制限が厳しくなり使いにくくなった
- **TDDサイクルとGitHub Actions**: フローを忘却して連携が取れないことがしばしば

# 📁 プロジェクト構成

```
.claude/
├── CLAUDE.md                     # 基本プロジェクト指示書
├── settings.json                 # Claude Code基本設定
├── agents/                       # 専用エージェント
│   ├── code-review-specialist.md # コードレビュー専門エージェント
│   └── debug-specialist.md       # デバッグ専門エージェント
├── commands/                     # カスタムスラッシュコマンド
│   ├── boss/                     # タスク管理・分析系
│   │   ├── analyze.md
│   │   ├── full.md
│   ├── worker/                   # 実装作業系
│   │   ├── full.md
│   └── env/                      # 環境設定系
│       └── python-setup.md
└── hooks/                         # 自動化フック
    ├── auto-format.sh             # 自動フォーマット
    ├── github-completion.sh       # GitHub完了処理
    └── github-progress.sh         # GitHub進捗管理
```

# 🚀 使用方法

事前に[Claude Code GitHub Actions](https://docs.anthropic.com/ja/docs/claude-code/github-actions)の設定が必要です

```
1. /boss/full "todoアプリを作って"
大体plan modeと併用しています。
周辺ディレクトリの調査をして、計画を立案します。
計画時にはultrathinkを必須にしています。
その後、タスクを完遂する上で必要なタスクのissueを作成します。

2. /worker/full "issue01から05を実行して"
どこまでのissueを実行するのかはコンテキストウインドウとの相談です。
git worktreeを利用しています。
TDDとRGRC(red->green->refactor->commit)サイクルを採用しています。
```

# 📄 ファイル別詳細説明

## ⚙️ 設定ファイル

### `.claude/CLAUDE.md` - 基本プロジェクト指示書
Claude Codeに対する基本指示を記載
- **日本語応答必須**、README.md読み込み必須
- develop直接編集禁止、worktree必須
- 通知音設定、一時ファイルクリーンアップ
- 並列ツール実行
- boss/worker役割システム、各種操作設定

### `.claude/settings.json` - Claude Code基本設定
Claude Codeの実行権限とフック設定
- **permissions**: --dangerously-skip-permissionsを使っていたのでメンテしてない
- **hooks**: PostToolUseでauto-format.sh、Notificationでサウンド通知とmacOSダイアログ表示

## 🛠️ Custom Slash commands

### 👨‍💼 Boss系コマンド（タスク管理・分析）

#### `/boss/full.md` - 完全ワークフロー
探索→計画→チェック→Issue作成の4段階フロー
- **Phase 1**: 関連ファイル調査、Task tool活用、アーキテクチャ理解
- **Phase 2**: ultrathink採用、詳細計画作成、ファイル特定、依存関係整理
- **Phase 3**: 実装の厳密レビュー、問題特定、代替案検討
- **Phase 4**: GitHubのIssue作成、依存管理、worktree命名規則、タスク指示形式

**メインで使っていたフロー**

#### `/boss/analyze.md` - 分析ワークフロー
探索→計画→チェックの3段階（Issue作成なし）
- fullからIssue作成を除いた軽量版
- 調査のみで実施したい場合に使用

**issueの作成は不要だが、軽く調査したいときに使っていた**

### 💻 Worker系コマンド（実装作業）

#### `/worker/full.md` - 完全実装ワークフロー
作業開始→TDD開発→タスク完了の3段階
- **Phase 1**: Issue確認、ラベル変更(pending→in_progress)、worktree作成、影響調査
- **Phase 2**: RGRCサイクル(Red→Green→Refactor→Commit)の繰り返し実行
- **Phase 3**: 品質チェック、完了報告、develop merge、Issue完了・cleanup

**メインで使っていたフロー**

### 🔧 Environment系コマンド

#### `/env/python-setup.md` - Python環境構築
uv使用のPython仮想環境セットアップ手順

**ちゃんと使われているのかは謎**

## 🤖 Custom Subagents

### `.claude/agents/code-review-specialist.md` - コードレビュー専門エージェント
コード品質・セキュリティ・保守性の包括的レビュー
- **5つの優先領域**: セキュリティ分析、コード品質評価、パフォーマンス検討、保守性レビュー、テスト・信頼性
- **Context7連携**: ライブラリのベストプラクティス取得
- **出力形式**: 要約→重要度別分類→具体的推奨事項→強み評価

**workerで呼び出すフローにはなっているけどあまり呼び出されている感じはなかったかも**

### `.claude/agents/debug-specialist.md` - デバッグ専門エージェント
エラー・予期しない動作の系統的調査・解決
- **5段階方法論**: 情報収集、ultrathink分析、仮説形成、系統的調査、解決実装
- **ブラウザデバッグ**: mcp-playwright tools活用
- **出力形式**: 問題要約→根本原因→解決策→テスト方法→予防策

**1度も出番がなかった**

## 🔗 Hooks

### `.claude/hooks/auto-format.sh` - 自動フォーマット
ファイル編集時の自動コードフォーマット
- **JavaScript/TypeScript**: Biome使用
- **Python**: Black + Ruff使用

**適切に動いているのか謎だった**

### `.claude/hooks/github-progress.sh` - GitHub進捗管理
TDDサイクル進捗のGitHub Issue自動コメント投稿
- **対応ツール**: Edit/Write/MultiEdit、手動Git-Commit実行時
- **RGRCフェーズ検知**: コミットメッセージからRED/GREEN/REFACTORを検知
- **コメント形式**: タイムスタンプ、アイコン、コミットリンク付き

**workerが適切に起動してくれないことがしばしば**

### `.claude/hooks/github-completion.sh` - GitHub完了処理
タスク完了時の自動レポート生成・投稿
- **自動抽出**: コミット履歴から実装内容、技術改善点、影響・利点を分析
- **統計情報**: 新規/変更ファイル数、コミット数
- **レポート構成**: 完了タスク、技術改善、影響利点の3セクション

**workerが適切に起動してくれないことがしばしば**
