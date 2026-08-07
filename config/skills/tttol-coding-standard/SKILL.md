---
name: tttol-coding-standard
description: Apply tttol's software architecture and coding standards, including SOLID principles such as the Open–Closed and Dependency Inversion Principles, when implementing, refactoring, or reviewing code written in any programming language. Read the matching language guide in this skill for language-specific rules.
---

# tttol's Coding Standard

Apply this skill when designing software, changing production code, reviewing a patch, or writing tests. Use the architecture rules below for every language, then read only the language guide relevant to the files being changed.

## 1. When to Use

- Designing or reviewing software architecture, module boundaries, or dependency direction
- Implementing, refactoring, or reviewing source code written in any programming language
- Designing public APIs, domain models, infrastructure boundaries, or dependency injection
- Writing or reviewing tests that should follow the Given–When–Then pattern

## 2. Select the language guide

Inspect file extensions and the repository's build files before editing. Read the applicable guide before making language-specific decisions:

- Java: [java.md](java.md)
- Rust: [rust.md](rust.md)
- TypeScript or JavaScript: [typescript.md](typescript.md)
- Python: [python.md](python.md)

For a mixed-language change, read every relevant guide. Do not load unrelated guides merely because they are present.

## 3. SOLID: Open–Closed Principle

Apply the Open–Closed Principle (OCP) to behavior that is likely to change:

> Keep stable software entities closed to modification and open to extension.

Interpret “closed” as protecting a stable policy or core workflow from changes required by every new variation. It does not mean that no existing file may ever change. A factory, registry, configuration, or composition root is an intentional change point; the business logic that consumes the abstraction should not need to change for each new behavior.

### 3.1. Identify an OCP violation

Treat a central conditional as a warning sign when every new behavior requires adding another branch to already-tested core logic:

```java
enum Direction {
    UP, DOWN, UNDEFINED
}

final class KeyHandler {
    Direction onKey(String input) {
        return switch (input) {
            case "↑" -> Direction.UP;
            case "↓" -> Direction.DOWN;
            default -> Direction.UNDEFINED;
        };
    }
}
```

Adding left and right keys requires modifying both the `Direction` enum and the `switch` in `onKey`. The handler's existing behavior must be changed and revalidated even though the new behavior is conceptually another member of the same family. This increases the chance of regressions in stable behavior.

### 3.2. Prefer an extension boundary

Use an abstraction for interchangeable behavior and keep the core consumer dependent on that abstraction. The Strategy pattern is a natural fit when each variation has its own algorithm or behavior:

```java
interface KeyEvent {
    Direction execute();
}

final class UpKeyEvent implements KeyEvent {
    @Override
    public Direction execute() {
        return Direction.UP;
    }
}

final class DownKeyEvent implements KeyEvent {
    @Override
    public Direction execute() {
        return Direction.DOWN;
    }
}

final class UndefinedKeyEvent implements KeyEvent {
    @Override
    public Direction execute() {
        return Direction.UNDEFINED;
    }
}

final class KeyHandler {
    Direction onKey(KeyEvent event) {
        return event.execute();
    }
}
```

Keep input-to-strategy selection at the composition boundary:

```java
import java.util.Map;
import java.util.function.Supplier;

final class KeyEventFactory {
    private static final Map<String, Supplier<KeyEvent>> KEY_EVENT_FACTORIES = Map.of(
        "↑", UpKeyEvent::new,
        "↓", DownKeyEvent::new
    );

    static KeyEvent create(String input) {
        return KEY_EVENT_FACTORIES
            .getOrDefault(input, UndefinedKeyEvent::new)
            .get();
    }
}
```

When a new key is introduced, add the new domain output to `Direction` when necessary, add a `KeyEvent` implementation, and register it at the factory or registry. Keep `KeyHandler.onKey` unchanged. The handler is closed to modification, while the family of key behaviors is open to extension.

### 3.3. Other patterns that support OCP

Choose the pattern according to what is expected to vary. These patterns create different extension boundaries; none of them makes every part of the system permanently closed to modification.

