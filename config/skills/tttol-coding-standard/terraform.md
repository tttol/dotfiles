# Terraform Language Guide

Standards for readable, maintainable Terraform 1.x configuration written in
HCL. Follow the repository's pinned Terraform and provider versions; this guide
does not replace provider-specific documentation.

## When to Use

- Writing or reviewing `.tf`, `.tfvars`, or `.tftest.hcl` files
- Designing Terraform modules, environments, workspaces, or state boundaries
- Reviewing provider configuration, resource dependencies, or lifecycle rules
- Standardizing Terraform validation, testing, and CI workflows

## How It Works

Terraform configuration declares the desired state of infrastructure. Terraform
builds a dependency graph from references such as
`aws_subnet.private.vpc_id`, compares that graph with state and the provider,
and proposes an execution plan. The configuration should therefore describe
resources, relationships, constraints, and module contracts rather than
implementing an imperative deployment script.

Keep these responsibilities separate:

- Root modules compose environments, configure providers and backends, and own
  deployment-specific values.
- Child modules group cohesive, reusable infrastructure and expose a small
  input/output contract.
- Providers implement the external infrastructure API.
- State records Terraform's view of managed objects and must be stored and
  protected as sensitive operational data.

## Core Principles

- Prefer clear declarations over clever expressions.
- Make module inputs and outputs explicit, typed, and documented.
- Keep modules cohesive and state boundaries intentionally small.
- Use stable resource identities; avoid accidental replacement caused by list
  ordering or changing indexes.
- Keep provider credentials, backend configuration, and secrets at the
  environment or CI boundary.
- Let Terraform infer dependencies from references; add explicit dependencies
  only when the graph cannot represent a real dependency.
- Treat every plan as a potentially destructive change and review it before
  applying it.
- Prefer the smallest abstraction that removes real duplication or isolates a
  changing concern. Do not turn simple resource declarations into an
  indirection maze.

## Declarative Design

### Describe relationships with references

Use resource and data-source references to express dependencies. Terraform can
then create, update, and destroy objects in the correct order.

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = var.private_subnet_cidr
}
```

Do not reproduce an imperative sequence with provisioners, shell scripts, or
artificial dependencies. Prefer a provider resource or data source that
models the desired result. Use `depends_on` only when a genuine dependency is
not visible through an expression.

### Prefer expressions over duplicated declarations

Use `for` expressions, `for_each`, and small locals when they make repeated
infrastructure explicit and predictable. Keep the expression simple enough
that a new maintainer can determine the resulting resources from the plan.

```hcl
variable "subnets" {
  type        = map(string)
  description = "CIDR blocks keyed by availability zone."
}

resource "aws_subnet" "private" {
  for_each          = var.subnets
  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = each.value
}

output "private_subnet_ids" {
  type        = map(string)
  description = "Private subnet IDs keyed by availability zone."
  value       = { for zone, subnet in aws_subnet.private : zone => subnet.id }
}
```

Avoid deeply nested conditionals, long transformation chains, and dynamic
blocks when ordinary blocks are clearer. HCL is declarative, but compact code
is not automatically understandable code.

### Keep values stable

- Prefer `for_each` with meaningful map or set keys when instances have stable
  identities or distinct configuration.
- Use `count` when instances are genuinely interchangeable or for a simple
  conditional resource.
- Do not derive `for_each` keys from unstable values or values known only after
  apply.
- Avoid changing a resource from `count` to `for_each` or changing its keys
  without planning the corresponding state migration.
- Prefer maps and objects over parallel lists whose indexes must remain
  synchronized.
- When refactoring resource addresses, use `moved` blocks or a reviewed state
  migration rather than deleting and recreating live infrastructure.

## Naming

Use descriptive nouns and separate words with underscores. Resource addresses
already include the resource type, so do not repeat the type in the local name.

```hcl
# Good: the resource address is aws_instance.web_api.
resource "aws_instance" "web_api" {
  # ...
}

