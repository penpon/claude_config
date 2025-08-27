# Worker Development Workflow (Integrated Command: start + tdd-cycle)

Issue Number/URL: $ARGUMENTS

## Combined Start and TDD Development Flow

### Phase 1: Work Start

#### 1.1 Issue Content Confirmation
Use GitHub CLI to fetch issue details:
```bash
# If $ARGUMENTS is a URL like https://github.com/owner/repo/issues/123
gh issue view $ARGUMENTS

# If $ARGUMENTS is just a number like 45
gh issue view $ARGUMENTS
```

#### 1.2 GitHub Issue Label Change
- Change pending → in_progress
```bash
gh issue edit $ARGUMENTS --add-label "in_progress" --remove-label "pending"
```

#### 1.3 Worktree Creation and Navigation
```bash
git worktree add -b issue-{ISSUE_NUMBER}-{SHORT_DESC} worktrees/issue-{ISSUE_NUMBER}-{SHORT_DESC}
cd worktrees/issue-{ISSUE_NUMBER}-*
```

**Worktree Naming Convention:**
- Format: `issue-[issue-number]-[brief-description]`
- Example: `issue-123-user-auth`

#### 1.4 Impact Investigation with Task tool
- Pre-implementation dependency confirmation
- Impact scope identification for large-scale changes

### Phase 2: TDD Development Cycle

#### RGRC (Red, Green, Refactor, Commit) Cycle Continuous Execution

##### Red Phase
- Create only one failing test (specific, small, clearly expressing specifications)
- Execute and confirm failure

**Quality Check:**
- [ ] Confirm this is new test addition (modifying existing tests is prohibited)

##### Green Phase
- Minimal implementation to pass the test (fake implementation or hardcoding is acceptable)
- Always confirm that tests pass

**Quality Check:**
- [ ] Implementation does not depend on test-specific data values
- [ ] Adheres to test data dependency prohibition principle

##### Refactor Phase
- Code improvement while maintaining tests (remove duplication, improve readability, design improvement)
- Tests are also refactoring targets
- Use code-review-specialist agent for comprehensive code review

**Quality Check:**
- [ ] Fixed implementation side when tests failed
- [ ] Adheres to test code modification prohibition principle

##### Commit Phase
Record with appropriate commit messages upon completion of each phase:
- [ ] **Mandatory execution**: Record with appropriate commit messages:
  - **RED**: [Test Case Name] (#{ISSUE_NUMBER})
  - **GREEN**: [Implementation Content] (#{ISSUE_NUMBER})
  - **REFACTOR**: [Improvement Content] (#{ISSUE_NUMBER})

```bash
~/.claude/hooks/github-progress.sh 'Git-Commit'
```

**Quality Check:**
- [ ] Build succeeds (confirmed with appropriate build command for the project)
- [ ] All tests pass
- [ ] Resolved warnings from newly added code (existing warnings are excluded)
- [ ] Did not modify test code
- [ ] Did not implement code dependent on test data

#### TODO List Management
Divide features to be implemented into small parts and list them

#### Quality Management Principles

**Test Code Modification Prohibition Principle**
**Basic Principle**: Test code modification is prohibited (tests represent specifications)

- Test failure → Fix implementation side
- Test is incorrect → Stop work and ask user for confirmation

**Exception Cases**
- When requested to add/modify test tasks
- When there are syntax errors, specification conflicts, or API compatibility issues
※Even in above cases, stop work and ask user for confirmation

**Test Data Dependency Prohibition Principle**
Implementation code is basically prohibited from special handling of specific data values used in tests.
Specific data values include, for example, variable names or table names.

**Problems**:
- Fragile tests: Implementation becomes non-functional when test data changes
- Hidden specifications: Special processing for specific data names becomes implicit rather than explicit specifications
- Lack of generality: May not function in actual operational environments

---

Beginning development workflow for **$ARGUMENTS**.
First confirm issue requirements, then start TDD development cycle.