#### 3.3.1. State

Use State when an object's behavior changes according to its current state. Add a new state object instead of expanding a conditional in the context:

```java
interface OrderState {
    OrderState pay();
}

record PendingOrder() implements OrderState {
    @Override
    public OrderState pay() {
        return new PaidOrder();
    }
}

record PaidOrder() implements OrderState {
    @Override
    public OrderState pay() {
        return this;
    }
}

record Order(OrderState state) {
    Order pay() {
        return new Order(state.pay());
    }
}
```

Adding `CancelledOrder` or `RefundedOrder` does not require modifying `Order`. Keep state transitions inside the state model and avoid using State for a small, fixed conditional.

#### 3.3.2. Command

Use Command when requests or actions vary, especially when they must be queued, logged, retried, or undone:

```java
interface EditorCommand {
    void execute();
}

final class SaveCommand implements EditorCommand {
    @Override
    public void execute() {
        System.out.println("Saved");
    }
}

final class UndoCommand implements EditorCommand {
    @Override
    public void execute() {
        System.out.println("Undone");
    }
}

final class EditorInvoker {
    void run(EditorCommand command) {
        command.execute();
    }
}
```

Add a new command without modifying `EditorInvoker`. Keep the command interface small and move the actual domain operation into a collaborator when the command would otherwise become a large service.

#### 3.3.3. Chain of Responsibility

Use Chain of Responsibility when a request may be handled by one of several handlers and the handler sequence is configurable:

```java
interface InputHandler {
    Optional<Direction> handle(String input);
}

final class ArrowInputHandler implements InputHandler {
    @Override
    public Optional<Direction> handle(String input) {
        return switch (input) {
            case "↑" -> Optional.of(Direction.UP);
            case "↓" -> Optional.of(Direction.DOWN);
            default -> Optional.empty();
        };
    }
}

final class InputDispatcher {
    private final List<InputHandler> handlers;

    InputDispatcher(List<InputHandler> handlers) {
        this.handlers = List.copyOf(handlers);
    }

    Direction dispatch(String input) {
        return handlers.stream()
            .map(handler -> handler.handle(input))
            .flatMap(Optional::stream)
            .findFirst()
            .orElse(Direction.UNDEFINED);
    }
}
```

Add a new handler and configure it in the chain without changing `InputDispatcher`. Define ordering and fallback behavior explicitly because the chain's order is part of its behavior.

#### 3.3.4. Decorator

Use Decorator when optional responsibilities can be layered around the same object:

```java
record Message(String text) {}

interface Notifier {
    void send(Message message);
}

final class EmailNotifier implements Notifier {
    @Override
    public void send(Message message) {
        System.out.println("Email: " + message.text());
    }
}

final class LoggingNotifier implements Notifier {
    private final Notifier delegate;

    LoggingNotifier(Notifier delegate) {
        this.delegate = delegate;
    }

    @Override
    public void send(Message message) {
        System.out.println("Sending notification");
        delegate.send(message);
    }
}
```

Add retry, metrics, authorization, or tracing behavior as another decorator. Keep decorators substitutable for the original interface and avoid creating a deep, order-sensitive wrapper stack without a clear reason.

#### 3.3.5. Template Method

Use Template Method when the overall workflow is stable but some steps vary:

```java
abstract class DataImporter {
    final List<ImportRecord> importData(String raw) {
        final var records = parse(raw);
        validate(records);
        return List.copyOf(records);
    }

    protected abstract List<ImportRecord> parse(String raw);

    protected void validate(List<ImportRecord> records) {
        records.forEach(Objects::requireNonNull);
    }
}

final class CsvImporter extends DataImporter {
    @Override
    protected List<ImportRecord> parse(String raw) {
        return CsvParser.parse(raw);
    }
}
```

Add `JsonImporter` or another importer without modifying the stable workflow. Prefer composition or Strategy when inheritance would create tight coupling or when multiple dimensions of variation are needed.

#### 3.3.6. Factory Method

Use Factory Method when a stable workflow needs to create a product whose concrete type varies:

```java
interface ReportExporter {
    void export(Report report);
}

abstract class ReportJob {
    final void run(Report report) {
        createExporter().export(report);
    }

    protected abstract ReportExporter createExporter();
}

final class CsvReportJob extends ReportJob {
    @Override
    protected ReportExporter createExporter() {
        return new CsvReportExporter();
    }
}
```

Add a new job and exporter without modifying `ReportJob`. Keep the factory method focused on creation; do not use it to hide unrelated business logic.

#### 3.3.7. Abstract Factory

Use Abstract Factory when several related products must vary together:

```java
interface Button {
    void render();
}

interface Dialog {
    void render();
}

interface UiFactory {
    Button createButton();
    Dialog createDialog();
}

final class WindowsUiFactory implements UiFactory {
    public Button createButton() {
        return new WindowsButton();
    }

    public Dialog createDialog() {
        return new WindowsDialog();
    }
}

final class SettingsScreen {
    private final UiFactory factory;

    SettingsScreen(UiFactory factory) {
        this.factory = factory;
    }
}
```

Add `MacUiFactory` without modifying `SettingsScreen`. Use Abstract Factory only when the product family must remain compatible; otherwise, a smaller factory or direct dependency is clearer.

#### 3.3.8. Bridge

Use Bridge when two independent dimensions of variation would otherwise create a class for every combination:

```java
interface MessageSender {
    void send(String message);
}

final class EmailSender implements MessageSender {
    public void send(String message) {
        System.out.println("Email: " + message);
    }
}

abstract class Alert {
    protected final MessageSender sender;

    protected Alert(MessageSender sender) {
        this.sender = sender;
    }

    abstract void send();
}

final class SecurityAlert extends Alert {
    SecurityAlert(MessageSender sender) {
        super(sender);
    }

    void send() {
        sender.send("Security alert");
    }
}
```

Add a new alert type or sender independently. Bridge is useful when both the abstraction and its implementation are expected to evolve.

#### 3.3.9. Observer

Use Observer when new consumers should react to an event without modifying the event publisher:

```java
interface PriceObserver {
    void onPriceChanged(String symbol, int price);
}

final class PriceFeed {
    private final List<PriceObserver> observers;

    PriceFeed(List<PriceObserver> observers) {
        this.observers = List.copyOf(observers);
    }

    void publish(String symbol, int price) {
        observers.forEach(observer -> observer.onPriceChanged(symbol, price));
    }
}

final class PriceAlert implements PriceObserver {
    public void onPriceChanged(String symbol, int price) {
        System.out.println(symbol + " changed to " + price);
    }
}
```

Add `AuditLogger` or `PortfolioUpdater` as another observer. Define event ownership, delivery guarantees, and failure handling explicitly because observers can make control flow and debugging less obvious.

#### 3.3.10. Visitor

Use Visitor when the object structure is stable but new operations over that structure are expected:

```java
interface Shape {
    <R> R accept(ShapeVisitor<R> visitor);
}

record Circle(double radius) implements Shape {
    public <R> R accept(ShapeVisitor<R> visitor) {
        return visitor.visit(this);
    }
}

interface ShapeVisitor<R> {
    R visit(Circle circle);
}

final class AreaVisitor implements ShapeVisitor<Double> {
    public Double visit(Circle circle) {
        return Math.PI * circle.radius() * circle.radius();
    }
}
```

Add `PerimeterVisitor` without modifying `Circle`. Visitor reverses the trade-off: adding a new shape requires updating every visitor, so use it only when the element hierarchy is more stable than the operations.

### 3.4. Apply OCP deliberately

- Use OCP where a family of interchangeable behaviors is expected to grow or change independently of its consumer.
- Place the extension point at the stable policy boundary, not inside every small conditional.
- Prefer composition, dependency injection, a registry, or a Strategy implementation over repeatedly editing core business logic.
- Keep the extension contract small and domain-oriented. Do not expose framework or persistence details through it.
- Test the stable consumer against the abstraction, each new strategy independently, and the factory or registry mapping at its boundary.
- Do not force OCP onto a small, stable, one-off decision. Extra interfaces, classes, and registries are harmful when the variation is unlikely or the abstraction is less clear than a simple conditional.

