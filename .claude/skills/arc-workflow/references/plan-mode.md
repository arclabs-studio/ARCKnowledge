# 📋 Plan Mode

**Plan Mode is a structured approach to complex tasks where Claude pauses to clarify requirements, evaluate options, and create a detailed implementation plan before coding.**

---

## 🎯 Purpose

Plan Mode ensures:
1. **Clarity** - All requirements are understood before implementation
2. **Quality** - Architectural decisions are evaluated upfront
3. **Efficiency** - Avoid rework from misunderstood requirements
4. **Collaboration** - User is involved in key decisions

---

## 🚦 When to Enter Plan Mode

### Automatic Triggers (Always Enter Plan Mode)

1. **Complex Features** (touches multiple layers/files)
   - "Add user authentication system"
   - "Implement restaurant search with filters"
   - "Create offline sync functionality"

2. **Ambiguous Requirements** (lacks specific details)
   - "Make the app faster"
   - "Add social features"
   - "Improve the UI"

3. **Multiple Valid Approaches** (architectural decisions)
   - "Should we use SwiftData or Core Data?"
   - "How should we handle caching?"
   - "What navigation pattern should we use?"

4. **Significant Trade-offs** (performance vs. simplicity, etc.)
   - "Optimize image loading"
   - "Add real-time updates"
   - "Support offline mode"

5. **User Explicitly Requests Planning**
   - "Let's plan this out first"
   - "What's the best approach?"
   - "Can you create a plan?"

### Decision Tree

```
Is this task...
├─ Complex (>3 files, multiple layers)? → Plan Mode
├─ Ambiguous (missing details)? → Plan Mode
├─ Architectural decision? → Plan Mode
├─ Has trade-offs to discuss? → Plan Mode
├─ User requested planning? → Plan Mode
│
└─ Simple (1-2 files, clear scope)?
    ├─ Requires new pattern? → Plan Mode
    ├─ Affects existing architecture? → Plan Mode
    └─ Straightforward implementation? → Direct Implementation
```

---

## 📋 Plan Mode Process

### Phase 1: Deep Reflection (30 seconds)

**Silently analyze**:
- Task complexity and scope
- Required layers (Presentation, Domain, Data)
- Dependencies and integrations
- Potential edge cases
- Testing requirements
- Possible approaches

### Phase 2: Ask Clarifying Questions (4-6 questions)

**Question Framework**:

#### 1. Architecture Questions
- "Which layer should this feature live in?"
- "Should this be a new Use Case or extend existing one?"
- "Do we need a new Repository or can we use existing?"
- "How does this integrate with ARCNavigation?"

#### 2. Scope Questions
- "What's in scope for this iteration?"
- "What can be deferred to later?"
- "Are there any constraints (time, resources, dependencies)?"
- "What's the minimum viable implementation?"

#### 3. Data Questions
- "Where should data be stored (local, remote, cache)?"
- "What's the data model?"
- "How should we handle data migration?"
- "What happens if data is unavailable?"

#### 4. UI/UX Questions
- "What should happen while loading?"
- "How should errors be displayed?"
- "What's the empty state?"
- "Are there any animations or transitions?"

#### 5. Testing Questions
- "What are the critical test scenarios?"
- "What edge cases should we cover?"
- "Do we need integration tests?"
- "What should be mocked?"

#### 6. Trade-off Questions
- "Should we prioritize performance or simplicity?"
- "Should we optimize for read or write operations?"
- "Should we favor flexibility or concrete implementation?"
- "What's more important: speed or maintainability?"

### Phase 3: Draft Implementation Plan

**Plan Structure**:

```markdown
## High-Level Approach
[2-3 sentence overview of the solution]

## Detailed Steps

### Step 1: [Phase Name]
**Files to Create/Modify**:
- `path/to/File1.swift`
- `path/to/File2.swift`

**What to do**:
- Specific action 1
- Specific action 2

**Why**:
Brief rationale

### Step 2: [Phase Name]
[Continue pattern...]

## Testing Strategy
- Test scenario 1
- Test scenario 2
- Test scenario 3

## Validation Checklist
- [ ] Feature works as expected
- [ ] Tests pass
- [ ] Code follows ARC Labs standards
- [ ] Documentation updated
```

### Phase 4: Get Approval

Present plan with:
- **Summary** - What will be implemented
- **Approach** - How it will be done
- **Alternatives** - Other options considered (if any)
- **Trade-offs** - What's being optimized for

**Ask**: "Does this approach work for you?" or "Would you like me to adjust anything?"

**Wait for explicit approval** before implementing.

### Phase 5: Implementation with Progress Updates

After each phase:
1. **Announce completion** - "✅ Completed Step 1: Created User entity"
2. **Summarize remaining** - "Remaining: Use Case, Repository, ViewModel, Tests"
3. **Indicate next action** - "Next: Implementing GetUserUseCase"

---

## 📝 Example Plan Mode Flows

### Example 1: Complex Feature

**User Request**: "Add restaurant search with filters"

**Plan Mode Response**:

---

I need to understand the requirements better before implementing. Let me ask a few questions:

**Architecture**:
1. Should search be a separate feature or integrated into the existing restaurant list?
2. Do we need a dedicated SearchRepository or can we extend RestaurantRepository?

**Data & Filters**:
3. What filters should we support (cuisine type, price range, distance, rating)?
4. Should filters be applied client-side or server-side?
5. Should search results be cached?

**UX**:
6. Should search be real-time (as-you-type) or trigger-based (search button)?
7. What should happen if no results are found?

Once you answer these, I'll create a detailed implementation plan.

---

### Example 2: Ambiguous Request

**User Request**: "Make the app faster"

**Plan Mode Response**:

