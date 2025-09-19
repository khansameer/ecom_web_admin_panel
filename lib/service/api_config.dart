class ApiConfig {
  static const String accessToken = "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";
  static const String storeName = "merlettenyc-demo";
  static const String versionCode = "2025-07";
  static const baseUrl =
      "https://$storeName.myshopify.com/admin/api/$versionCode";
  static const productsUrl = '$baseUrl/products.json';
  static const ordersUrl = '$baseUrl/orders.json';
}