# Avoid: the type is repeated and the identifier is not idiomatic HCL.
resource "aws_instance" "aws_web_api_instance" {
  # ...
}
```

Apply the same convention to variables, locals, outputs, modules, and data
sources:

- Use nouns such as `vpc_id`, `private_subnets`, and `name_suffix`.
- Use a verb only when the provider or domain concept is inherently an
  action, such as `enable_logging`.
- Use names that communicate the unit, scope, and shape of a value when that
  information is not obvious from its type.
- Keep names consistent across module inputs and outputs; avoid synonyms for
  the same concept.

## Formatting and Comments

- Run `terraform fmt` on every Terraform change. Use
  `terraform fmt -check -diff -recursive` in CI.
- Indent two spaces for each nesting level.
- Let `terraform fmt` align consecutive single-line arguments.
- Put arguments before nested blocks, with one blank line between logical
  groups.
- Put `count` or `for_each` first when present, then resource arguments,
  nested blocks, `lifecycle`, and finally `depends_on` when required.
- Separate top-level blocks and unrelated nested blocks with one blank line.
- Group related blocks together only when the provider semantics define them as
  one family.
- Use `#` for single-line and multi-line comments. Do not use `//` or `/* */`
  in new Terraform code.
- Write comments only to explain non-obvious intent, provider limitations,
  safety constraints, or a temporary workaround. Do not comment what the HCL
  already says.

```hcl
resource "aws_instance" "web" {
  for_each = var.web_instances

  ami           = each.value.ami
  instance_type = each.value.instance_type

  root_block_device {
    encrypted = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
```

## File Names and Layout

Use conventional files for small root modules:

```text
.
├── backend.tf       # backend configuration
├── main.tf          # resources and data sources
├── outputs.tf       # outputs, in alphabetical order
├── providers.tf     # provider configurations
├── terraform.tf     # required Terraform and provider versions
├── variables.tf     # variables, in alphabetical order
├── locals.tf        # locals referenced by multiple files
├── README.md        # purpose, inputs, outputs, and operations
└── .gitignore       # generated and sensitive files
```

Use logical files such as `network.tf`, `storage.tf`, or `compute.tf` when the
root module becomes difficult to navigate. The file name should make it
immediately clear where a maintainer can find a resource; do not split a
cohesive resource family only to follow a fixed file list.

Use local child modules under `./modules/<module_name>` when a repository owns
the module and cannot publish it to a registry. Keep actual environment
configuration separate from reusable module code:

```text
.
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── service/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── dev/
│   ├── backend.tf
│   ├── main.tf
│   └── terraform.tfvars.example
└── prod/
    ├── backend.tf
    ├── main.tf
    └── terraform.tfvars.example
```

For separate environments, use separate state and backend configuration. Keep
the main branch as the source of truth and use short-lived branches with pull
requests and speculative plans where the platform supports them.

Use `override.tf` and `*_override.tf` only for deliberate, temporary
overrides. They are loaded last and can hide the effective configuration;
document the original definition and the reason for the override.

## Version and Provider Configuration

Declare the Terraform version and every provider source and constraint in the
root module. Commit `.terraform.lock.hcl` so provider selections are
reviewable and reproducible.

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

The version constraint should match the repository's upgrade policy. Do not
silently widen or upgrade constraints as part of an unrelated change. Update
the lock file and review the resulting plan when intentionally upgrading.

Define all provider configurations in `providers.tf`. Always define a default
provider configuration before aliased configurations:

```hcl
provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "west"
  region = var.secondary_region
}

resource "aws_s3_bucket" "replica" {
  provider = aws.west
  bucket   = var.replica_bucket_name
}
```

Keep provider credentials out of HCL. Prefer provider-specific environment
variables, dynamic CI credentials, or a secrets manager. Pass provider aliases
explicitly to resources and modules that use them; avoid hiding cross-region
or cross-account behavior in a generic local value.

## Variables, Locals, and Outputs

### Variables are module contracts

Define a type and description for every variable. Add a default only when the
value is genuinely optional and the default is safe for every caller. Order
arguments as type, description, default, sensitive, and validation blocks.

```hcl
variable "web_instance_count" {
  type        = number
  description = "Number of web instances to deploy."
  default     = 2

  validation {
    condition     = var.web_instance_count >= 2
    error_message = "At least two web instances are required."
  }
}

variable "database_password" {
  type        = string
  description = "Password used by the database."
  sensitive   = true
}
```

