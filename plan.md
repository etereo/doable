# Claude Code Integration Plan for Doable Rails App

## Executive Summary

This plan integrates Claude Code's agents, skills, and slash commands into the Doable Rails 8 todo management application, drawing insights from three analyzed repositories and official Anthropic patterns.

**Analyzed Repositories:**
1. `github/spec-kit` - Spec-Driven Development toolkit
2. `vanzan01/claude-code-sub-agent-collective` - Multi-agent orchestration system
3. `bmad-code-org/BMAD-METHOD` - Agentic agile development framework
4. `anthropics/skills` - Official Anthropic Skills repository

---

## Understanding Claude Code's Extensibility System

### 1. Subagents (`.claude/agents/`)
- **Purpose**: Specialized AI assistants with focused responsibilities
- **Invocation**: Automatic (based on task) or explicit (`@agent-name`)
- **Structure**: Markdown file with YAML frontmatter + system prompt
- **Tools**: Can inherit all tools or have restricted access
- **Context**: Each has own isolated context window

### 2. Skills (`.claude/skills/`)
- **Purpose**: Auto-loaded knowledge packages triggered by context
- **Invocation**: Automatic when conversation matches description
- **Structure**: Directory with `SKILL.md` + `resources/` folder
- **Loading**: Lazy (metadata always loaded, content on-demand)
- **Best for**: "Claude should remember X automatically"

### 3. Slash Commands (`.claude/commands/`)
- **Purpose**: Frequently-used prompt shortcuts
- **Invocation**: Manual (`/command-name`)
- **Structure**: Simple `.md` files with optional frontmatter
- **Arguments**: Support `$ARGUMENTS`, `$1`, `$2`, etc.
- **Best for**: Quick, repetitive workflows

### 4. Plugins
- **Purpose**: Bundled distribution of agents + skills + commands
- **Invocation**: Install package that sets up everything
- **Best for**: Sharing complete workflows with others

---

## Repository Analysis

### 1. github/spec-kit

**Type:** CLI toolkit for Spec-Driven Development

**Strengths:**
- ✅ Methodology-focused (intent-driven development)
- ✅ Language/framework agnostic specs
- ✅ Multi-agent support (14+ AI tools)
- ✅ Iterative refinement workflow

**Limitations:**
- ❌ Not agent-based (just slash commands via CLI)
- ❌ Requires Python 3.11+ and external CLI tool
- ❌ Doesn't integrate deeply with Claude Code's agent system

**Key Features:**
- Slash commands: `/speckit.specify`, `/speckit.plan`, `/speckit.tasks`, `/speckit.implement`
- Creates `.specify/` directory for governance documents
- Focus on *what* to build before *how*

**Best For:** Teams wanting structured specification workflows before implementation.

---

### 2. vanzan01/claude-code-sub-agent-collective

**Type:** Alpha-stage autonomous development system with 30+ specialized agents

**Strengths:**
- ✅ Most sophisticated agent system
- ✅ Deterministic coordination (not emergent behavior)
- ✅ Infrastructure-level guardrails
- ✅ Quality gates and metrics tracking
- ✅ Real documentation via Context7

**Limitations:**
- ❌ Alpha stage (~15% MCP API failure rate)
- ❌ Complex setup (might be overkill for simple projects)
- ❌ Heavy TDD focus (may not suit all workflows)
- ❌ Requires TaskMaster MCP integration

**Architecture:**
```
.claude/
├── agents/
│   ├── @task-orchestrator.md         # Central router
│   ├── @component-implementation-agent.md
│   ├── @quality-agent.md
│   ├── @research-agent.md
│   └── [30+ more agents]
├── hooks/
│   ├── test-driven-handoff.sh        # TDD enforcement
│   └── collective-metrics.sh          # Performance tracking
├── settings.json
└── CLAUDE.md                          # Behavioral OS

.claude-collective/
└── [testing frameworks, metrics]
```

**Key Features:**
- **Hub-and-spoke coordination**: Central orchestrator routes to specialists
- **TDD enforcement**: Automated hooks block incomplete work
- **Context7 integration**: Real-time documentation access
- **Complexity analysis**: JavaScript utility assesses task difficulty
- **Installation modes**: `--minimal`, `--testing-only`, `--hooks-only`, `--interactive`

**Best For:** Complex projects needing autonomous multi-agent coordination with quality enforcement.

---

### 3. bmad-code-org/BMAD-METHOD

**Type:** Universal AI agent framework for "agentic agile development"

**Strengths:**
- ✅ Solves **context loss** problem between planning and development
- ✅ Multi-domain capability (not just software)
- ✅ Strong community (Discord, 66 contributors)
- ✅ Production-ready (v4.x stable)

**Limitations:**
- ❌ Less clear Claude Code integration details
- ❌ Requires Node.js v20+
- ❌ 97.9% JavaScript (might not fit Rails workflows)
- ❌ 85 open GitHub issues

**Architecture:**
```
Planning Phase:
├── Analyst Agent → Requirements
├── PM Agent → PRDs
└── Architect Agent → Design docs

Development Phase:
├── Scrum Master → Context-rich stories
├── Dev Agents → Implementation
└── QA Agents → Validation

Expansion Packs:
├── Game Development
├── Business Strategy
└── [custom domains]
```

