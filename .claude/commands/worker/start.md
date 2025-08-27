# Worker Work Start

Issue Number/URL: $ARGUMENTS

## Work Start Procedure

### 1. Issue Content Confirmation
Use GitHub CLI to fetch issue details:
```bash
# If $ARGUMENTS is a URL like https://github.com/owner/repo/issues/123
gh issue view $ARGUMENTS

# If $ARGUMENTS is just a number like 45
gh issue view $ARGUMENTS
```

### 2. GitHub Issue Label Change
- Change pending → in_progress
```bash
gh issue edit $ARGUMENTS --add-label "in_progress" --remove-label "pending"
```

### 3. Worktree Creation and Navigation
```bash
git worktree add -b issue-{ISSUE_NUMBER}-{SHORT_DESC} worktrees/issue-{ISSUE_NUMBER}-{SHORT_DESC}
cd worktrees/issue-{ISSUE_NUMBER}-*
```

**Worktree Naming Convention:**
- Format: `issue-[issue-number]-[brief-description]`
- Example: `issue-123-user-auth`

### 4. Impact Investigation with Task tool
- Pre-implementation dependency confirmation
- Impact scope identification for large-scale changes

Beginning issue content confirmation for **$ARGUMENTS**.
First, use GitHub CLI to fetch and understand the issue requirements.