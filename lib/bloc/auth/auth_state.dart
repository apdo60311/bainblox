part of 'auth_cubit.dart';

abstract class AuthState {}

class UserAuthInitial extends AuthState {}

class UserAuthLoading extends AuthState {}

class UserAuthSuccess extends AuthState {
  final UserModel user;

  UserAuthSuccess(this.user);
}

class UserAuthFailure extends AuthState {
  final String message;

  UserAuthFailure(this.message);
}

class UserUnAuthenticated extends AuthState {}

class UserLogout extends AuthState {}
