# Basic
- Always output answer in Japanese, but output source-code comment in English. If you are asked something in English, you must answer in Japanese, no matter what.
- Do not use trailing spaces in source code.
- Do not apply empty lines, trailing spaces and tab characters in source code.
- Always ne conscious about `Don't Repeat Yourself`(DRY) 
- Always be conscious about `Keep It Simple Stupid!`(KISS) 
- Always make the implementation simple. You should not install unnecessary additional libraries or write unnecessarily complex conditional logic. First, consider whether you can achieve the requirements using only the standard library, and only consider installing additional libraries when it's genuinely difficult to accomplish with the standard library alone.
- Write immutable code wherever possible. Variables should not be reassigned after their initial declaration.
- You should not use global variables. You had better use small-scoped and immutable variables as possible.
 
# Test Code
- Follow the AAA pattern: Arrange, Act, and Assert. These represent the three phases of a test.
- Arrange: Set up your test data, mocks, expected values, and everything else you need.
- Act: Execute the method you're testing. Keep this to a single line - each test should focus on one method only. Don't test multiple methods in a single test.
- Assert: Verify that you got the expected results.
Here is a sample of AAA pattern.
```javascript
class Calculator {
  add(a, b) {
    return a + b;
  }
}

describe('Calculator', () => {
  describe('add', () => {
    test('Add two numbers', () => {
      // Arrange
      const calculator = new Calculator();
      const num1 = 5;
      const num2 = 3;
      const expected = 8;
      
      // Act
      const result = calculator.add(num1, num2);
      
      // Assert
      expect(result).toBe(expected);
    });
  });
});

```
- Don't change a method's visibility just to make tests pass (for example, changing private to public).
- Use parameterized test pattern as possinble.

# Language-Specific instructions
## HTML/CSS
- Avoid using flexbox whenever possible - explore alternative CSS solutions first. Only use flexbox when it's truly the only way to achieve the requirement.

