---
name: code-review
description: "Reviews a code for quality, security, maintainability and human-readble. Triggers on: 'review code', 'review changes', 'code review' and 'コードレビュー'."
---

# Code Review
A code reviewer for all luanguage.(Java, JavaScript, TypeScript, Python, Rust and more)

## Proactive Usage
- When implementing a new code or refactoring an existing code
- When reviewing

## Viewing a PR
Use `gh` command when viewing a PR. For example, `gh pr view 37`.

## Output
Outputs the result of review with markdown file. The file name must be `ai-review-result_[the name of current git branch]_[yyyyMMdd].md`.The format is here.

```md
# The result of review
The title of these code changes.

## ❌CRITICAL
Critical issues those must be fixed.
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
## 🔴HIGH
Issues those should be fixed.
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
## 🟡MEDIUM
Issues those 
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
## 🔵LOW
### Comment1: aaaa
detail comment
### Comment2: bbb
detail comment
```

Save this result file to {repository root directory}/docs/reviews/. If nothing, create a new directory.

## Checklist
Review with these perspectives.

### Quality
- **Strict Compliance:** Adhere to all guidelines defined in `CLAUDE.md` or `AGENTS.md`.
- **Open-Closed Principle:** Follow the 'O' in SOLID; ensure entities are open for extension but closed for modification.
- **Type Safety**: Use proper type for each variable.
- **Error handling**: Use appropriate exception-based error handling and avoid swallowing thrown exceptions.

### Security
- **Secret Management:** Do not hard-code secrets (API keys, credentials). Use environment variables or a secure parameter store.
```typescript
// ❌ Bad: Hard-coded secrets
const databaseConfig = {
  host: "production-db.example.com",
  username: "admin",
  password: "SuperSecret123!",
  apiKey: "sk-1234567890abcdef",
};

// ✅ Good: Using environment variables
import { config } from "dotenv";

config();

const databaseConfig = {
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || "5432"),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  apiKey: process.env.EXTERNAL_API_KEY,
};

// Validate required environment variables at startup
function validateEnvVariables(): void {
  const required = ["DB_HOST", "DB_USERNAME", "DB_PASSWORD"];
  const missing = required.filter((key) => !process.env[key]);
  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(", ")}`);
  }
}
```
- **Injection Prevention:** Prevent SQL injection by using Object-Relational Mappers (ORM) or parameterized queries instead of raw SQL strings.
```typescript
// ❌ Bad: String concatenation vulnerable to SQL injection
async function findUserByEmail(email: string) {
  const query = `SELECT * FROM users WHERE email = '${email}'`;
  return await db.query(query);
}
// Attack: email = "'; DROP TABLE users; --"

// ✅ Good: Using parameterized queries with ORM (Prisma example)
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function findUserByEmail(email: string) {
  return await prisma.user.findUnique({
    where: { email: email },
  });
}

// ✅ Good: Parameterized raw query when ORM is not suitable
async function searchUsers(searchTerm: string) {
  return await prisma.$queryRaw`
    SELECT * FROM users 
    WHERE name ILIKE ${`%${searchTerm}%`}
  `;
}
```
- **Input Validation:** Enforce strict validation for all user-provided inputs.
- **Data Privacy (PII):** Never expose Personally Identifiable Information (PII), including usernames, emails, or passwords.
- **Masking:** If sensitive data must be displayed, apply masking (e.g., `2026-01-01 12:34:59.000 The username is [MASKED]`).
- **Dependency Management:** Use only the latest stable versions of libraries to minimize vulnerability risks. Use web search when applying some libraries.

### Readability & Style
- **Method Separation:** Insert a single blank line between method definitions.
- **Documentation:** Provide structured comments for all classes and methods (e.g., JavaDoc, JSDoc).
```typescript
// ❌ Bad: No documentation or cryptic comments
class AuthenticationService {
  // login
  async login(email: string, password: string) {
    const user = await this.userRepository.findByEmail(email);
    // check
    if (!user) throw new Error("error");
    return await this.generateTokens(user);
  }
}

// ✅ Good: Structured JSDoc comments
/**
 * Service responsible for user authentication and session management.
 * Handles login, logout, token refresh, and password reset operations.
 */
class AuthenticationService {
  /**
   * Authenticates a user with email and password credentials.
   * Creates a new session and returns access tokens upon success.
   *
   * @param email - The user's email address
   * @param password - The user's plain text password
   * @returns Authentication result containing access and refresh tokens
   * @throws {InvalidCredentialsError} When email or password is incorrect
   * @throws {AccountLockedError} When account is locked due to failed attempts
   *
   * @example
   * const result = await authService.login('user@example.com', 'password123');
   * console.log(result.accessToken);
   */
  async login(email: string, password: string): Promise<AuthResult> {
    const user = await this.userRepository.findByEmail(email);
    if (!user || !(await this.verifyPassword(password, user.passwordHash))) {
      throw new InvalidCredentialsError("Invalid email or password");
    }
    const tokens = await this.generateTokens(user);
    await this.createSession(user.id, tokens.refreshToken);
    return tokens;
  }
}
```
- **Method Granularity:** Maintain meaningful logic within methods. Each method should generally exceed 5 lines; avoid excessive over-splitting that compromises readability. Avoid over-splitting logic into too many methods. Each method has more than 5 lines of code.
```typescript
// ❌ Bad: Over-split into tiny methods that harm readability
class OrderProcessor {
  private hasItems(items: OrderItem[]): boolean {
    return items.length > 0;
  }

