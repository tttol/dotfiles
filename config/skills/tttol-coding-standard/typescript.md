# TypeScript Language Guide

Apply these rules to TypeScript and JavaScript code. Favor the type system and the runtime's explicit boundaries without turning simple code into ceremony.

## Types and APIs

- Enable and preserve strict compiler checks, especially `strictNullChecks`, in the project's `tsconfig`.
- Avoid `any`. Use `unknown` at untrusted boundaries, then narrow it with validation or type guards.
- Model domain alternatives with discriminated unions and make state transitions explicit.
- Prefer `type` for unions, intersections, and local composition. Use `interface` when an object contract is intentionally extensible or implemented by classes.
- Give exported functions and public class methods explicit parameter and return types. Let local variables infer obvious types.
- Prefer branded or opaque types when mixing structurally identical primitives would permit invalid combinations, such as user IDs and order IDs.
- Keep runtime validation at API, configuration, serialization, and message boundaries. TypeScript types do not validate runtime data.

## Values and control flow

- Prefer `const`; use `readonly` properties and `ReadonlyArray` or `readonly T[]` for values that callers must not mutate.
- Prefer pure functions and non-mutating transformations. Use `map`, `filter`, `reduce`, and `flatMap` when they improve clarity; use a loop when it is clearer than a long chain.
- Avoid non-null assertions (`!`) and type assertions (`as`) unless a checked invariant justifies them near the assertion.
- Handle every discriminated-union variant. Use an `assertNever` helper or an equivalent exhaustive check for business-critical switches.
- Do not silently ignore rejected promises. Await promises, return them, or handle errors intentionally.
- Treat values caught by `catch` as `unknown`; narrow them before reading properties or rethrowing with context.

## Modules and dependencies

- Keep modules cohesive and imports directed toward stable layers. Remove cycles rather than masking them with barrel exports.
- Prefer named exports and explicit dependency injection at external boundaries.
- Keep browser, Node.js, framework, and persistence types out of domain code when a boundary is practical.
- Use the repository's configured formatter, linter, compiler, and test runner. Do not add a package for a problem already solved by the standard library or existing dependencies.

## Testing

- Follow the parent skill's Given–When–Then rules.
- Test observable behavior and boundary validation rather than implementation details.
- Use parameterized cases for equivalent inputs and assert complete objects where the test represents an object contract.