**Key Features:**
- **Agentic planning**: Dedicated agents create PRDs/architecture
- **Context preservation**: Story files carry knowledge between handoffs
- **Multi-domain**: Not just software (creative writing, business, etc.)
- **Template-driven**: YAML/Markdown for workflows
- **Flattener tool**: Aggregates codebase into XML for AI consumption

**Best For:** Teams wanting structured agile workflows with planning-focused agents.

---

### 4. anthropics/skills (Official Repository)

**Type:** Canonical reference for Claude Code skills system

**Contents:**
1. **Example Skills** (Apache 2.0 - Open Source)
   - Creative/Design: Generative art, Slack GIFs, canvas design
   - Technical: Web app testing (Playwright), MCP server generation
   - Enterprise: Brand guidelines, internal comms
   - Meta: Skill creation templates (`template-skill`)

2. **Document Skills** (Source-Available)
   - PDF, DOCX, PPTX, XLSX manipulation

3. **Partner Integrations**: Notion Skills example

**Official Skill Structure:**
```
my-skill/
├── SKILL.md              # Required
│   ├── YAML frontmatter (name, description)
│   ├── Instructions
│   ├── Examples
│   └── Guidelines
├── resources/            # Optional
│   ├── templates/
│   ├── scripts/
│   └── examples/
└── README.md            # Optional
```

---

## Comparison Matrix

| Feature | spec-kit | sub-agent-collective | BMAD-METHOD | anthropics/skills |
|---------|----------|---------------------|-------------|-------------------|
| **Claude Code Native** | ⚠️ Partial (CLI) | ✅ Full | ⚠️ Unclear | ✅ Full |
| **Agent Count** | 0 | 30+ | ~6 roles | 0 |
| **Skills Support** | ❌ | Unknown | Unknown | ✅ Reference |
| **Slash Commands** | ✅ (via CLI) | ✅ `/van` | Unknown | N/A |
| **Quality Enforcement** | ❌ | ✅ Hooks + TDD | ⚠️ QA agents | ❌ |
| **Rails Compatibility** | ✅ Agnostic | ✅ Agnostic | ⚠️ JS-heavy | ✅ Agnostic |
| **Complexity** | Low | Very High | Medium-High | Low |
| **Maturity** | Experimental | Alpha | v4.x Stable | Official |
| **Installation** | Python CLI | NPX | NPM | Plugin/Manual |
| **Best Feature** | Intent-first specs | Agent orchestration | Context preservation | Official patterns |

---

## Implementation Plan for Doable Rails App

### Phase 1: Foundation Setup (Official Anthropic Skills)

**Objective:** Install official skills for immediate value

**Actions:**
1. Install official Anthropic skills from plugin marketplace:
   ```bash
   /plugin install document-skills@anthropic-agent-skills
   /plugin install web-app-testing@anthropic-agent-skills
   ```
2. Download `template-skill` as reference for custom skills
3. Review official patterns from anthropics/skills repository

**Value:**
- Web app testing integration (Playwright/Capybara)
- Document generation capabilities (PDF/Excel export features)
- Official patterns to follow

**Time Estimate:** 30 minutes

---

### Phase 2: Rails-Specific Skills (Auto-Loaded Knowledge)

**Objective:** Create domain knowledge that auto-loads when working on Rails code

**Directory Structure:**
```
.claude/skills/
├── rails-8-conventions/
│   ├── SKILL.md
│   └── resources/
│       ├── controller-template.rb
│       ├── model-template.rb
│       └── migration-examples/
├── hotwire-patterns/
│   ├── SKILL.md
│   └── resources/
│       ├── turbo-frame-examples.html.erb
│       ├── turbo-stream-examples.html.erb
│       └── stimulus-controller-template.js
└── testing-patterns/
    ├── SKILL.md
    └── resources/
        ├── model-test-template.rb
        └── system-test-template.rb
```

**Skill 1: rails-8-conventions**
```markdown
---
name: rails-8-conventions
description: Load when working with Rails 8 projects, especially those using
             Solid stack (solid_cache, solid_queue, solid_cable), Hotwire,
             and params.expect patterns. DO NOT load for non-Rails projects
             or Rails versions < 8.
---

## Instructions

When working with Rails 8 applications:

1. **Parameter Handling**: Always use `params.expect` instead of `params.require`
   ```ruby
   # Correct (Rails 8)
   params.expect(project: [:name, :active])

   # Incorrect (Rails < 8)
   params.require(:project).permit(:name, :active)
   ```

2. **Solid Stack**: Leverage database-backed adapters
   - solid_cache for caching
   - solid_queue for background jobs
   - solid_cable for Action Cable

3. **Hotwire Integration**: Prefer Turbo for dynamic updates
   - Use Turbo Frames for inline updates
   - Use Turbo Streams for broadcasts
   - Keep Stimulus controllers focused and minimal

4. **Style Guidelines**: Follow Rails Omakase style
   - Run `bin/rubocop` before committing
   - Use standard Rails directory structure

5. **Testing**: Maintain test coverage
   - Model tests for validations/associations
   - System tests for user workflows

## Examples

### Controller with params.expect
```ruby
class ProjectsController < ApplicationController
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.expect(project: [:name, :active])
  end