  private isPositive(value: number): boolean {
    return value > 0;
  }

  private isNonNegative(value: number): boolean {
    return value >= 0;
  }

  private multiplyValues(a: number, b: number): number {
    return a * b;
  }

  private addValues(a: number, b: number): number {
    return a + b;
  }

  // Results in dozens of trivial methods that obscure the actual logic
}

// ✅ Good: Meaningful methods with substantial logic (>5 lines)
class OrderProcessor {
  async processOrder(orderId: string): Promise<ProcessedOrder> {
    const order = await this.orderRepository.findById(orderId);
    if (!order) {
      throw new NotFoundError(`Order ${orderId} not found`);
    }
    const validationResult = this.validateOrderItems(order.items);
    if (!validationResult.isValid) {
      throw new ValidationError(validationResult.errors.join(", "));
    }
    const totalAmount = this.calculateTotalWithTax(order.items, order.taxRate);
    const processedOrder = await this.orderRepository.update(orderId, {
      status: "processed",
      totalAmount: totalAmount,
      processedAt: new Date(),
    });
    await this.notificationService.sendOrderConfirmation(order.customerEmail, processedOrder);
    return processedOrder;
  }

  private validateOrderItems(items: OrderItem[]): ValidationResult {
    const errors: string[] = [];
    if (items.length === 0) {
      errors.push("Order must contain at least one item");
    }
    for (const item of items) {
      if (item.quantity <= 0) {
        errors.push(`Invalid quantity for item ${item.productId}`);
      }
      if (item.price < 0) {
        errors.push(`Invalid price for item ${item.productId}`);
      }
    }
    return { isValid: errors.length === 0, errors };
  }

  private calculateTotalWithTax(items: OrderItem[], taxRate: number): number {
    const subtotal = items.reduce((sum, item) => {
      const itemTotal = item.price * item.quantity;
      const discount = item.discountPercent ? itemTotal * (item.discountPercent / 100) : 0;
      return sum + (itemTotal - discount);
    }, 0);
    const taxAmount = subtotal * (taxRate / 100);
    return Math.round((subtotal + taxAmount) * 100) / 100;
  }
}
```
### Transaction
- Apply transaction context manager pattern. Database transactions should be scoped appropriately, rather than being applied to every single SQL statement. For example,the annotation of `@Transactional` in Java or the decorator of `@contextmanager` in Python. Here is sample code.
```java
// ===== BAD CASE =====
// Each SQL statement has its own transaction - no atomicity guarantee
@Service
public class OrderServiceBad {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private InventoryRepository inventoryRepository;
    
    // No @Transactional - each repository call runs in its own transaction
    public void createOrder(Order order) {
        orderRepository.save(order);           // Transaction 1
        inventoryRepository.decreaseStock(order.getProductId(), order.getQuantity()); // Transaction 2
    }
}

// ===== GOOD CASE =====
// All operations within a single transaction - atomicity guaranteed
@Service
public class OrderServiceGood {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private InventoryRepository inventoryRepository;
    
    @Transactional // All operations share the same transaction
    public void createOrder(Order order) {
        orderRepository.save(order);
        inventoryRepository.decreaseStock(order.getProductId(), order.getQuantity());
    }
}
```

```python
# ===== BAD CASE =====
# Manual commit after each operation - no atomicity
class OrderServiceBad:
    def __init__(self, session: Session):
        self.session = session
    
    def create_order(self, order_data: dict) -> None:
        # Each operation commits independently
        order = Order(**order_data)
        self.session.add(order)
        self.session.commit()  # Commit 1
        
        self.session.query(Inventory).filter_by(
            product_id=order.product_id
        ).update({"stock": Inventory.stock - order.quantity})
        self.session.commit()  # Commit 2
        
        payment = Payment(order_id=order.id, amount=order.total)
        self.session.add(payment)
        self.session.commit()  # Commit 3
        # If payment processing fails after commit, previous changes persist!


# ===== GOOD CASE =====
# Using context manager pattern for proper transaction scoping
from contextlib import contextmanager
from sqlalchemy.orm import Session

@contextmanager
def transaction_scope(session_factory):
    """Provide a transactional scope around a series of operations."""
    session = session_factory()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()


class OrderServiceGood:
    def __init__(self, session_factory):
        self.session_factory = session_factory
    
    def create_order(self, order_data: dict) -> Order:
        # All operations within a single transaction
        with transaction_scope(self.session_factory) as session:
            order = Order(**order_data)
            session.add(order)
            
            session.query(Inventory).filter_by(
                product_id=order.product_id
            ).update({"stock": Inventory.stock - order.quantity})
            
            payment = Payment(order_id=order.id, amount=order.total)
            session.add(payment)
            
            # Commit happens automatically at end of 'with' block
            # Rollback happens automatically if any exception occurs
            return order
    
    def get_order_with_details(self, order_id: int) -> Order:
        # Read-only operation - still benefits from consistent snapshot
        with transaction_scope(self.session_factory) as session:
            return session.query(Order).options(
                joinedload(Order.items),
                joinedload(Order.payment)
            ).filter_by(id=order_id).first()
```
