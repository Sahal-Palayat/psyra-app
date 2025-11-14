part of 'signup_bloc.dart';

@immutable
class SignupState extends Equatable {
  final String email;
  final String password;
  final String name;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isNameValid;
  final bool isSubmitting;
  final String? errorMessage;

  const SignupState({
    this.email = '',
    this.password = '',
    this.name = '',
    this.isEmailValid = false,
    this.isPasswordValid = false,
    this.isNameValid = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  SignupState copyWith({
    String? email,
    String? password,
    String? name,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isNameValid,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isNameValid: isNameValid ?? this.isNameValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  bool get isFormValid =>
      isEmailValid && isPasswordValid && isNameValid && !isSubmitting;

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        isEmailValid,
        isPasswordValid,
        isNameValid,
        isSubmitting,
        errorMessage,
      ];
}

