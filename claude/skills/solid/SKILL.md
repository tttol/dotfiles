# SOLID Principles Skill

This skill reviews and improves code based on the SOLID principles in object-oriented programming.

## What are SOLID Principles?

SOLID principles are five design principles for creating maintainable, extensible, and understandable software:

1. **S**ingle Responsibility Principle
   - A class should have only one responsibility
   - There should be only one reason to change

2. **O**pen/Closed Principle
   - Open for extension, closed for modification
   - New functionality should be added without changing existing code

3. **L**iskov Substitution Principle
   - Subclasses should be substitutable for their base classes
   - Inheritance relationships should be properly designed

4. **I**nterface Segregation Principle
   - Clients should not be forced to depend on methods they don't use
   - Many small, specific interfaces are better than one large interface

5. **D**ependency Inversion Principle
   - High-level modules should not depend on low-level modules
   - Both should depend on abstractions

## How to Use This Skill

During code reviews, check SOLID principles compliance from these perspectives:

- Does each class/function have a single responsibility?
- Is the design extensible?
- Are inheritance relationships appropriate?
- Are interfaces properly segregated?
- Are dependencies properly managed?

For detailed explanations, refer to individual principle files:
- [Single Responsibility Principle Details](srp.md)
- [Open/Closed Principle Details](ocp.md)
- [Liskov Substitution Principle Details](lsp.md)
- [Interface Segregation Principle Details](isp.md)
- [Dependency Inversion Principle Details](dip.md)

## Instructions

For the provided code, please:

1. Analyze the code from SOLID principles perspective
2. Identify which principles are violated
3. Provide specific improvement suggestions and refactoring examples
4. Explain how the improved code complies with SOLID principles