end
```

### Model with validations
```ruby
class Project < ApplicationRecord
  has_many :todos, dependent: :destroy

  validates :name, presence: { message: "Was forgotten?" }
end
```

## Guidelines

- Always check CLAUDE.md for project-specific conventions
- Prioritize simplicity over complexity
- Use Rails generators when appropriate
- Keep controllers thin, models fat
```

**Skill 2: hotwire-patterns**
```markdown
---
name: hotwire-patterns
description: Load when implementing Turbo Frames, Turbo Streams, or Stimulus
             controllers. DO NOT load for API-only Rails applications or
             projects not using Hotwire.
---

## Instructions

When building Hotwire features:

1. **Turbo Frames**: For inline updates without full page reload
   - Wrap sections that update independently
   - Use matching `id` attributes
   - Lazy load with `src` attribute

2. **Turbo Streams**: For multiple simultaneous updates
   - Use for real-time features
   - Broadcast from models with `broadcasts_to`
   - Support multiple actions (replace, append, prepend, remove)

3. **Stimulus Controllers**: For JavaScript sprinkles
   - Keep controllers focused on single responsibility
   - Use data attributes for configuration
   - Prefer CSS over JavaScript for styling

## Examples

### Turbo Frame for inline editing
```erb
<!-- app/views/todos/show.html.erb -->
<%= turbo_frame_tag @todo do %>
  <div class="todo">
    <h2><%= @todo.name %></h2>
    <p><%= @todo.description %></p>
    <%= link_to "Edit", edit_todo_path(@todo) %>
  </div>
<% end %>

<!-- app/views/todos/edit.html.erb -->
<%= turbo_frame_tag @todo do %>
  <%= form_with model: @todo do |f| %>
    <%= f.text_field :name %>
    <%= f.text_area :description %>
    <%= f.submit %>
  <% end %>
<% end %>
```

### Stimulus Controller
```javascript
// app/javascript/controllers/todo_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "name"]

  toggle() {
    this.nameTarget.classList.toggle("line-through")
  }
}
```

## Guidelines

- Test Turbo interactions with system tests
- Keep Stimulus controllers under 100 lines
- Use Turbo Frames before reaching for JavaScript
- Progressive enhancement: work without JS first
```

**Skill 3: testing-patterns**
```markdown
---
name: testing-patterns
description: Load when writing or updating tests for Rails applications.
             DO NOT load when only implementing features without tests.
---

## Instructions

When writing tests for Rails 8 applications:

1. **Model Tests**: Focus on validations, associations, and business logic
2. **System Tests**: Test user workflows with Capybara
3. **Controller Tests**: Test authorization and params handling (optional in Rails)
4. **Test Coverage**: Aim for meaningful coverage, not 100%

## Examples

### Model Test
```ruby
# test/models/project_test.rb
require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "should not save project without name" do
    project = Project.new
    assert_not project.save, "Saved project without a name"
    assert_equal "Was forgotten?", project.errors[:name].first
  end

  test "destroying project destroys associated todos" do
    project = projects(:one)
    assert_difference('Todo.count', -project.todos.count) do
      project.destroy
    end
  end
end
```

### System Test
```ruby
# test/system/todos_test.rb
require "application_system_test_case"

class TodosTest < ApplicationSystemTestCase
  test "creating a Todo" do
    visit project_path(projects(:one))

    click_on "New todo"

    fill_in "Name", with: "Buy groceries"
    fill_in "Description", with: "Milk, eggs, bread"
    click_on "Create Todo"

    assert_text "Todo was successfully created"
    assert_text "Buy groceries"
  end
end
```

## Guidelines

- Run tests before committing: `bin/rails test`
- Use fixtures for test data
- Test happy path and edge cases
- System tests for critical user workflows
```

**Actions:**
1. Create `.claude/skills/` directory
2. Create three skill directories with SKILL.md files
3. Add resources (templates, examples) to each skill
4. Test skills load correctly when working on Rails code

**Time Estimate:** 2-3 hours

---

### Phase 3: Specialized Agents (Task Delegation)

**Objective:** Build agents that handle complete workflows autonomously

**Directory Structure:**
```
.claude/agents/
├── rails-feature-builder.md
├── test-coverage-agent.md
├── migration-safety-agent.md
├── hotwire-specialist.md
└── rails-orchestrator.md (optional)
```

