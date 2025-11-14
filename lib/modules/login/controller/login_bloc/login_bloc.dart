import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginReset>(_onReset);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = event.email.trim();
    final isEmailValid = _validateEmail(email);
    emit(state.copyWith(
      email: email,
      isEmailValid: isEmailValid,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = event.password;
    final isPasswordValid = password.length >= 6;
    emit(state.copyWith(
      password: password,
      isPasswordValid: isPasswordValid,
      errorMessage: null,
    ));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) {
    if (state.isFormValid) {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
    } else {
      emit(state.copyWith(
        errorMessage: 'Please fill all fields correctly',
      ));
    }
  }

  void _onReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }

  bool _validateEmail(String email) {
    return email.contains('@') && email.contains('.') && email.length > 5;
  }
}