Use object types to keep related values together and optional attributes when
the repository's pinned Terraform version supports them. Validate only
constraints that are specific to the module. Type constraints should handle
general shape; validation blocks should explain domain-specific requirements.

Do not expose every provider argument as a variable. Expose settings that
legitimately vary between deployments or are part of the module's public
contract. Keep stable implementation details local.

### Locals are named derived values

Use locals for a repeated expression, a shared naming convention, or a
meaningful derived value. Define cross-file locals in `locals.tf`; define a
file-specific local near the top of that file.

```hcl
locals {
  resource_name_prefix = "${var.application_name}-${var.environment}"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${local.resource_name_prefix}-logs"
}
```

Avoid using locals as aliases for one-off values or as a second programming
language. A long chain of locals hides the source of a value and makes plans
harder to understand.

### Outputs are module contracts

Provide a type, description, and value for every output. Mark an output as
`sensitive` when displaying it would expose sensitive data, but remember that
sensitivity does not remove the value from state.

```hcl
output "web_public_ip" {
  type        = string
  description = "Public IP address of the web service."
  value       = aws_instance.web.public_ip
}
```

Expose only values that callers, operators, or downstream state boundaries
need. Avoid returning an entire resource object when a stable ID, ARN, or
purpose-specific object is sufficient.

## Modules and Dependency Direction

Use a module for a cohesive capability that is provisioned, changed, and
operated together. Good module boundaries often follow domains such as
networking, queues, databases, or an application service. A module should not
be a thin wrapper around one resource unless it establishes a meaningful
contract, policy, or repeated pattern.

Apply the Dependency Inversion Principle at the module boundary:

- The root module owns environment composition, provider configuration, and
  deployment-specific values.
- A child module depends on declared inputs and provider interfaces rather than
  hard-coded account IDs, regions, credentials, or environment names.
- The child module exposes narrow outputs rather than leaking its complete
  implementation.
- Keep module `source` and registry `version` explicit. Terraform ignores
  `version` for local modules.
- Declare `required_providers` in reusable modules, while keeping concrete
  provider configurations in the root module.

```hcl
module "network" {
  source = "./modules/network"

  name   = var.application_name
  region = var.region
  cidr   = var.vpc_cidr
}
```

For a registry module, add an explicit `version` argument. Terraform does not
use `version` for a local module.

Apply the Open–Closed Principle selectively. Add a new module, map entry, or
provider configuration when a new environment or infrastructure variation
belongs to an existing family. Keep the module's stable resource policy
unchanged when the variation can be expressed through its contract. Do not
create generic modules with dozens of flags merely to avoid writing a small,
clear resource block.

## Resources, Data Sources, and Lifecycle

### Resource and data-source order

Terraform's graph, not file order, determines execution. Still, organize code
so it builds on itself for readers: define a data source before the resource
that uses it, then define the dependent resource.

Define data sources next to the resources that consume them unless the data
source is a shared concern that is clearer in a dedicated file.

### Explicit dependencies

Prefer an expression such as `subnet_id = aws_subnet.private.id` because it
both documents and creates the dependency. Use `depends_on` only for a real
dependency that cannot be represented by a value reference, and comment why it
is necessary. Broad module-level `depends_on` declarations often serialize
unrelated operations and make plans harder to interpret.

### Lifecycle rules

Use lifecycle meta-arguments to encode a deliberate safety or availability
invariant:

- Use `create_before_destroy` only when the provider and naming scheme support
  temporary coexistence.
- Use `prevent_destroy` for resources whose deletion must require an explicit
  review, not as a substitute for backups or access controls.
- Use `ignore_changes` only for fields intentionally managed outside Terraform;
  document the external owner and the reason.
- Prefer provider-supported replacement or migration mechanisms over lifecycle
  workarounds.

Treat lifecycle changes as high-risk. Review whether the rule changes the
destroy, replace, or drift behavior before applying it.

### Provisioners

Avoid `local-exec`, `remote-exec`, and other provisioners for normal resource
creation. Provisioners are difficult to make idempotent, portable, and
observable. Prefer a provider resource, a data source, a cloud-init/user-data
boundary where appropriate, or an external deployment system.

## State, Secrets, and Repository Hygiene

