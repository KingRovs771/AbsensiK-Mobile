part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashAuthenticated extends SplashState {
  final UserEntity user;

  const SplashAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class SplashUnauthenticated extends SplashState {}
