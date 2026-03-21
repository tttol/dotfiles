## Basic
- Always output answer in Japanese.  If you are asked something in English, you must answer in Japanese, no matter what.
- Output source-code comment in English. However, for repositories under ~/Git/, please output comments in Japanese except for `GIVEN`, `WHEN` and `THEN`. These three words mean the test-code pattern `Given-When-Then pattern`. 
- Do not use trailing spaces in source code.
- Do not apply empty lines, trailing spaces and tab characters in source code.
- Always ne conscious about `Don't Repeat Yourself`(DRY) 
- Always be conscious about `Keep It Simple Stupid!`(KISS) 
- Write immutable code wherever possible. Variables should not be reassigned after their initial declaration.
- You should not use global variables. You had better use small-scoped and immutable variables as possible.
- When introducing a new library, always use the latest version. For libraries already in use, please do not upgrade the version without prior consultation.

# Commands
- Use modern alternatives for common commands: `eza` instead of `ls`, `fd` instead of `find`, `rg` instead of `grep`, and `bat` instead of `cat`. 

## Code Style Preferences
### Method Policy
Avoid over-splitting logic into too many methods. As a rule of thumb, a method should be at least 5 lines long. Anything shorter generally doesn't need to be extracted. However, you may still create a shorter method if it significantly improves code readability.
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
### Simple Implementation
Always make the implementation simple. You should not install unnecessary additional libraries or write unnecessarily complex conditional logic. First, consider whether you can achieve the requirements using only the standard library, and only consider installing additional libraries when it's genuinely difficult to accomplish with the standard library alone.


### Functional Programming
Prefer Functional Programming patterns over Imperative Programming to ensure immutability and readability.
- Avoid Imperative State Mutation: Do not initialize empty collections and push/append elements using loops.
- Emphasize Declarative Transformations: Use stream-like operations, list comprehensions, or high-order functions (e.g., map, filter, reduce).
- Immutability: Treat data as immutable. Return new collections instead of modifying existing ones.
```py
# BAD
records = []
for i in range(10):
    records.append(i)


# GOOD
records = [i for i in range(10)]
```

```java
// BAD
List<Integer> list = new ArrayList<>();
for (int i = 0; i < 10; i++) {
    list.add(i);
}

// GOOD
List<Integer> list = IntStream.range(0, 10).boxed().toList();
```

### Test Code
Use test-code/SKILL.md which is agent skill for implmenting test code. This skill defines a guidline of test code.

### Immutability
- Default to immutable variables.
- Java: Use `final` for local variables.
- TypeScript/JS: Prefer `const` over `let` or `var`.
```java
// ❌ Avoid
var message = "Hello";
message = message + " World"; 

// ✅ Prefer
final var message = "Hello World";
```

```ts
// ❌ Avoid
let userRole = "admin";
var score = 100;

// ✅ Prefer
const userRole = "admin";
const score = 100;
```

## Test Code
The guideline for test code. This guideline can be applied for all languages.
### Basic Framework
Follow the Given-When-Then pattern. These represent the three phases of a test.
- Given: Set up your test data, mocks, expected values, and everything else you need.
- When: Execute the method you're testing. Keep this to a single line - each test should focus on one method only. Don't test multiple methods in a single test.
- Then: Verify that you got the expected results.
Here is a sample of Given-When-Then pattern.
```javascript
class Calculator {
  add(a, b) {
    return a + b;
  }
}

describe('Calculator', () => {
  describe('add', () => {
    test('Add two numbers', () => {
      // GIVEN
      const calculator = new Calculator();
      const num1 = 5;
      const num2 = 3;
      const expected = 8;
      
      // WHEN
      const result = calculator.add(num1, num2);
      
      // THEN
      expect(result).toBe(expected);
    });
  });
});

```

### Guideline
- **Visibility:** Don't change a method's visibility just to make tests pass (for example, changing private to public).
- **Parameterized Test:** Use parameterized test pattern as possinble.
- **Object Assertion:** When performing assertions on an object in your test code, avoid writing an assertThat for every single property of the object. Instead, you should compare the objects directly (or compare the expected object with the actual object).  Here is a sample assertion.
```java
// --- ❌BAD: Manual field-by-field assertions are verbose and harder to maintain ---
var actual = response.getResults().get(0);
assertThat(actual.primaryFlag()).isEqualTo("1");
assertThat(actual.secondaryFlag()).isEqualTo("0");


// --- ✅GOOD: Using recursive comparison against a helper method improves clarity ---
public void test() {
    var actual = response.body();
    
    assertThat(actual)
        .usingRecursiveComparison()
        .isEqualTo(createExpectedResponse());
}

private TargetResponse createExpectedResponse() {
    var expected = new TargetResponse();
    var detail = new DetailInfo();
    
    // Set simplified properties for demonstration
    detail.setIdentifier("ID_001");
    detail.setStatus(ProcessStatus.COMPLETED);
    
    expected.setDetailInfo(detail);
    return expected;
}

```
- **Consistency:** Check if the target test passes when you updated a test code. The only thing you should do is run the tests you updated. You don't have to run all of the tests."
- **Declarative Test Code:** Declare the `expected` variable explicitly. Here is a sample.
```java
// --- ❌BAD: Hard to read because expected value generation and validation rules are mixed ---
var actual = mapper.readValue(responseBody, TargetResponse.class);

assertThat(actual)
    .usingRecursiveComparison()
    .ignoringFields("metadata.timestamp") // Exclude dynamic values like timestamps
    .isEqualTo(createExpectedResponse("ID_001", "Sample Item")); // Inline generation makes it cluttered


// --- ✅GOOD: Clear separation between "What to expect" and "How to compare" ---
var actual = mapper.readValue(responseBody, TargetResponse.class);

// 1. Define the expected object
var expected = createExpectedResponse("ID_001", "Sample Item");

// 2. Perform the assertion with specific rules
assertThat(actual)
    .usingRecursiveComparison()
    .ignoringFields("metadata.timestamp")
    .isEqualTo(expected);
```
- **No Logic in Tests:** Strictly prohibit the use of `if` statements within test code. Test logic should be linear and deterministic; we do not write tests for the test code itself, so branching must be avoided to ensure test reliability.