**Agent 1: rails-feature-builder**
```markdown
---
name: rails-feature-builder
description: Build complete Rails features including model, controller, views,
             routes, and tests. PROACTIVELY use for requests like "add user
             authentication" or "create comment system" or "add tags to todos".
tools: Read, Write, Edit, Glob, Grep, Bash, TodoWrite
model: sonnet
---

You are a Rails 8 expert specializing in building complete features from scratch.

## Your Mission

Build production-ready Rails features that follow best practices, include comprehensive tests, and integrate seamlessly with existing code.

## Workflow

When assigned a feature request, follow this systematic approach:

1. **Analysis**
   - Read existing models, controllers, and routes
   - Identify integration points
   - Plan database schema changes

2. **Database Layer**
   - Generate migration with proper naming
   - Define indexes and foreign keys
   - Ensure reversibility

3. **Model Layer**
   - Create/update model with validations
   - Add associations
   - Include business logic methods

4. **Controller Layer**
   - Generate controller with RESTful actions
   - Use `params.expect` for strong parameters
   - Handle errors gracefully

5. **View Layer**
   - Build views with Hotwire (Turbo Frames)
   - Use TailwindCSS for styling
   - Ensure responsive design

6. **Routes**
   - Add resourceful routes
   - Include nested routes if needed

7. **Tests**
   - Model tests for validations
   - System tests for user workflows
   - Run full test suite

8. **Verification**
   - Run migrations
   - Run tests
   - Check routes with `bin/rails routes`

## Guidelines

- Consult the `rails-8-conventions` skill for modern patterns
- Use the `hotwire-patterns` skill for interactive features
- Follow the `testing-patterns` skill for test structure
- Always run tests before marking work complete
- Use TodoWrite to track progress on complex features

## Example Scenarios

**User Request:** "Add tags to todos"

**Your Approach:**
1. Create Tag model with migration
2. Create join table todos_tags
3. Update Todo model with has_and_belongs_to_many :tags
4. Add tags controller for CRUD
5. Update todo form to include tag selection (with Stimulus for multi-select)
6. Add tag filtering to todos index
7. Write comprehensive tests
8. Run migrations and verify

**User Request:** "Add user authentication"

**Your Approach:**
1. Analyze: Check if Devise or custom auth is preferred
2. Install authentication gem (or build custom)
3. Generate User model with secure password
4. Add authentication controller (sessions)
5. Protect controllers with before_action
6. Add login/logout views
7. Test authentication flows
8. Update existing features to scope to current_user

## Constraints

- Never skip tests
- Always ensure migrations are reversible
- Follow Rails conventions strictly
- Keep controllers thin (< 7 actions per controller)
- Use services for complex business logic
```

**Agent 2: test-coverage-agent**
```markdown
---
name: test-coverage-agent
description: Analyze test coverage and generate missing tests. PROACTIVELY use
             when code changes lack tests or when user mentions testing.
tools: Read, Glob, Grep, Bash, Write, TodoWrite
model: haiku
---

You are a Rails testing specialist focused on comprehensive test coverage.

## Your Mission

Ensure all code has appropriate test coverage with meaningful tests that catch regressions.

## Workflow

1. **Coverage Analysis**
   - Identify untested models, controllers, features
   - Check for missing edge cases
   - Look for untested validations/associations

2. **Test Generation**
   - Write model tests for all validations
   - Write model tests for associations
   - Write system tests for critical workflows
   - Write integration tests for APIs (if applicable)

3. **Test Execution**
   - Run generated tests
   - Fix any failures
   - Verify tests actually test what they claim to

4. **Documentation**
   - Comment complex test scenarios
   - Use descriptive test names

## Guidelines

- Follow the `testing-patterns` skill
- Use fixtures effectively
- Test both happy path and edge cases
- Don't test framework functionality (Rails itself)
- Focus on business logic and custom code

## Test Priorities

**High Priority:**
- Model validations
- Custom model methods
- User-facing workflows (system tests)

**Medium Priority:**
- Controller authorization
- Complex queries
- Background jobs

**Low Priority:**
- Standard CRUD operations (if using scaffold)
- Simple getters/setters

## Example

**Scenario:** User added `Todo.mark_as_completed!` method without tests

**Your Actions:**
1. Analyze the method implementation
2. Write tests covering:
   - Successful completion
   - Idempotency (calling twice)
   - Side effects (callbacks, validations)
3. Run tests and verify they pass
4. Check if related system tests need updates
```

**Agent 3: migration-safety-agent**
```markdown
---
name: migration-safety-agent
description: Review database migrations for safety issues and generate safe
             migration code. Use PROACTIVELY for all database schema changes.
tools: Read, Write, Grep, Bash
model: sonnet
---

You are a database migration expert focused on zero-downtime deployments.

## Your Mission

Ensure all database migrations are safe, reversible, and won't cause production issues.

## Safety Checklist

When reviewing or creating migrations:

1. **Reversibility**
   - Every migration must be reversible
   - Use `reversible` block or define `down` method
   - Test rollback locally

2. **Zero-Downtime Considerations**
   - Avoid `change_column` (use `change_column_null` instead)
   - Add columns with defaults in separate migrations
   - Add indexes concurrently in PostgreSQL
   - Never drop columns without deprecation

3. **Data Integrity**
   - Add foreign keys with proper constraints
   - Include indexes for foreign keys
   - Validate constraints in application first, then database

4. **Performance**
   - Avoid `remove_column` in production (deploy code first)
   - Use `add_index algorithm: :concurrently` for large tables
   - Split data migrations from schema migrations

## Workflow

1. **Review Migration**
   - Check for unsafe operations
   - Verify reversibility
   - Assess performance impact

2. **Suggest Improvements**
   - Propose safer alternatives
   - Recommend multi-step approach if needed
   - Add comments explaining complex logic

3. **Verification**
   - Run migration and rollback locally
   - Check schema.rb for expected changes
   - Verify database constraints

## Example Review

**Unsafe Migration:**
```ruby
class AddStatusToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :status, :string, null: false, default: 'pending'
  end
end
```

**Your Feedback:**
"This migration adds a NOT NULL column with a default in a single step. For large tables, this locks the table.

**Safer Approach:**

Step 1 - Add nullable column:
```ruby
class AddStatusToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :status, :string
  end
