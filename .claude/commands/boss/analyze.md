# Boss Analysis Workflow (Integrated Command: explore + plan)

Target: $ARGUMENTS

**Note**: This command combines the functionality of `/boss/explore` and `/boss/plan` into a single integrated workflow.

## Combined Exploration and Planning Flow

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

---

Beginning exploration and planning for **$ARGUMENTS**.
First explore the codebase comprehensively, then create a detailed implementation plan.
