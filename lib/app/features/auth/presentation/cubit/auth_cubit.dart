import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/update_profile_photo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final UpdateProfilePhoto updateProfilePhotoUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateProfilePhotoUseCase,
  }) : super(AuthInitial());

  Future<void> checkSession() async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(email, password);
      emit(Authenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> logoutUser() async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> updateUserPhoto(String photoUrl) async {
    final currentState = state;
    if (currentState is Authenticated) {
      emit(AuthLoading());
      try {
        final updatedUser = await updateProfilePhotoUseCase(photoUrl);
        emit(Authenticated(user: updatedUser));
      } catch (e) {
        emit(AuthError(message: e.toString()));
        emit(Authenticated(user: currentState.user));
      }
    }
  }
}
