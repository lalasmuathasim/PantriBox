class AppEnvironment {
  const AppEnvironment({
    required this.apiBaseUrl,
    required this.environmentName,
  });

  factory AppEnvironment.current() {
    return const AppEnvironment(
      apiBaseUrl: String.fromEnvironment(
        'PANTRIBOX_API_BASE_URL',
        defaultValue: 'http://10.0.2.2:8000/api/v1',
      ),
      environmentName: String.fromEnvironment(
        'PANTRIBOX_ENV',
        defaultValue: 'development',
      ),
    );
  }

  final String apiBaseUrl;
  final String environmentName;
}
