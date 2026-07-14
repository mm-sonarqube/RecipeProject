import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_state.dart';
import 'package:unit_testing/app/features/auth/presentation/pages/profile_page.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;
  const tUser = User(
    id: 1,
    username: 'emilys',
    firstName: 'Emily',
    lastName: 'Johnson',
    email: 'emily.johnson@x.dummyjson.com',
    photoUrl: '',
    accessToken: 'access123',
    refreshToken: 'refresh456',
  );

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.close()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: mockAuthCubit,
        child: const ProfilePage(),
      ),
    );
  }

  testWidgets('should render profile details correctly when user is Authenticated', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const Authenticated(user: tUser)));

    await tester.pumpWidget(buildTestableWidget());

    // Full name is now displayed as the primary display text
    expect(find.text('Emily Johnson'), findsOneWidget);
    // Email shown as subtitle
    expect(find.text('emily.johnson@x.dummyjson.com'), findsOneWidget);
    expect(find.text('Amateur'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  testWidgets('should call logoutUser on cubit when logout button clicked', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const Authenticated(user: tUser)));
    when(() => mockAuthCubit.logoutUser()).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    final logoutButton = find.text('Log Out');
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pump();

    verify(() => mockAuthCubit.logoutUser()).called(1);
  });
}
