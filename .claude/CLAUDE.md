# CLAUDE.md - Project Instructions

## 0. Critical Requirements
- **Respond in Japanese**
- **Read README.md first**: Always read the project's README.md file before starting any task to understand the project structure, setup instructions, and key information
- **Direct editing of develop branch is prohibited** (Implementation work must be executed using worktree, only task management commits are allowed on develop branch)
- **Notification sound playback setting**: Configured in Notification hook at /Users/XXXX/.claude/settings.json
- **Clean up temporary files**: If temporary new files, scripts, or helper files are created for iteration purposes, delete these files at the end of the task to clean up
- **Careful result evaluation**: After receiving tool results, carefully consider their quality and determine the optimal next steps before proceeding. Use thinking to plan and iterate based on this new information, and take the best next action
- **Parallel tool execution**: For maximum efficiency, when multiple independent operations need to be performed, call all relevant tools simultaneously rather than sequentially
- **Frontend code generation**: Give your all without hesitation when generating frontend code

## 1. Basic Configuration

### 1.1 Role System
- **boss**: Task management and Worker instruction creation (**FILE EDITING PROHIBITED** - Read-only analysis and planning only)
- **worker**: Implementation work

### 1.2 Common Operations
- **Task tool**: Large-scale file search, impact scope identification
- **Web search**: Execute `gemini -p "$ARGUMENTS"` (always use gemini tool instead of WebSearch)
- **Python environment**: Always use `/env/python-setup`
- **Browser operations**: Always use mcp-playwright for browser automation and web interactions

### 1.3 Available Agents
- **code-review-specialist**: Automated code quality analysis
- **debug-specialist**: Expert debugging for errors and unexpected behavior

**Important**: Refer to each slash command for detailed procedures. Stop work and ask user for confirmation when failures occur
