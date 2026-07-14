import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/core/constants/app_constants.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_state.dart';
import 'package:unit_testing/app/features/auth/presentation/pages/login_page.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.close()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: mockAuthCubit,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('should render all form elements correctly', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(Unauthenticated());
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(Unauthenticated()));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    expect(find.text(AppConstants.welcomeMessage), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('should call loginUser on cubit when login button is pressed with valid form', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(Unauthenticated());
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(Unauthenticated()));
    when(() => mockAuthCubit.loginUser(any(), any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    // Enter username and password
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'emilys');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'emilyspass');
    await tester.pump();

    // Tap submit button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => mockAuthCubit.loginUser('emilys', 'emilyspass')).called(1);
  });

  testWidgets('should render CircularProgressIndicator in login button when state is AuthLoading', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthLoading());
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(AuthLoading()));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Log In'), findsNothing);
  });

  testWidgets('should render error message text below login button when state is AuthError', (tester) async {
    const errorMessage = 'Invalid username or password';
    when(() => mockAuthCubit.state).thenReturn(const AuthError(message: errorMessage));
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const AuthError(message: errorMessage)));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('should toggle password visibility when suffix icon is tapped', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(Unauthenticated());
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(Unauthenticated()));

    await tester.pumpWidget(buildTestableWidget());

    // Initially obscureText is true
    final textFieldFinder = find.byType(TextField).last;
    final initialField = tester.widget<TextField>(textFieldFinder);
    expect(initialField.obscureText, isTrue);

    // Tap suffix icon (visibility button)
    final visibilityIconFinder = find.byIcon(Icons.visibility_off_outlined);
    expect(visibilityIconFinder, findsOneWidget);
    await tester.tap(visibilityIconFinder);
    await tester.pump();

    // Now obscureText is false
    final toggledField = tester.widget<TextField>(textFieldFinder);
    expect(toggledField.obscureText, isFalse);

    // Tap visibility icon again
    final visibilityOnIconFinder = find.byIcon(Icons.visibility_outlined);
    expect(visibilityOnIconFinder, findsOneWidget);
    await tester.tap(visibilityOnIconFinder);
    await tester.pump();

    // Now obscureText is true again
    final finalField = tester.widget<TextField>(textFieldFinder);
    expect(finalField.obscureText, isTrue);
  });
}
