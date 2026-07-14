import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_state.dart';
import 'package:unit_testing/app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:unit_testing/app/features/settings/presentation/cubit/settings_state.dart';
import 'package:unit_testing/app/features/settings/presentation/pages/settings_drawer.dart';

class MockAuthCubit extends Mock implements AuthCubit {}
class MockSettingsCubit extends Mock implements SettingsCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;
  late MockSettingsCubit mockSettingsCubit;

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
    mockSettingsCubit = MockSettingsCubit();

    when(() => mockAuthCubit.close()).thenAnswer((_) async {});
    when(() => mockSettingsCubit.close()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: mockAuthCubit),
          BlocProvider<SettingsCubit>.value(value: mockSettingsCubit),
        ],
        child: const Scaffold(
          endDrawer: SettingsDrawer(),
          body: SizedBox.shrink(),
        ),
      ),
    );
  }

  testWidgets('should render drawer menu items when user is Authenticated and settings are loaded',
      (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer(
        (_) => Stream.value(const Authenticated(user: tUser)));
    when(() => mockSettingsCubit.state)
        .thenReturn(const SettingsLoaded(themeMode: ThemeMode.system, aboutYou: ''));
    when(() => mockSettingsCubit.stream).thenAnswer(
        (_) => Stream.value(const SettingsLoaded(themeMode: ThemeMode.system, aboutYou: '')));

    await tester.pumpWidget(buildTestableWidget());

    // Open the end drawer
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openEndDrawer();
    await tester.pumpAndSettle();

    // Verify user name appears in header
    expect(find.text('Emily Johnson'), findsOneWidget);
    // Verify menu items are present
    expect(find.text('App Theme'), findsOneWidget);
    expect(find.text('About You'), findsOneWidget);
    expect(find.text('About App'), findsOneWidget);
    // Verify logout button is present
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('should call logoutUser on AuthCubit when Log Out tapped', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer(
        (_) => Stream.value(const Authenticated(user: tUser)));
    when(() => mockSettingsCubit.state)
        .thenReturn(const SettingsLoaded(themeMode: ThemeMode.light, aboutYou: ''));
    when(() => mockSettingsCubit.stream).thenAnswer(
        (_) => Stream.value(const SettingsLoaded(themeMode: ThemeMode.light, aboutYou: '')));
    when(() => mockAuthCubit.logoutUser()).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openEndDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log Out'));
    await tester.pump();

    verify(() => mockAuthCubit.logoutUser()).called(1);
  });
}
