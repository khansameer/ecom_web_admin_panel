class AppConfig {
  String accessToken = "";
  String storeName = "";
  String versionCode = "";
  String logoUrl = "";

  // Singleton
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
}
