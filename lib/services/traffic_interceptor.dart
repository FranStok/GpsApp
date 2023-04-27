import 'package:dio/dio.dart';

const accessToken =
    "pk.eyJ1IjoiYXN0b3JlY2EiLCJhIjoiY2xneG93MzBlMDFrYjNnb2RsNDVpZnhwZiJ9.NHYVb3Ksua5SWNdKHRhNyA";
//Este interceptor sirve para completar el URL de la peticion get con los datos que le falta.
class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      //Estos son los parametros que vienen en la peticion get. Mirar la peticion en postman.
      "alternatives": false,
      "geometries": "polyline6",
      "overview": "simplified",
      "steps": false,
      "access_token": accessToken
    });
    super.onRequest(options, handler);
  }
}
