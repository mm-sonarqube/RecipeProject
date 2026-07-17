import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:unit_testing/app/features/auth/domain/entities/user.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:unit_testing/app/features/auth/presentation/cubit/auth_state.dart';
import 'package:unit_testing/app/features/settings/presentation/pages/settings_profile_page.dart';

class MockAuthCubit extends Mock implements AuthCubit {}
class MockHttpClient extends Mock implements HttpClient {}
class MockHttpClientRequest extends Mock implements HttpClientRequest {}
class MockHttpClientResponse extends Mock implements HttpClientResponse {}
class MockHttpHeaders extends Mock implements HttpHeaders {}

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = MockHttpClient();
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();
    final headers = MockHttpHeaders();

    when(() => request.headers).thenReturn(headers);
    when(() => request.close()).thenAnswer((_) async => response);
    when(() => client.getUrl(any())).thenAnswer((_) async => request);

    when(() => response.statusCode).thenReturn(200);
    when(() => response.compressionState).thenReturn(HttpClientResponseCompressionState.notCompressed);
    when(() => response.contentLength).thenReturn(transparentImage.length);
    when(() => response.listen(
      any(),
      cancelOnError: any(named: 'cancelOnError'),
      onDone: any(named: 'onDone'),
      onError: any(named: 'onError'),
    )).thenAnswer((invocation) {
      final void Function(List<int>) onData = invocation.positionalArguments[0];
      final void Function()? onDone = invocation.namedArguments[#onDone];
      final Function? onError = invocation.namedArguments[#onError];
      final bool? cancelOnError = invocation.namedArguments[#cancelOnError];

      return Stream<List<int>>.fromIterable([transparentImage]).listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError,
      );
    });

    return client;
  }
}

final transparentImage = Uint8List.fromList([
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00, 0xFF, 0xFF, 0xFF,
  0x00, 0x00, 0x00, 0x21, 0xF9, 0x04, 0x01, 0x00, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00,
  0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3B
]);

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

  setUpAll(() {
    registerFallbackValue(Uri());
    HttpOverrides.global = TestHttpOverrides();
  });

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.close()).thenAnswer((_) async {});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: mockAuthCubit,
        child: const SettingsProfilePage(),
      ),
    );
  }

  testWidgets('should render CircularProgressIndicator when state is not Authenticated', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthInitial());
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(AuthInitial()).asBroadcastStream());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should render profile details correctly when user is Authenticated', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const Authenticated(user: tUser)).asBroadcastStream());

    await tester.pumpWidget(buildTestableWidget());

    // Verified fields are displayed correctly
    expect(find.text('Emily Johnson'), findsOneWidget);
    expect(find.text('emily.johnson@x.dummyjson.com'), findsAtLeastNWidgets(1));
    expect(find.text('emilys'), findsOneWidget);
    expect(find.text('Amateur'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);
  });

  testWidgets('should open bottom sheet and call updateUserPhoto with preset when preset is tapped', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const Authenticated(user: tUser)).asBroadcastStream());
    when(() => mockAuthCubit.updateUserPhoto(any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    // Find the edit button on avatar
    final editButton = find.byIcon(Icons.edit_rounded);
    expect(editButton, findsOneWidget);

    await tester.tap(editButton);
    await tester.pumpAndSettle();

    // Verify bottom sheet is shown
    expect(find.text('Choose Profile Photo'), findsOneWidget);

    // Tap the first preset avatar inside the ListView
    final firstPreset = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(CircleAvatar),
    ).first;
    await tester.tap(firstPreset);
    await tester.pumpAndSettle();

    // Verify it called update photo with first preset URL
    verify(() => mockAuthCubit.updateUserPhoto(SettingsProfilePage.avatarPresets[0])).called(1);
  });

  testWidgets('should call updateUserPhoto with custom URL when apply button is tapped', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => Stream.value(const Authenticated(user: tUser)).asBroadcastStream());
    when(() => mockAuthCubit.updateUserPhoto(any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildTestableWidget());

    await tester.tap(find.byIcon(Icons.edit_rounded));
    await tester.pumpAndSettle();

    // Type in custom URL text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'https://example.com/myphoto.jpg');
    await tester.pump();

    // Tap Apply button
    final applyButton = find.text('Apply');
    expect(applyButton, findsOneWidget);
    await tester.tap(applyButton);
    await tester.pumpAndSettle();

    // Verify it called update photo with the custom URL
    verify(() => mockAuthCubit.updateUserPhoto('https://example.com/myphoto.jpg')).called(1);
  });

  testWidgets('should pop navigation stack when state changes to Unauthenticated', (tester) async {
    final controller = StreamController<AuthState>.broadcast();
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => controller.stream);

    bool popped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<AuthCubit>.value(
                          value: mockAuthCubit,
                          child: const SettingsProfilePage(),
                        ),
                      ),
                    ).then((_) => popped = true);
                  },
                  child: const Text('Go to profile'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // Navigate to profile page
    await tester.tap(find.text('Go to profile'));
    await tester.pumpAndSettle();

    // Emit Unauthenticated
    controller.add(Unauthenticated());
    await tester.pumpAndSettle();

    expect(popped, isTrue);
    await controller.close();
  });

  testWidgets('should show SnackBar when state changes to AuthError', (tester) async {
    final controller = StreamController<AuthState>.broadcast();
    when(() => mockAuthCubit.state).thenReturn(const Authenticated(user: tUser));
    when(() => mockAuthCubit.stream).thenAnswer((_) => controller.stream);

    await tester.pumpWidget(buildTestableWidget());

    // Emit AuthError
    controller.add(const AuthError(message: 'Update profile failed'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Update profile failed'), findsOneWidget);

    await controller.close();
  });
}