end
```

Step 2 - Backfill data:
```ruby
class BackfillTodoStatus < ActiveRecord::Migration[8.0]
  def up
    Todo.in_batches.update_all(status: 'pending')
  end

  def down
    # No-op, column will be removed in next migration
  end
end
```

Step 3 - Add constraint:
```ruby
class AddNotNullToTodoStatus < ActiveRecord::Migration[8.0]
  def change
    change_column_null :todos, :status, false, 'pending'
  end
end
```
```

**Agent 4: hotwire-specialist**
```markdown
---
name: hotwire-specialist
description: Implement Turbo Frames, Turbo Streams, and Stimulus controllers
             for interactive features. Use PROACTIVELY when user requests
             dynamic behavior or mentions "without page reload".
tools: Read, Write, Edit, Glob, Grep
model: sonnet
---

You are a Hotwire expert specializing in Turbo and Stimulus implementations.

## Your Mission

Build interactive, SPA-like experiences using Hotwire with minimal JavaScript.

## Workflow

1. **Analyze Requirements**
   - Determine if Turbo Frame or Turbo Stream is appropriate
   - Identify need for Stimulus controllers

2. **Implementation Strategy**
   - Prefer Turbo Frames for inline updates
   - Use Turbo Streams for broadcasts/multiple updates
   - Add Stimulus only when Turbo isn't enough

3. **Build Feature**
   - Wrap sections in turbo_frame_tag
   - Ensure matching IDs across views
   - Add Stimulus for client-side interactions

4. **Testing**
   - Write system tests for Turbo interactions
   - Verify graceful degradation without JavaScript

## Turbo Frame Patterns

**Pattern 1: Inline Editing**
```erb
<%= turbo_frame_tag dom_id(@todo) do %>
  <!-- show.html.erb -->
  <%= render @todo %>
  <%= link_to "Edit", edit_todo_path(@todo) %>
<% end %>
```

**Pattern 2: Lazy Loading**
```erb
<%= turbo_frame_tag "todo_details", src: todo_path(@todo) do %>
  Loading...
<% end %>
```

## Turbo Stream Patterns

**Pattern 1: Real-time Updates**
```ruby
# app/models/todo.rb
class Todo < ApplicationRecord
  broadcasts_to :project
end
```

**Pattern 2: Form Responses**
```ruby
# app/controllers/todos_controller.rb
def create
  @todo = @project.todos.build(todo_params)

  if @todo.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @project }
    end
  end
end
```

## Stimulus Controller Patterns

**Pattern: Toggle Visibility**
```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTarget.classList.toggle("hidden")
  }
}
```

## Guidelines

- Consult `hotwire-patterns` skill for examples
- Test with and without JavaScript enabled
- Keep Stimulus controllers under 100 lines
- Use CSS for animations, not JavaScript
- Progressive enhancement: HTML first, JS as enhancement
```

**Agent 5: rails-orchestrator (Optional)**
```markdown
---
name: rails-orchestrator
description: Coordinate multiple agents for complex, multi-step Rails features.
             Use for large features like "build admin dashboard" or "add
             complete e-commerce system".
tools: Task
model: sonnet
---

You are an orchestration expert that delegates work to specialized Rails agents.

## Your Mission

Break down complex features into subtasks and delegate to appropriate agents.

## Available Agents

- `@rails-feature-builder` - Complete CRUD features
- `@test-coverage-agent` - Testing and coverage
- `@migration-safety-agent` - Database migrations
- `@hotwire-specialist` - Interactive features

## Workflow

1. **Analysis**
   - Break down user request into subtasks
   - Identify dependencies between tasks
   - Create task list with TodoWrite

2. **Delegation**
   - Assign each subtask to appropriate agent
   - Use Task tool to invoke agents
   - Monitor progress

3. **Integration**
   - Ensure agents' work integrates properly
   - Run full test suite
   - Verify feature completeness

4. **Verification**
   - Check all requirements met
   - Run final tests
   - Mark todos as complete

## Example

**User Request:** "Build admin dashboard with user management and analytics"

**Your Breakdown:**
1. Database schema (migration-safety-agent)
   - Create Admin model
   - Add role to users
   - Create analytics tables

2. Admin authentication (rails-feature-builder)
   - Admin login system
   - Role-based authorization

3. User management CRUD (rails-feature-builder)
   - List users
   - Edit user roles
   - Deactivate accounts

4. Analytics views (hotwire-specialist)
   - Real-time user count
   - Activity charts
   - Dashboard widgets

5. Testing (test-coverage-agent)
   - System tests for admin workflows
   - Authorization tests

6. Integration
   - Verify all pieces work together
   - Run full test suite
```

**Actions:**
1. Create `.claude/agents/` directory
2. Create 4-5 agent files with detailed prompts
3. Test agents with real feature requests
4. Refine descriptions and prompts based on performance

**Time Estimate:** 3-4 hours

---

### Phase 4: Slash Commands (Frequent Operations)

**Objective:** Create shortcuts for repetitive Rails tasks

**Directory Structure:**
```
.claude/commands/
├── rails/
│   ├── test.md
│   ├── migrate.md
│   ├── scaffold-model.md
│   ├── turbo-component.md
│   └── routes.md
└── db/
    ├── rollback.md
    ├── reset.md
    └── seed.md
```

