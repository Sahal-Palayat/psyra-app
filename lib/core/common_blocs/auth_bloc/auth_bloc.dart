import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:psyra/core/common_models/user_model.dart';
import 'package:psyra/core/services/api_client_services.dart';
import 'package:psyra/core/services/local_storage_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await APIClientServices.login(
        email: event.email,
        password: event.password,
      );

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      await LocalStorageServices.saveToken(token);
      final user = UserModel.fromJson(userData);

      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await APIClientServices.signup(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      final token = response['token'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      await LocalStorageServices.saveToken(token);
      final user = UserModel.fromJson(userData);

      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await APIClientServices.logout();
      await LocalStorageServices.removeToken();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await LocalStorageServices.isLoggedIn();
    if (isLoggedIn) {
      // In a real app, you would fetch user data from storage or API
      // For now, we'll just set unauthenticated if token exists
      emit(const AuthUnauthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
