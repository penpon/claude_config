#!/bin/bash

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 現在のブランチからissue番号を抽出
BRANCH=$(git branch --show-current 2>/dev/null)
if [[ ! $BRANCH =~ issue-([0-9]+) ]]; then
    exit 0  # issueブランチでない場合は何もしない
fi
ISSUE_NUM=${BASH_REMATCH[1]}

# ツール種別による処理
TOOL_NAME="$1"
COMMENT=""

case $TOOL_NAME in
    "Edit/Write/MultiEdit")
        # 変更ファイル情報を取得
        CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null | head -3 | tr '\n' ' ')
        if [[ -n "$CHANGED_FILES" ]]; then
            COMMENT="🔧 **[$TIMESTAMP] ファイル編集**\n📁 変更ファイル: \`$CHANGED_FILES\`"
        fi
        ;;
    "Bash")
        # 何もしない（自動検知は削除）
        ;;
    "Git-Commit")
        # 手動実行時のみRGRCフェーズを検知
        COMMIT_MSG=$(git log -1 --pretty=%s 2>/dev/null)
        if [[ $COMMIT_MSG =~ ^(RED|GREEN|REFACTOR): ]]; then
            PHASE=${BASH_REMATCH[1]}
            case $PHASE in
                "RED") ICON="🔴" ;;
                "GREEN") ICON="🟢" ;;
                "REFACTOR") ICON="🔵" ;;
            esac
            
            # コミットハッシュとリポジトリURLを取得
            COMMIT_HASH=$(git log -1 --pretty=%h 2>/dev/null)
            REPO_URL=$(gh repo view --json url -q '.url' 2>/dev/null)
            
            if [[ -n "$COMMIT_HASH" && -n "$REPO_URL" ]]; then
                COMMIT_LINK="[\`$COMMIT_HASH\`]($REPO_URL/commit/$COMMIT_HASH)"
                COMMENT="$ICON **[$TIMESTAMP] $PHASE フェーズ完了**\n📝 \`$COMMIT_MSG\`\n🔗 $COMMIT_LINK"
            else
                COMMENT="$ICON **[$TIMESTAMP] $PHASE フェーズ完了**\n📝 \`$COMMIT_MSG\`"
            fi
        fi
        ;;
esac

# コメント投稿
if [[ -n "$COMMENT" ]]; then
    # echo -e を使って改行を適切に処理
    FORMATTED_COMMENT=$(echo -e "$COMMENT")
    gh issue comment $ISSUE_NUM --body "$FORMATTED_COMMENT" 2>/dev/null
fi