#!/bin/bash

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 現在のworktreeからissue番号を抽出
BRANCH=$(git branch --show-current 2>/dev/null)
if [[ ! $BRANCH =~ issue-([0-9]+) ]]; then
    echo "Error: issueブランチではありません"
    exit 1
fi
ISSUE_NUM=${BASH_REMATCH[1]}

# issue内容を取得
ISSUE_TITLE=$(gh issue view $ISSUE_NUM --json title | jq -r '.title // ""')
ISSUE_BODY=$(gh issue view $ISSUE_NUM --json body | jq -r '.body // ""')

# 簡潔な統計情報
ADDED_FILES=$(git diff --name-status develop..HEAD 2>/dev/null | grep "^A" | wc -l | tr -d ' ')
MODIFIED_FILES=$(git diff --name-status develop..HEAD 2>/dev/null | grep "^M" | wc -l | tr -d ' ')
COMMIT_COUNT=$(git rev-list --count develop..HEAD 2>/dev/null || echo "0")

# コミットメッセージから実装内容を自動抽出
extract_implementation_details() {
    echo "## ✅ 完了したタスク"
    echo ""
    
    # コミットメッセージからPhase/段階情報を抽出
    git log --oneline develop..HEAD 2>/dev/null | tac | while read -r commit; do
        commit_msg=$(echo "$commit" | sed 's/^[a-f0-9]* //')
        
        # GREEN/RED/REFACTORコミットから主要実装を抽出
        if [[ $commit_msg =~ ^GREEN: ]]; then
            title=$(echo "$commit_msg" | sed 's/^GREEN: //' | sed 's/ - #[0-9]*$//')
            if [ -n "$title" ]; then
                echo "### $title"
                # コミットメッセージの詳細部分を抽出（複数行対応）
                commit_hash=$(echo "$commit" | cut -d' ' -f1)
                full_msg=$(git show --format=%B -s "$commit_hash" 2>/dev/null)
                details=$(echo "$full_msg" | grep '^- ' | head -5)
                if [ -n "$details" ]; then
                    echo "$details"
                else
                    echo "- 実装完了"
                fi
                echo ""
            fi
        fi
    done
    
    # issueの作業内容欄から予定タスクを抽出（### や #### で始まる行）
    if [ -n "$ISSUE_BODY" ]; then
        echo "### issue記載の主要タスク"
        echo "$ISSUE_BODY" | grep -E '^#{3,4} ' | head -5 | sed 's/^#* /- **/' | sed 's/$/:**/' 2>/dev/null 
        echo ""
    fi
}

# 技術的改善点を自動抽出
extract_technical_improvements() {
    echo "## 🔧 技術的改善点"
    echo ""
    
    # 新規作成ファイルから技術要素を推測
    new_files=$(git diff --name-only --diff-filter=A develop..HEAD 2>/dev/null)
    if [ -n "$new_files" ]; then
        echo "### 新規実装"
        echo "$new_files" | while read -r file; do
            if [[ $file =~ test.*\.py$ ]]; then
                echo "- **テストカバレッジ拡充**: \`$(basename "$file")\`"
            elif [[ $file =~ .*routes.*\.py$ ]]; then
                echo "- **APIエンドポイント**: \`$(basename "$file")\`"
            elif [[ $file =~ .*model.*\.py$ ]]; then
                echo "- **データモデル**: \`$(basename "$file")\`"
            else
                echo "- **新規モジュール**: \`$(basename "$file")\`"
            fi
        done
        echo ""
    fi
    
    # REFACTORコミットから改善点を抽出
    refactor_count=$(git log --oneline --grep="^REFACTOR:" develop..HEAD 2>/dev/null | wc -l | tr -d ' ')
    if [ "$refactor_count" -gt 0 ]; then
        echo "### コード品質向上"
        echo "- リファクタリング実施: ${refactor_count}回"
        echo ""
    fi
}

# 影響と利点を生成
extract_impact_and_benefits() {
    echo "## 🚀 影響と利点"
    echo ""
    
    # ファイル変更から影響を推測
    if [ "$ADDED_FILES" -gt 0 ]; then
        echo "### 機能拡張"
        echo "- 新機能追加: ${ADDED_FILES}個のモジュール"
    fi
    
    if [ "$MODIFIED_FILES" -gt 0 ]; then
        echo "### 既存機能改善"
        echo "- 機能強化: ${MODIFIED_FILES}個のモジュール更新"
    fi
    
    # テストファイルの存在確認
    test_files=$(git diff --name-only develop..HEAD 2>/dev/null | grep -c "test.*\.py$" || echo "0")
    if [ "$test_files" -gt 0 ]; then
        echo "### 品質保証"
        echo "- テスト強化: ${test_files}個のテストファイル"
    fi
    
    echo ""
}

# 完了報告のコメントを生成
COMPLETION_COMMENT=$(cat <<EOF
# ${ISSUE_TITLE} - 完了報告

$(extract_implementation_details)

$(extract_technical_improvements)

$(extract_impact_and_benefits)

---

**完了時刻**: $TIMESTAMP  
**実装統計**: 新規${ADDED_FILES}個・変更${MODIFIED_FILES}個・コミット${COMMIT_COUNT}個

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)

# コメント投稿
gh issue comment $ISSUE_NUM --body "$COMPLETION_COMMENT" 2>/dev/null && {
    echo "✅ 完了報告をissue #$ISSUE_NUM に記載しました！"
    echo "📋 コミット履歴とissue内容から自動生成"
} || {
    echo "❌ エラー: 完了報告の投稿に失敗しました"
    exit 1
}