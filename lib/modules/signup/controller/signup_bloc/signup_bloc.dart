import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupNameChanged>(_onNameChanged);
    on<SignupSubmitted>(_onSubmitted);
    on<SignupReset>(_onReset);
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = event.email.trim();
    final isEmailValid = _validateEmail(email);
    emit(state.copyWith(
      email: email,
      isEmailValid: isEmailValid,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = event.password;
    final isPasswordValid = password.length >= 6;
    emit(state.copyWith(
      password: password,
      isPasswordValid: isPasswordValid,
      errorMessage: null,
    ));
  }

  void _onNameChanged(SignupNameChanged event, Emitter<SignupState> emit) {
    final name = event.name.trim();
    final isNameValid = name.length >= 2;
    emit(state.copyWith(
      name: name,
      isNameValid: isNameValid,
      errorMessage: null,
    ));
  }

  void _onSubmitted(SignupSubmitted event, Emitter<SignupState> emit) {
    if (state.isFormValid) {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
    } else {
      emit(state.copyWith(
        errorMessage: 'Please fill all fields correctly',
      ));
    }
  }

  void _onReset(SignupReset event, Emitter<SignupState> emit) {
    emit(const SignupState());
  }

  bool _validateEmail(String email) {
    return email.contains('@') && email.contains('.') && email.length > 5;
  }
}