---

I need more specific information to help with performance. Let me ask:

**Identify Bottleneck**:
1. Which specific part is slow (app launch, list scrolling, data loading, navigation)?
2. Have you profiled the app to identify where time is spent?

**Context**:
3. What device are you testing on?
4. How much data is typically loaded?
5. Are you noticing issues with network calls, UI rendering, or data processing?

**Priorities**:
6. Would you prefer faster initial load or smoother scrolling?

Once I understand the specific performance issue, I can suggest targeted optimizations with measurable improvements.

---

### Example 3: Architectural Decision

**User Request**: "Should we use SwiftData or Core Data for persistence?"

**Plan Mode Response**:

---

Great question! Let me outline the trade-offs:

**Option A: SwiftData**
✅ Best when:
- iOS 17+ only (which matches your deployment target)
- Want modern Swift-first API
- Prefer property wrappers (@Model, @Query)
- Want CloudKit sync with less boilerplate

❌ Trade-off:
- Newer, less community resources
- Some advanced Core Data features not yet available
- Learning curve if team knows Core Data

**Option B: Core Data**
✅ Best when:
- Need maximum compatibility
- Want extensive community resources
- Require specific advanced features
- Team already experienced with Core Data

❌ Trade-off:
- More verbose API
- Objective-C legacy patterns
- More boilerplate for CloudKit

**My Recommendation**: SwiftData
**Reasoning**: Given your iOS 17+ target, modern codebase, and preference for native Swift patterns, SwiftData aligns better with ARC Labs philosophy.

**Would you like to proceed with SwiftData?**

---

---

## 🎯 Plan Mode Best Practices

### ✅ DO

- **Ask specific questions** - "How should we handle errors?" not "What do you think?"
- **Present options** - Show 2-3 alternatives with clear trade-offs
- **Be concise** - Keep plans focused and scannable
- **Update progress** - Keep user informed during implementation
- **Verify understanding** - Confirm details before implementing

### ❌ DON'T

- **Ask open-ended questions** - "How should this work?" (too vague)
- **Assume requirements** - Don't guess what user wants
- **Skip validation** - Always get approval before implementing
- **Provide single option** - Show alternatives when multiple approaches exist
- **Disappear during implementation** - Communicate progress

---

## 🔄 Adapting the Plan

### When Requirements Change Mid-Implementation

**Stop and reassess**:
1. Acknowledge the change
2. Evaluate impact on current progress
3. Propose adjusted plan
4. Get approval for new direction

**Example**:
```
"I understand we now need to support offline mode. This changes 
Steps 3-5 of our plan. Let me revise:

New Step 3: Add local caching layer
New Step 4: Implement sync mechanism
New Step 5: Handle conflicts

This adds approximately 2 days to the timeline. Should I proceed 
with the revised plan?"
```

---

## 📊 Complexity Assessment

### Simple (Direct Implementation)
- 1-2 files
- Single layer
- Clear requirements
- No architectural decisions
- < 100 lines of code

**Example**: "Add a computed property to User entity"

### Medium (Consider Plan Mode)
- 3-5 files
- 2 layers (e.g., Presentation + Domain)
- Some ambiguity
- Minor architectural considerations
- 100-300 lines of code

**Example**: "Add user profile editing"

### Complex (Always Plan Mode)
- 6+ files
- All 3 layers
- Multiple ambiguities
- Significant architectural decisions
- > 300 lines of code

**Example**: "Implement offline sync with conflict resolution"

---

## 🧪 Testing Plan Mode Itself

When creating a plan, verify:

- [ ] All ambiguities identified
- [ ] Specific questions asked (not vague)
- [ ] 2-3 options presented (when applicable)
- [ ] Trade-offs clearly explained
- [ ] Implementation steps are specific
- [ ] Testing strategy included
- [ ] Validation checklist provided

---

## 📚 Plan Mode Templates

### Template 1: Feature Implementation

```markdown
# Feature: [Name]

## Questions
1. [Architecture question]
2. [Scope question]
3. [Data question]
4. [UX question]
5. [Testing question]

## Proposed Approach
[2-3 sentences]

## Implementation Steps
### Step 1: Domain Layer
- Create entities
- Define protocols
- Implement use cases

### Step 2: Data Layer
- Implement repositories
- Create data sources
- Handle caching/persistence

### Step 3: Presentation Layer
- Create ViewModels
- Build Views
- Setup navigation

### Step 4: Testing
- Unit tests for use cases
- Repository tests
- ViewModel tests

## Validation
- [ ] Feature works end-to-end
- [ ] All tests pass
- [ ] Code reviewed
- [ ] Documentation updated
```

### Template 2: Architectural Decision

```markdown
# Decision: [Topic]

## Context
[Why this decision is needed]

## Options

### Option A: [Name]
**Pros**:
- Advantage 1
- Advantage 2

**Cons**:
- Disadvantage 1
- Disadvantage 2

**Best for**: [Specific scenario]

### Option B: [Name]
**Pros**:
- Advantage 1
- Advantage 2

**Cons**:
- Disadvantage 1
- Disadvantage 2

**Best for**: [Specific scenario]

## Recommendation
[My suggestion with reasoning]

## Next Steps
[What happens after decision is made]
```

---

## ✅ Plan Mode Checklist

Before exiting Plan Mode and starting implementation:

- [ ] All requirements clarified
- [ ] Architecture decisions made
- [ ] Implementation steps defined
- [ ] Testing strategy established
- [ ] User approved the plan
- [ ] Edge cases identified
- [ ] Trade-offs understood and accepted

---

**Remember**: Plan Mode isn't about delaying work—it's about **doing the right work the right way**. A few minutes of planning saves hours of rework. 🎯
