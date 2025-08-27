# Worker Task Completion Procedure

Issue Number: $ARGUMENTS

## Mandatory Execution: Complete the following procedures one by one reliably

### [ ] Process Confirmation Complete
- [ ] Executed progress posting after RED/GREEN/REFACTOR commits

### [ ] Quality Check Complete
- [ ] Build succeeds (confirmed with appropriate build command for the project)
- [ ] All tests pass
- [ ] Resolved warnings from newly added code (existing warnings are excluded)

**TDD Quality Principles**
**Test Code Modification Prohibition Principle**: Test code modification is prohibited (tests represent specifications)
- Test failure → Fix implementation side
- Test is incorrect → Stop work and ask user for confirmation

**Test Data Dependency Prohibition Principle**: Implementation code is basically prohibited from special handling of specific data values used in tests.

### [ ] Completion Report
```bash
~/.claude/hooks/github-completion.sh
```

### [ ] Issue Comment Posting
- [ ] **Post issue comment**: Post the following commit message content as a comment to issue #[issue number]
  - Commit message format:
    ```
    Prompt: 
    [Record user's actual statement as-is]
    ```

### [ ] Develop Merge and Remote Update
```bash
git checkout develop
git merge issue-{ISSUE_NUMBER}-{SHORT_DESC} --no-ff
git push origin develop
```

### [ ] Issue Completion and Environment Cleanup
**GitHub Issue Label Management:**
1. **in_progress** → **completed** (when completing work)
2. Close issue

**Worktree Deletion:**
```bash
git worktree remove worktrees/issue-{ISSUE_NUMBER}-{SHORT_DESC}
```

---

**Important**: If any procedure fails, stop work and ask user for confirmation

Beginning completion procedure for issue #$ARGUMENTS.