## 4. Declarative and Functional Programming

Prefer declarative and functional programming over procedural programming whenever it makes the intent clearer. Describe the result to produce rather than manually controlling every mutation and iteration.

### 4.1. Prefer transformations over mutable accumulation

```java
// Procedural: expose temporary state and mutation.
final var proceduralActiveNames = new ArrayList<String>();
for (final var user : users) {
    if (user.isActive()) {
        proceduralActiveNames.add(user.name());
    }
}

// Declarative: describe filtering and projection.
final var declarativeActiveNames = users.stream()
    .filter(User::isActive)
    .map(User::name)
    .toList();
```

### 4.2. Apply functional principles

- Prefer immutable values, pure functions, explicit inputs and outputs, and method/function arguments that are immutable or exposed through read-only types. Treat mutable arguments as a dangerous design smell; avoid mutating caller-owned data, and remember that `final` or `const` references alone do not make the referenced object immutable.
- Prefer every method or function to return a meaningful value; avoid `void` or `None` in domain and application logic, reserving them for unavoidable side-effect boundaries.
- Represent multiple return values with an immutable record, tuple, struct, or dataclass instead of mutating output parameters.
- Use `map`, `filter`, `reduce`, comprehensions, iterators, or equivalent transformations when they improve readability.
- Avoid initializing an empty collection and repeatedly calling `push`, `append`, or `add` inside a loop when a direct transformation expresses the same result.
- Keep side effects such as I/O, logging, time, randomness, and mutation at clear boundaries.
- Compose small meaningful operations instead of embedding unrelated decisions in one long pipeline.
- Use a procedural loop when it is clearer, when early exit is important, or when a transformation would become difficult to read. Do not force functional constructs for their own sake.

## 5. Dependency Inversion Principle (DIP)

Apply the Dependency Inversion Principle to keep high-level business policies independent from low-level infrastructure details:

> High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details; details should depend on abstractions.

DIP is about dependency direction, not about using a Java `interface`. Dependency injection is one implementation technique: provide a collaborator from outside instead of constructing a concrete detail inside the high-level module. The abstraction should be owned by the high-level policy and contain only the operations that policy needs.

### 5.1. Java: inject an interface

```java
interface UserRepository {
    Optional<User> findById(UserId id);
}

final class UserService {
    private final UserRepository repository;

    UserService(UserRepository repository) {
        this.repository = repository;
    }

    Optional<User> findUser(UserId id) {
        return repository.findById(id);
    }
}
```

`UserService` depends on the repository abstraction, not on MySQL, a web framework, or a concrete repository. The application composition root can inject `SqlUserRepository` in production and an in-memory fake in tests.

Non-OOP languages can apply the same principle with traits, protocols, function types, closures, or modules. Read the relevant language guide when implementing those abstractions.

### 5.2. Apply DIP deliberately

- Apply DIP selectively; do not abstract every component. Identify frequently changing or externally volatile components and place an abstraction at their boundary so stable policy depends on the abstraction.
- Keep stable, simple components concrete when there is no meaningful change pressure, substitution need, or testing benefit. Unnecessary abstractions add indirection and make the design harder to understand.
- Define ports, traits, protocols, or function types near the high-level policy that consumes them.
- Keep adapters, databases, frameworks, file systems, clocks, and network clients at the edges of the system.
- Inject dependencies at the composition root; do not construct infrastructure inside domain or application logic.
- Keep abstractions narrow and intention-revealing. Do not create an interface for every class or wrap stable pure functions without a real substitution need.
- Prefer static dispatch and generics when they fit; use dynamic dispatch, protocols, or closures when runtime substitution is required.
- Test high-level policy with deterministic fakes or in-memory implementations, then test infrastructure adapters separately.
- Return values from ports and services rather than mutating caller-owned arguments or hiding effects in global state.
