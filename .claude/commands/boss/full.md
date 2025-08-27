# Boss Full Workflow (Integrated Command: explore + plan + manage)

<target>$ARGUMENTS</target>

## Complete Boss Management Flow

<phase name="exploration" order="1">
### Phase 1: Exploration Phase

#### 1.1 Read Related Files
<constraints>
- Do not write code (exploration only)
</constraints>
<tasks>
- Identify related files and understand their contents
</tasks>

#### 1.2 Comprehensive Investigation with Task tool
<tasks>
- Large-scale file search
- Impact scope identification
</tasks>

#### 1.3 Complete Understanding of Project Structure and Requirements
<tasks>
- Architecture comprehension
- Understanding existing implementations
- Dependency identification
</tasks>
</phase>

<phase name="planning" order="2" depends-on="exploration">
### Phase 2: Planning Phase

#### 2.1 Comprehensive Plan Creation
<methodology>ultrathink</methodology>
<tasks>
- Detailed thinking process using "ultrathink"
- Consideration of overall approach
- Implementation strategy determination
</tasks>

#### 2.2 Specify Files to be Modified for Each Task
<tasks>
- Identify specific file paths
- Detail modification contents
- Clarify impact scope
</tasks>

#### 2.3 Duplication Check
<tasks>
- Identify tasks that modify the same files
- Organize dependencies
- Determine execution order
</tasks>
</phase>

<phase name="check" order="3" depends-on="planning">
### Phase 3: Check Phase

<activities>
- Critical self-review of implementation
- Identify potential issues and explore deeper solutions
</activities>

<review-process>
<instruction>Review the implementation strictly and identify any problems or improvements</instruction>
<analysis-checklist>
- [ ] Does the proposal deviate from the given instructions? (e.g., adding excessive extensibility to a simple bug fix, or implementing beyond the original purpose)
- [ ] Is this design truly optimal?
- [ ] Are there alternative approaches?
- [ ] Do tests capture the essence of specifications?
</analysis-checklist>
</review-process>
</phase>

<phase name="management" order="4" depends-on="check">
### Phase 4: Task Management Phase

#### 4.1 GitHub Issue Creation
<github-rules>
<label-constraint>Always use only "pending" label</label-constraint>
<issue-policy>Create each task as individual issue</issue-policy>
</github-rules>
<tasks>
- Record detailed work contents
</tasks>

#### 4.2 Dependency Management
<tasks>
- Instruct sequential execution for tasks modifying the same files
- Record dependencies in issue body
- Clarify execution order
</tasks>

#### 4.3 Worktree Naming Convention
<naming-convention>
<format>issue-[issue-number]-[brief-description]</format>
<requirement>Record naming convention in issue body</requirement>
</naming-convention>

#### 4.4 Task Instruction Format
<task-template>
Record details in each issue using the following format:

<template type="issue-format">
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
</template>
</task-template>
</phase>

---

<execution-start target="$ARGUMENTS">
Beginning complete Boss workflow for **<target-ref>$ARGUMENTS</target-ref>**.
Execute all four phases sequentially: exploration → planning → check → management to create detailed tasks for Workers.
</execution-start>
