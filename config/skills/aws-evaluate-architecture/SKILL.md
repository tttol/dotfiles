---
name: aws-evaluate-architecture
description: Evaluate whether a user's architecture idea, system requirement, operational concern, or vague design hypothesis can be implemented or solved with AWS resources. Use when the user asks if an AWS service or architecture can realize requirements, compare AWS options, validate feasibility against official AWS documentation, design an AWS solution from rough intent, or run an iterative Goal-based research cycle using awslabs.aws-documentation-mcp-server@latest.
---

# AWS Evaluate Architecture

## Overview

Use this skill to turn a rough architecture idea or requirement into an evidence-backed AWS feasibility assessment. Always ground service behavior, quotas, limitations, integration details, and recommended patterns in official AWS documentation retrieved through `awslabs.aws-documentation-mcp-server@latest`.

## Required Tooling

- Use `tool_search` to discover AWS documentation MCP tools before researching.
- Prefer tools exposed by `awslabs.aws-documentation-mcp-server@latest` for AWS documentation lookup, page retrieval, and recommendations.
- If the AWS documentation MCP server is unavailable, say so clearly and ask whether to continue with web search or local knowledge. Do not present undocumented AWS claims as verified.
- Use the Goal feature for non-trivial investigations. Create one concrete goal for the user's architecture question, keep it active while cycling, and mark it complete only after the final feasibility answer is delivered.

## Goal Cycle

For every non-trivial request, create a Goal whose objective names the user's desired outcome. Run this cycle until the answer is sufficiently supported:

1. Capture intent
   - Restate the user's business or technical goal in one sentence.
   - Extract functional requirements, non-functional requirements, constraints, workloads, data shape, compliance needs, budget sensitivity, and unknowns.
   - Ask at most three clarifying questions only when a missing answer would change the service category or invalidate the conclusion.

2. Form hypotheses
   - Propose one primary AWS architecture path and one or two alternatives when meaningful.
   - Name the AWS resources involved, including managed services, integration points, data stores, networking, identity, observability, and deployment units.
   - Identify assumptions explicitly before researching.

3. Verify with AWS documentation
   - Search official AWS docs through the AWS documentation MCP server for each critical claim.
   - Verify service capabilities, integration support, regional or account limitations, quotas, consistency or durability behavior, security controls, pricing dimensions, and operational tradeoffs.
   - Prefer current AWS service documentation over blog posts. Use architecture blogs only for patterns, not as the sole source of service capability.

4. Evaluate feasibility
   - Classify the idea as `実現可能`, `条件付きで実現可能`, `代替案推奨`, or `実現困難`.
   - Explain the decisive reasons, blockers, hidden risks, and what must be changed for success.
   - Keep the design KISS: prefer managed services and fewer moving parts unless the requirement demands otherwise.
   - Keep the design DRY: avoid duplicated pipelines, duplicated data stores, or repeated operational mechanisms unless isolation is intentional.

5. Refine
   - If evidence contradicts the first hypothesis, update the architecture path and research only the changed claims.
   - Continue the Goal cycle until the remaining uncertainty is explicit and acceptable.

6. Deliver
   - Answer in Japanese unless the user explicitly requires an artifact in another language.
   - Include a concise recommended architecture, why it works, relevant AWS resources, key tradeoffs, risks, and next validation steps.
   - Cite the AWS documentation pages or tool results used as sources when the MCP tool provides source URLs or document identifiers.
   - Mark the Goal complete after the response is ready.

## Research Discipline

- Verify all time-sensitive AWS facts. AWS service capabilities, quotas, regions, names, and pricing change often.
- Separate verified facts from inferences. Use wording such as `AWS Docsで確認済み` and `推論` when it helps the user see confidence levels.
- Do not over-design. Start with the smallest AWS architecture that satisfies the requirement, then add components only for stated reliability, security, scale, or compliance needs.
- Prefer AWS Well-Architected framing for tradeoffs: operational excellence, security, reliability, performance efficiency, cost optimization, and sustainability.
- When pricing matters, identify pricing dimensions rather than estimating exact monthly cost unless the user provides workload numbers.

## Output Shape

Use this structure unless the user asks for a different format:

```markdown
**結論**
実現可能性: 実現可能 / 条件付きで実現可能 / 代替案推奨 / 実現困難

**推奨構成**
- AWS resource A: purpose
- AWS resource B: purpose

**根拠**
- Verified point with AWS documentation source
- Verified point with AWS documentation source

**注意点**
- Risk or tradeoff
- Open assumption

**次の検証**
- Smallest proof-of-concept or decision needed next
```

Keep the final answer concise for simple questions. Use diagrams only when the architecture has enough components that text becomes hard to scan.
