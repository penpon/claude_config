# Boss Task Management Phase

Management Target: $ARGUMENTS

## Task Management Phase Execution Details

### 1. GitHub Issue Creation
- **Always use only "pending" label**
- Create each task as individual issue
- Record detailed work contents

### 2. Dependency Management
- Instruct sequential execution for tasks modifying the same files
- Record dependencies in issue body
- Clarify execution order

### 3. Worktree Naming Convention
- Format: `issue-[issue-number]-[brief-description]`
- Record naming convention in issue body

### 4. Task Instruction Format
Record details in each issue using the following format:

```
# [Task Name]

## Task Overview
[Description]

## Files to be Modified
- [File Path 1]
- [File Path 2]

## Prerequisite Tasks
- [ ] #[issue-number] [dependent-task-name]

## Worktree Name
issue-[issue-number]-[brief-description]

## Work Contents
- [ ] [Specific Work 1]
- [ ] [Specific Work 2]
```

---

Beginning task management for **$ARGUMENTS**.
Please create GitHub issues based on the previous plan and manage tasks.