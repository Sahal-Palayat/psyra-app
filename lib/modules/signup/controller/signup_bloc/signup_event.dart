part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupNameChanged extends SignupEvent {
  final String name;

  const SignupNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

class SignupReset extends SignupEvent {
  const SignupReset();
}

