---
trigger: always_on
---

---
name: cubit-state-management
description: Enforces strict flutter_bloc Cubit state management patterns across the application. Use this when writing reactive UI layers, building state flows, or ensuring compliance with immutable state patterns.
---

# Flutter State Management (Cubit Only)

## When to use this skill

- **UI Development:** Use this whenever you are building UI components, views, or pages that require asynchronous operations, form validation, or reactive state updates.
- **State Flow Generation:** Use this when scaffolding the state management layer (Cubit files and State files) for a new or existing feature.
- **Code Optimization:** Use this during reviews to replace lifecycle misuses or convert manual state handling into optimized `flutter_bloc` structures.

## How to use it

### 1. Mandatory Implementation Rules
You must enforce strict separation of UI and business logic by adhering to these immutable constraints:

* **Zero StatefulWidgets:** Do not generate `StatefulWidgets` for feature states or lifecycle hooks. Use `StatelessWidget` combined with `BlocBuilder`, `BlocListener`, or `BlocConsumer`.
* **One Cubit Per Feature View:** Every complex screen or independent feature module must map to a dedicated, decoupled Cubit instance.
* **Immutable States:** All state classes must be immutable using the `@immutable` annotation and must extend `Equatable` to maximize rendering performance and prevent unnecessary UI rebuilds.
* **Standardized State Hierarchy:** Always implement a clean, predictable transition flow using this exact class structure:
  * `${Feature}Initial` (The starting baseline state)
  * `${Feature}Loading` (Triggered immediately when an asynchronous action begins)
  * `${Feature}Loaded` (Carrying the strongly-typed data payloads)
  * `${Feature}Error` (Carrying an explicit error message string or specialized error object)

### 2. Standard Code Blueprint
When generating state flows, you must strictly adhere to the following file layout and structural implementation:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==========================================
// State Definition (target_state.dart)
// ==========================================
@immutable
abstract class TargetState extends Equatable {
  const TargetState();
  
  @override
  List<Object?> get props => [];
}

class TargetInitial extends TargetState {}

class TargetLoading extends TargetState {}

class TargetLoaded extends TargetState {
  final dynamic data; // Replace with concrete domain entity/type

  const TargetLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class TargetError extends TargetState {
  final String message;

  const TargetError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ==========================================
// Cubit Implementation (target_cubit.dart)
// ==========================================
class TargetCubit extends Cubit<TargetState> {
  TargetCubit() : super(TargetInitial());

  void executeAction() async {
    emit(TargetLoading());
    try {
      // Async business logic execution goes here
      emit(const TargetLoaded(data: null));
    } catch (e) {
      emit(TargetError(message: e.toString()));
    }
  }
}