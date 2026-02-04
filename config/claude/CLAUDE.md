# Basic
- Always output answer in Japanese.  If you are asked something in English, you must answer in Japanese, no matter what.
- Output source-code comment in English. However, for repositories under ~/Git/, please output comments in Japanese except for `GIVEN`, `WHEN` and `THEN`. These three words mean the test-code pattern `Given-When-Then pattern`. 
- Do not use trailing spaces in source code.
- Do not apply empty lines, trailing spaces and tab characters in source code.
- Always ne conscious about `Don't Repeat Yourself`(DRY) 
- Always be conscious about `Keep It Simple Stupid!`(KISS) 
- Write immutable code wherever possible. Variables should not be reassigned after their initial declaration.
- You should not use global variables. You had better use small-scoped and immutable variables as possible.
- When introducing a new library, always use the latest version. For libraries already in use, please do not upgrade the version without prior consultation.


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
