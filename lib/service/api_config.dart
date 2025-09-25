class ApiConfig {
  static const String accessToken = "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";
  static const String storeName = "merlettenyc-demo";
  static const String versionCode = "2025-07";
  static const baseUrl =
      "https://$storeName.myshopify.com/admin/api/$versionCode";
  static const productsUrl = '$baseUrl/products.json';
  static const ordersUrl = '$baseUrl/orders.json';
  static const customerUrl = '$baseUrl/customers.json';
  static const totalCustomerUrl = '$baseUrl/customers/count.json';
  static const totalProductUrl = '$baseUrl/products/count.json';
  static const totalOrderUrl = '$baseUrl/orders/count.json';
  static const getImageUrl = '$baseUrl/products';
  static const getCustomerImage = '$baseUrl/customers';
  static const getOrderById = '$baseUrl/orders';
}
