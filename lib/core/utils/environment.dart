class Environment {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.106.222.191:8080/v1/',
  );

  static const String assetsBase = String.fromEnvironment(
    'ASSETS_BASE',
    defaultValue: 'http://10.106.222.191:8080/',
  );

  static String get uploadsUrl => '${assetsBase}uploads/';
}