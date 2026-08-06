# Python Language Guide

Apply these rules to Python code. Favor explicit types, small cohesive modules, and predictable resource and error handling.

## Types and data modeling

- Add type hints to public functions, methods, important attributes, and module boundaries.
- Prefer `dataclass(frozen=True)` or other immutable value objects for data that should not change after construction.
- Use `Enum`, `Literal`, `Protocol`, and discriminated data shapes to represent domain constraints instead of untyped string conventions.
- Use `collections.abc` interfaces such as `Sequence`, `Mapping`, and `Iterable` when accepting general inputs.
- Avoid `Any`; use `object` or a precise union and narrow it explicitly when data is untrusted.
- Keep validation at parsing, configuration, and I/O boundaries so domain functions receive meaningful typed values.

## Values and control flow

- Prefer immutable values, local scope, and explicit arguments. Avoid module-level mutable state and hidden caches.
- Never use mutable default arguments. Use `None` with explicit construction or a `default_factory` for dataclasses.
- Prefer comprehensions, generator expressions, and standard-library transformations over collection-building loops with repeated `append`.
- Use context managers for files, locks, database connections, and other resources.
- Raise specific exceptions with useful messages. Never use bare `except`; catch only what can be handled and use `raise ... from ...` when translating errors.
- Avoid `assert` for runtime validation because optimized execution can remove assertions.
- Keep blocking I/O out of async code and use the project's async-compatible APIs when an async boundary exists.

## Modules and dependencies

- Organize packages around domain capabilities and keep import direction clear.
- Keep framework and infrastructure details at boundaries. Inject collaborators instead of importing global services or constructing them throughout business logic.
- Use the standard library or existing project dependencies before adding a package. Follow the repository's supported Python version and tooling.
- Format and lint with the repository's configured tools, commonly `ruff` and a formatter, without imposing new tools on an existing project.

## Testing

- Follow the parent skill's Given–When–Then rules.
- Use fixtures and parameterization from the project's test framework for repeatable scenarios.
- Test behavior and error contracts, avoid sleeps and shared mutable fixtures, and compare complete value objects when that is the contract under test.