State may contain passwords, private keys, tokens, and other sensitive values.
Treat it as production data:

- Use a remote backend with encryption and state locking when the team or CI
  shares a state boundary.
- Grant the smallest practical read/write access to state.
- Avoid sharing a complete state file between workspaces; use outputs or data
  sources to share only the required values.
- Mark sensitive variables and outputs, but do not assume that the `sensitive`
  flag encrypts or removes values from state.
- Use environment variables, dynamic provider credentials, or a secrets
  manager instead of committing credentials or secret `.tfvars` files.
- Do not put secrets in resource names, tags, comments, output values, or plan
  artifacts.

Do not commit the following generated or sensitive files:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
.terraform.tfstate.lock.info
*.tfplan
*.plan
plan.out
*.tfvars
```

Use `terraform.tfvars.example` or another clearly non-secret example file for
documenting required inputs. Always commit Terraform source, the
`.terraform.lock.hcl` dependency lock file, `.gitignore`, and a README that
documents the module's purpose, inputs, outputs, backend assumptions, and
operational workflow.

## Validation, Testing, and CI

Run the smallest meaningful checks locally, then run the full repository
workflow before merging:

```bash
# Format and syntax checks
terraform fmt -check -diff -recursive
terraform init -backend=false
terraform validate

# Review the proposed infrastructure change
terraform plan

# Optional static analysis configured by the repository
tflint

# Terraform 1.6+ module tests, when the repository uses them
terraform test
```

`terraform validate` checks syntax and internal consistency, including types,
but does not verify provider-specific argument values or evaluate existing
state. A successful validation is necessary but not sufficient; review the
plan and provider behavior as well.

Use linting and policy checks when the repository has adopted them. Do not add
a new linter or policy engine to an existing project without agreeing on its
configuration and adoption path.

### Terraform tests

Write `.tftest.hcl` tests for reusable modules and run them in pull-request CI.
Keep tests deterministic and focused on module behavior. Structure each test
around the parent skill's Given–When–Then pattern:

```hcl
run "creates_required_tags" {
  # GIVEN
  variables {
    application_name = "example"
    environment      = "test"
  }

  # WHEN
  command = plan

  # THEN
  assert {
    condition     = output.resource_tags["Environment"] == "test"
    error_message = "The module must tag resources with the selected environment."
  }
}
```

Keep each test focused on one observable behavior. Use `mock_provider` or
provider-specific test facilities where they make the test independent of
external infrastructure. Use variable validation, preconditions,
postconditions, and check blocks to protect runtime infrastructure invariants;
use Terraform tests to verify configuration behavior. These are complementary
mechanisms, not substitutes for one another.

### Pull-request review

Every Terraform change should make the intended plan easy to review. Require
at least:

- Formatting, validation, linting, and applicable tests.
- A plan generated with the same Terraform, provider, credentials, and backend
  assumptions used for the target environment.
- Explicit review of additions, updates, replacements, and destroys.
- A migration or state-address plan when renaming resources, changing
  `count`/`for_each`, splitting modules, or moving state boundaries.
- A note explaining intentional lifecycle, `depends_on`, provider alias, or
  secret-handling changes.

## Quick Reference

| Practice | Guideline |
|---|---|
| Format | Two spaces; run `terraform fmt` |
| Names | Descriptive nouns in `snake_case`; do not repeat resource types |
| Variables | Declare `type` and `description`; expose only real variation |
| Outputs | Declare `type`, `description`, and `value`; mark sensitive values |
| Locals | Use for meaningful repeated or derived values, not aliases |
| Repetition | Prefer `for_each` for stable identities; use `count` sparingly |
| Dependencies | Prefer references; use `depends_on` only for hidden dependencies |
| Modules | Keep boundaries cohesive; root composes, child modules encapsulate |
| Providers | Pin versions; configure credentials outside HCL |
| State | Use protected remote state; never commit state or plan artifacts |
| Verification | `fmt`, `init -backend=false`, `validate`, plan, tests, and lint |
| Comments | Use `#` only for intent, constraints, or non-obvious behavior |

**Remember**: Terraform code is an executable infrastructure contract. Keep
the contract explicit, the dependency graph visible, the state protected, and
the plan understandable.

## References

- [HashiCorp Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style)
