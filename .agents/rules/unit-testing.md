---
trigger: always_on
---

# Rule: Mandatory Unit & Widget Testing

## Strict Rules
1. **1:1 Test Mapping:** Every single file containing logic or UI components in the `lib/` directory must have a corresponding test file in the `test/` directory following the exact same path structure and ending with `_test.dart`.
2. **Function Coverage:** Every function, method, and business logic flow (e.g., Cubit) must have a unit test verifying both the expected outcome (happy path) and edge cases.
3. **Widget Coverage:** Every UI widget must have a widget test (`testWidgets`) ensuring it renders successfully, contains its core elements, and responds to user interactions.

## Agent Action Checklist
Before marking any task as complete, you MUST:
1. Locate or create the matching `_test.dart` file.
2. Write the required unit or widget tests for the new/modified code.


---

## Reference Examples for Agent

### Example 1: Function Unit Test
* **File:** `lib/utils/calculator.dart`
* **Test File:** `test/utils/calculator_test.dart`

```dart
// Code
int add(int a, int b) => a + b;

// Test
void main() {
  group('Calculator - add', () {
    test('should return correct sum for positive numbers', () {
      final result = add(2, 3);
      expect(result, equals(5));
    });
  });
}