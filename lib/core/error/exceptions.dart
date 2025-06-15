class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Terjadi Kesalahan Pada Server']);

  @override
  String toString() => 'Server Exception: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Terjadi kesalahan pada cache.']);

  @override
  String toString() => 'CacheException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(
      [this.message = 'Akses tidak sah. Silakan login kembali.']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Tidak ada koneksi internet.']);

  @override
  String toString() => 'NetworkException: $message';
}
