import 'package:dio/dio.dart';


class PlacesInterceptor extends Interceptor {
final accessToken =
    "pk.eyJ1IjoiYXN0b3JlY2EiLCJhIjoiY2xneG93MzBlMDFrYjNnb2RsNDVpZnhwZiJ9.NHYVb3Ksua5SWNdKHRhNyA";
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      "access_token": accessToken,
      // "limit":7,
      "proximity":"-57.56176196603262,-38.02300270894258"
    });
    super.onRequest(options, handler);
  }
}
