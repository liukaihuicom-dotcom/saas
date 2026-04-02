#!/bin/bash
# auto-sync-to-github.sh
# 自动检测变更 → 提交 → 推送到 GitHub
# 使用方法: bash /Users/liukaihui/Documents/Work\ harvey/Saas/scripts/auto-sync-to-github.sh

REPO_DIR="/Users/liukaihui/Documents/Work harvey/Saas"
REMOTE="origin"
BRANCH="main"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

cd "$REPO_DIR" || exit 1

# 确保在正确的分支
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH"

# 拉取远程最新（避免冲突）
git pull "$REMOTE" "$BRANCH" --rebase 2>/dev/null || true

# 检查是否有变更
if [ -n "$(git status --porcelain)" ]; then
    # 添加所有变更
    git add -A

    # 生成提交信息
    CHANGED_FILES=$(git diff --cached --name-only | wc -l | tr -d ' ')
    COMMIT_MSG="🔄 Auto sync: ${CHANGED_FILES} file(s) changed [${TIMESTAMP}]"

    git commit -m "$COMMIT_MSG"

    # 推送
    git push "$REMOTE" "$BRANCH"

    echo "✅ Synced at ${TIMESTAMP}: ${CHANGED_FILES} file(s) pushed to GitHub"
else
    echo "⏭️  No changes at ${TIMESTAMP}, skip push."
fi
