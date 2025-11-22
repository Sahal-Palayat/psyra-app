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
    print('🔵 ========================================');
    print('🔵 AUTH BLOC: Login Requested');
    print('🔵 ========================================');
    print('🔵 Email: ${event.email}');
    print('🔵 Password: ${event.password}');
    
    emit(const AuthLoading());
    print('🔵 Auth state changed to: AuthLoading');
    
    try {
      print('🔵 Calling APIClientServices.login...');
      final response = await APIClientServices.login(
        email: event.email,
        password: event.password,
      );

      print('✅ API Response received:');
      print('🔵 Response data: $response');

      // The API returns user data directly in the data field
      // Response structure: { "_id": "...", "email": "...", "name": "...", ... }
      // We'll use _id as a token identifier or generate a token from the response
      final userId = response['_id']?.toString() ?? '';
      print('🔵 User ID extracted: $userId');
      
      if (userId.isEmpty) {
        print('❌ User ID is empty!');
        throw Exception('User ID not found in response');
      }

      // Create user model from the response data
      print('🔵 Creating UserModel from response...');
      final user = UserModel.fromJson(response);
      print('✅ UserModel created: ${user.name} (${user.email})');

      // For token, we can use the _id or generate one
      // In a real app, the API should return a JWT token
      final token = response['token']?.toString() ?? 
          response['access_token']?.toString() ?? 
          userId; // Fallback to userId if no token provided
      print('🔵 Token: $token');

      print('🔵 Saving token to local storage...');
      await LocalStorageServices.saveToken(token);
      print('✅ Token saved successfully');
      
      print('🔵 Emitting AuthAuthenticated state...');
      emit(AuthAuthenticated(user: user, token: token));
      print('✅ Login successful!');
      print('🔵 ========================================');
    } catch (e) {
      print('❌ ========================================');
      print('❌ LOGIN ERROR OCCURRED');
      print('❌ ========================================');
      print('❌ Error: $e');
      print('❌ Error type: ${e.runtimeType}');
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      print('❌ Error message: $errorMessage');
      print('❌ ========================================');
      emit(AuthError(errorMessage));
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

      // Handle different response formats
      final token = response['token']?.toString() ??
          response['data']?['token']?.toString() ??
          response['access_token']?.toString() ??
          '';
      
      if (token.isEmpty) {
        throw Exception('Token not found in response');
      }

      final userData = response['user'] as Map<String, dynamic>? ??
          response['data']?['user'] as Map<String, dynamic>? ??
          {};

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
      // Get token before removing it
      final token = await LocalStorageServices.getToken();
      await APIClientServices.logout(token: token);
      await LocalStorageServices.removeToken();
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if logout API fails, remove token locally
      await LocalStorageServices.removeToken();
      emit(const AuthUnauthenticated());
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