**Command 1: /rails-test**
```markdown
---
description: Run Rails tests with optional path
argument-hint: [test-path]
---

Run the Rails test suite for the specified path or all tests.

!bin/rails test $ARGUMENTS
```

**Command 2: /rails-migrate**
```markdown
---
description: Run pending migrations safely
---

Check migration status, run migrations, and prepare test database:

!echo "=== Current Migration Status ===" && bin/rails db:migrate:status
!echo "\n=== Running Migrations ===" && bin/rails db:migrate
!echo "\n=== Preparing Test DB ===" && bin/rails db:test:prepare
!echo "\n=== Updated Migration Status ===" && bin/rails db:migrate:status
```

**Command 3: /scaffold-model**
```markdown
---
description: Generate Rails model with migration and tests
argument-hint: <ModelName> [field:type ...]
allowed-tools: Bash(bin/rails generate:*)
---

Generate a new Rails model with best practices:

Invoke @rails-feature-builder to:
1. Generate model: $ARGUMENTS
2. Add validations and associations
3. Create comprehensive tests
4. Run migration
5. Verify in console

Please ensure:
- Model name is singular and CamelCase
- Field types are valid Rails types
- Validations follow business requirements
```

**Command 4: /turbo-component**
```markdown
---
description: Create Turbo Frame/Stream component with Stimulus
argument-hint: <component-name>
---

Invoke @hotwire-specialist to build a Hotwire component:

Component name: $1

Include:
1. Turbo Frame wrapper view partial
2. Controller action for frame content
3. Stimulus controller (if interactive behavior needed)
4. System test for component
5. Usage documentation

Follow patterns from `hotwire-patterns` skill.
```

**Command 5: /rails-routes**
```markdown
---
description: Display and analyze Rails routes
argument-hint: [grep-pattern]
---

Show Rails routes with optional filtering:

!if [ -z "$1" ]; then
!  bin/rails routes
!else
!  bin/rails routes | grep "$1"
!fi
```

**Command 6: /db-rollback**
```markdown
---
description: Safely rollback the last migration
---

Rollback the last migration after confirmation:

Please confirm you want to rollback the last migration.

!bin/rails db:migrate:status
!echo "\n=== Rolling back last migration ==="
!bin/rails db:rollback
!echo "\n=== Updated status ==="
!bin/rails db:migrate:status
```

**Actions:**
1. Create `.claude/commands/` directory structure
2. Create 6-8 common command files
3. Test commands in Claude Code
4. Add more commands as patterns emerge

**Time Estimate:** 1-2 hours

---

### Phase 5: Quality Enforcement (Optional)

**Objective:** Add automated checks inspired by sub-agent-collective

**Directory Structure:**
```
.claude/hooks/
├── test-verification.sh
├── migration-check.sh
└── rubocop-check.sh
```

**Hook 1: test-verification.sh**
```bash
#!/bin/bash

# Verify tests pass before major operations
# Inspired by sub-agent-collective's TDD enforcement

set -e

echo "🧪 Running test suite..."

if bin/rails test; then
  echo "✅ All tests passed!"
  exit 0
else
  echo "❌ Tests failed. Please fix before proceeding."
  exit 1
fi
```

**Hook 2: migration-check.sh**
```bash
#!/bin/bash

# Check migration reversibility
set -e

echo "🔄 Checking migration reversibility..."

# Run migration
bin/rails db:migrate

# Check status
bin/rails db:migrate:status

# Test rollback
echo "Testing rollback..."
bin/rails db:rollback

# Re-migrate
echo "Re-migrating..."
bin/rails db:migrate

echo "✅ Migration is reversible!"
```

**CLAUDE.md Enhancements**
```markdown
# CLAUDE.md

## Behavioral Directives for Doable Rails App

### Non-Negotiable Rules

1. **Testing First**
   - Never commit code without tests
   - Run `bin/rails test` before marking features complete
   - System tests required for user-facing features

2. **Rails 8 Conventions**
   - Always use `params.expect` (never `params.require`)
   - Follow Rails Omakase style (run `bin/rubocop`)
   - Leverage Solid stack adapters

3. **Migration Safety**
   - All migrations must be reversible
   - Consult @migration-safety-agent for complex changes
   - Test rollback locally before committing

4. **Hotwire First**
   - Prefer Turbo Frames over full page reloads
   - Use Turbo Streams for real-time updates
   - Add Stimulus only when necessary

5. **Code Quality**
   - Keep controllers under 7 actions
   - Extract complex logic to services/models
   - Follow single responsibility principle

### Agent Invocation Guidelines

- Use @rails-feature-builder for complete features
- Use @test-coverage-agent when tests are missing
- Use @migration-safety-agent for database changes
- Use @hotwire-specialist for interactive features
- Use @rails-orchestrator for multi-step features

### Skills Auto-Loading

The following skills will auto-load:
- `rails-8-conventions` - When editing Rails files
- `hotwire-patterns` - When working with Turbo/Stimulus
- `testing-patterns` - When writing/updating tests
```

**Actions:**
1. Create `.claude/hooks/` directory
2. Create 2-3 verification scripts
3. Make scripts executable (`chmod +x`)
4. Update CLAUDE.md with behavioral directives
5. Test hooks trigger appropriately

