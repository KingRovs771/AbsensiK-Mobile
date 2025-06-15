import 'package:equatable/equatable.dart';

// Kelas dasar abstrak untuk semua state splash
// Menggunakan Equatable agar mudah membandingkan state jika diperlukan
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class DisplaySplash extends SplashState {}

class Authenticated extends SplashState {}

class UnAuthenticated extends SplashState {}
