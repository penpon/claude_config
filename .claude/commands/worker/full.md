# Worker Full Workflow (Integrated Command: start + tdd-cycle + task-complete)

<issue-target>$ARGUMENTS</issue-target>

## Complete Worker Work Flow

<phase name="work-start" order="1">
### Phase 1: Work Start

#### 1.1 Issue Content Confirmation
<github-operation type="issue-fetch">
<command>gh issue view $ARGUMENTS</command>
</github-operation>

#### 1.2 GitHub Issue Label Change
<github-operation type="label-change">
<label-transition from="pending" to="in_progress" />
<command>gh issue edit $ARGUMENTS --add-label "in_progress" --remove-label "pending"</command>
</github-operation>

#### 1.3 Worktree Creation and Navigation
<worktree-operation>
<command>git worktree add -b issue-{ISSUE_NUMBER}-{SHORT_DESC} worktrees/issue-{ISSUE_NUMBER}-{SHORT_DESC}</command>
<command>cd worktrees/issue-{ISSUE_NUMBER}-*</command>
<naming>Format: issue-[number]-[description] (e.g., issue-123-user-auth)</naming>
</worktree-operation>

#### 1.4 Development Planning and Impact Investigation
<tasks>
- Pre-implementation dependency confirmation with Task tool
- Impact scope identification for large-scale changes
- **TodoWrite tool**: Divide implementation into small, trackable tasks
</tasks>
</phase>

<phase name="tdd-cycle" order="2" depends-on="work-start" repeatable="true">
### Phase 2: TDD Development Cycle

<tdd-methodology>RGRC (Red, Green, Refactor, Commit)</tdd-methodology>

<tdd-phase name="red" order="1">
##### Red Phase
<step order="1" name="test-creation">
- [ ] Create one failing test (specific, small, clear specifications)
</step>
<step order="2" name="test-execution">
- [ ] Execute and confirm failure
</step>
<step order="3" name="quality-check">
- [ ] New test addition confirmed (modifying existing tests prohibited)
- [ ] Test modification rule followed (fix implementation, not tests)
- [ ] Test fails as expected
</step>
<step order="4" name="progress-report">
- [ ] Run: ~/.claude/hooks/github-progress.sh 'Git-Commit-Red'
</step>
</tdd-phase>

<tdd-phase name="green" order="2" depends-on="red">
##### Green Phase
<step order="1" name="minimal-implementation">
- [ ] Minimal implementation to pass the test (fake implementation or hardcoding acceptable)
</step>
<step order="2" name="test-confirmation">
- [ ] Always confirm that tests pass
</step>
<step order="3" name="quality-check">
- [ ] Implementation independent of test-specific data values
- [ ] Test modification rule followed (fix implementation, not tests)
- [ ] All tests pass
</step>
<step order="4" name="progress-report">
- [ ] Run: ~/.claude/hooks/github-progress.sh 'Git-Commit-Green'
</step>
</tdd-phase>

<tdd-phase name="refactor" order="3" depends-on="green">
##### Refactor Phase
<step order="1" name="code-improvement">
- [ ] Code improvement while maintaining tests (remove duplication, improve readability)
- [ ] Tests are also refactoring targets
</step>
<step order="2" name="code-review">
- [ ] **code-review-specialist agent**: Comprehensive code review
</step>
<step order="3" name="quality-check">
- [ ] Build succeeds
- [ ] Code quality improved without behavior changes
- [ ] Warnings from new code resolved
- [ ] Test modification rule followed (behavior preserved)
- [ ] Implementation remains independent of test-specific data values
</step>
<step order="4" name="progress-report">
- [ ] Run: ~/.claude/hooks/github-progress.sh 'Git-Commit-Refactor'
</step>
</tdd-phase>
</phase>

<phase name="task-completion" order="3" depends-on="tdd-cycle" mandatory="true">
### Phase 3: Task Completion

<completion-checklist mandatory="true">
#### Mandatory Execution: Complete the following procedures one by one reliably

<step order="1" name="process-confirmation">
- [ ] Progress posting after RED/GREEN/REFACTOR commits executed
</step>
<step order="2" name="quality-check">
- [ ] Build succeeds
- [ ] All tests pass
- [ ] Warnings from new code resolved
</step>
<step order="3" name="completion-report">
- [ ] Run: ~/.claude/hooks/github-completion.sh
</step>
<step order="4" name="issue-comment">
- [ ] Post comment to issue #[issue number] with prompt content
</step>
<step order="5" name="develop-merge">
- [ ] Merge to develop branch and push
```bash
git checkout develop
git merge issue-{ISSUE_NUMBER}-{SHORT_DESC} --no-ff
git push origin develop
```
</step>
<step order="6" name="cleanup">
- [ ] Change label: in_progress → completed
- [ ] Close issue
- [ ] Remove worktree: git worktree remove worktrees/issue-{ISSUE_NUMBER}-{SHORT_DESC}
</step>
</completion-checklist>
</phase>

---

<error-handling>
**Important**: If any procedure fails, use debug-specialist agent for systematic investigation, then stop work and ask user for confirmation
</error-handling>

<execution-start issue="$ARGUMENTS">
Beginning complete Worker workflow for issue #<issue-ref>$ARGUMENTS</issue-ref>.
</execution-start>