**Time Estimate:** 2-3 hours

---

### Phase 6: Documentation & Testing

**Objective:** Document the system and validate it works

**Actions:**

1. **Update README**
   - Document agent system
   - List available commands
   - Explain skill auto-loading
   - Provide examples

2. **Create Usage Guide**
   - Write `.claude/USAGE.md` with examples
   - Document common workflows
   - Include troubleshooting section

3. **Test All Components**
   - Test each agent with real tasks
   - Verify skills load correctly
   - Test all slash commands
   - Validate hooks (if implemented)

4. **Refine Based on Usage**
   - Improve agent descriptions
   - Fix skill loading issues
   - Add missing commands
   - Update prompts for better results

**Example README Addition:**
```markdown
## Claude Code Integration

This project includes custom Claude Code agents, skills, and commands for Rails 8 development.

### Available Agents

- `@rails-feature-builder` - Build complete CRUD features
- `@test-coverage-agent` - Generate missing tests
- `@migration-safety-agent` - Safe database migrations
- `@hotwire-specialist` - Interactive Turbo/Stimulus features
- `@rails-orchestrator` - Coordinate complex features

### Available Skills

Skills auto-load when working on relevant code:

- `rails-8-conventions` - Rails 8 patterns (params.expect, Solid stack)
- `hotwire-patterns` - Turbo Frames/Streams, Stimulus
- `testing-patterns` - Minitest patterns for Rails

### Slash Commands

Quick shortcuts for common tasks:

- `/rails-test [path]` - Run test suite
- `/rails-migrate` - Run pending migrations
- `/scaffold-model <Name> [fields]` - Generate model with best practices
- `/turbo-component <name>` - Create Hotwire component
- `/db-rollback` - Safely rollback last migration

### Example Workflows

**Adding a new feature:**
```
User: "Add tags to todos"
Claude: [Invokes @rails-feature-builder automatically]
Agent: [Creates migration, model, controller, views, tests]
```

**Generating missing tests:**
```
User: "/test-coverage"
Claude: [Invokes @test-coverage-agent]
Agent: [Analyzes code, writes tests, runs suite]
```

**Safe migration:**
```
User: "Add status column to todos"
Claude: [Invokes @migration-safety-agent]
Agent: [Reviews for safety, suggests improvements, implements]
```
```

**Time Estimate:** 2-3 hours

---

## Implementation Timeline

| Phase | Tasks | Time | Dependencies |
|-------|-------|------|--------------|
| **Phase 1** | Install official skills | 30 min | None |
| **Phase 2** | Create 3 Rails skills | 2-3 hours | Phase 1 |
| **Phase 3** | Build 4-5 agents | 3-4 hours | Phase 2 |
| **Phase 4** | Create 6-8 commands | 1-2 hours | None (parallel) |
| **Phase 5** | Quality hooks (optional) | 2-3 hours | Phase 3 |
| **Phase 6** | Documentation & testing | 2-3 hours | All phases |
| **Total** | Complete implementation | **11-16 hours** | - |

**Recommended Schedule:**
- **Week 1**: Phases 1-2 (skills foundation)
- **Week 2**: Phases 3-4 (agents and commands)
- **Week 3**: Phases 5-6 (quality and docs)

---

## Success Metrics

### Immediate Wins (Week 1)
- ✅ Skills auto-load when editing Rails files
- ✅ Official Anthropic skills installed and functional
- ✅ Basic slash commands save repetitive typing

### Medium-term Success (Week 2-3)
- ✅ Agents handle feature requests end-to-end
- ✅ Test coverage maintained automatically
- ✅ Migration safety checks prevent production issues

### Long-term Success (Month 1+)
- ✅ Development velocity increased by 30-50%
- ✅ Fewer bugs due to automated testing
- ✅ Team adoption and contribution to agent library
- ✅ Potential plugin distribution to Rails community

---

## Selective Integration from Analyzed Repos

### From vanzan01/claude-code-sub-agent-collective

**Adopt:**
- ✅ Hub-and-spoke orchestrator pattern
- ✅ Quality gate hooks (test verification)
- ✅ Metrics tracking (optional)
- ✅ Context7 MCP for real-time Rails docs

**Skip:**
- ❌ Full 30+ agent system (overkill)
- ❌ Strict TDD enforcement (too rigid)
- ❌ TaskMaster MCP dependency

### From bmad-code-org/BMAD-METHOD

**Adopt:**
- ✅ Planning phase agents (@rails-architect, @feature-analyst)
- ✅ Context preservation in story files
- ✅ Agent role separation (Analyst, PM, Dev, QA)

**Skip:**
- ❌ Full BMAD installation (Node.js heavy)
- ❌ JavaScript-centric tooling
- ❌ Multi-domain expansion packs

### From github/spec-kit

**Adopt:**
- ✅ Specification workflow pattern
- ✅ Constitution/principles approach (CLAUDE.md)
- ✅ Intent-driven development mindset

**Skip:**
- ❌ Python CLI dependency
- ❌ External toolchain

### From anthropics/skills

**Adopt:**
- ✅ Official skill structure and patterns
- ✅ Web app testing integration (Playwright)
- ✅ Document manipulation skills (for future export features)
- ✅ Template-skill as reference

