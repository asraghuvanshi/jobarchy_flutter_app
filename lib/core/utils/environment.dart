class Environment {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.242.208.191:8080/v1/',
  );
}