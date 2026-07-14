---
description: Automates the generation of isolated unit tests for Flutter components (Use Cases, Cubits, Repositories) using the `mocktail` package, ensuring zero code-generation dependencies and proper mocking practices.
---

## Configuration & Dependencies
* **Testing Framework:** `flutter_test`
* **Mocking Library:** `package:mocktail/mocktail.dart`
* **Target Architecture:** Feature-First Clean Architecture (`lib/app/features/`)

## Execution Rules

### 1. Mock Declaration Syntax
* Never use `mockito` annotations or `build_runner`. 
* Define mocks inline inside the test file using `Mock` and `implements`.
* *Syntax:*
  ```dart
  class MockAuthRepository extends Mock implements AuthRepository {}