---

## Future Enhancements

### Phase 7: Advanced Features (Post-Launch)

1. **Context7 MCP Integration**
   - Real-time Rails 8 documentation
   - Up-to-date gem documentation
   - Hotwire/Stimulus docs

2. **Performance Monitoring Agents**
   - `@performance-optimizer` - Identify N+1 queries
   - `@security-auditor` - Security vulnerability scanning
   - `@dependency-updater` - Keep gems current

3. **Domain-Specific Agents**
   - `@todo-optimizer` - Optimize todo/project features
   - `@analytics-agent` - Generate usage analytics
   - `@export-agent` - CSV/PDF/Excel export features

4. **Plugin Distribution**
   - Package as `rails-8-development@doable`
   - Share with Rails community
   - Maintain on plugin marketplace

5. **Team Collaboration**
   - Share agents via git
   - Standardize team workflows
   - Collect metrics on agent usage

---

## Risk Mitigation

### Potential Issues

1. **Skill Over-Loading**
   - **Risk**: Too many skills load unnecessary context
   - **Mitigation**: Write precise descriptions with "DO NOT load" conditions
   - **Monitoring**: Check context window usage

2. **Agent Conflicts**
   - **Risk**: Multiple agents try to handle same task
   - **Mitigation**: Clear, non-overlapping agent descriptions
   - **Solution**: Use orchestrator for ambiguous tasks

3. **Hook Failures**
   - **Risk**: Hooks block legitimate work
   - **Mitigation**: Make hooks advisory (warnings not errors)
   - **Override**: Allow manual bypass when needed

4. **Maintenance Burden**
   - **Risk**: Agents/skills become outdated
   - **Mitigation**: Regular review and updates
   - **Automation**: Track agent usage, deprecate unused

5. **Learning Curve**
   - **Risk**: Team doesn't adopt new system
   - **Mitigation**: Good documentation and examples
   - **Training**: Hands-on workshop for team

---

## Appendix A: File Structure Summary

```
doable/
├── .claude/
│   ├── agents/
│   │   ├── rails-feature-builder.md
│   │   ├── test-coverage-agent.md
│   │   ├── migration-safety-agent.md
│   │   ├── hotwire-specialist.md
│   │   └── rails-orchestrator.md (optional)
│   ├── skills/
│   │   ├── rails-8-conventions/
│   │   │   ├── SKILL.md
│   │   │   └── resources/
│   │   ├── hotwire-patterns/
│   │   │   ├── SKILL.md
│   │   │   └── resources/
│   │   └── testing-patterns/
│   │       ├── SKILL.md
│   │       └── resources/
│   ├── commands/
│   │   ├── rails/
│   │   │   ├── test.md
│   │   │   ├── migrate.md
│   │   │   ├── scaffold-model.md
│   │   │   ├── turbo-component.md
│   │   │   └── routes.md
│   │   └── db/
│   │       ├── rollback.md
│   │       ├── reset.md
│   │       └── seed.md
│   ├── hooks/ (optional)
│   │   ├── test-verification.sh
│   │   ├── migration-check.sh
│   │   └── rubocop-check.sh
│   └── USAGE.md
├── CLAUDE.md (updated with directives)
├── README.md (updated with agent docs)
└── [existing Rails app files]
```

---

## Appendix B: Key Takeaways

### What Makes This Plan Work

1. **Official Patterns First**: Follow anthropics/skills canonical structure
2. **Incremental Adoption**: Start simple, add complexity as needed
3. **Rails-Specific**: Tailored to Rails 8, Hotwire, and Doable's needs
4. **Selective Integration**: Cherry-pick best ideas from all three repos
5. **Real Value**: Each component solves actual development pain points

### What to Avoid

1. ❌ Don't over-engineer: 30+ agents is overkill for a todo app
2. ❌ Don't copy blindly: Adapt patterns to your workflow
3. ❌ Don't skip testing: Verify each component works
4. ❌ Don't ignore maintenance: Keep agents/skills updated
5. ❌ Don't force adoption: Let team discover value organically

### Success Factors

1. ✅ Start with Phase 1-2 (skills) for quick wins
2. ✅ Test each component thoroughly before moving on
3. ✅ Document everything for team adoption
4. ✅ Iterate based on real usage
5. ✅ Share learnings with Rails community

---

## Questions for Consideration

Before proceeding, consider:

1. **Complexity Level**: Do you want minimal (Phases 1-4) or full system (Phases 1-6)?
2. **Testing Focus**: Strict TDD enforcement or flexible approach?
3. **Team Size**: Just you or multiple developers (affects sharing strategy)?
4. **Timeline**: Implement gradually or intensive sprint?
5. **MCP Servers**: Want Context7 integration for real-time docs?

---

## Next Steps

1. **Review this plan** and decide on scope (minimal vs. full)
2. **Start with Phase 1** (install official skills)
3. **Build first skill** (rails-8-conventions) to understand pattern
4. **Create first agent** (rails-feature-builder) to test delegation
5. **Iterate and refine** based on real usage

**Estimated Total Time:** 11-16 hours for complete implementation
**Recommended Approach:** Incremental adoption over 2-3 weeks

---

**Plan Version:** 1.0
**Date:** 2025-10-28
**Created For:** Doable Rails 8 Todo App
