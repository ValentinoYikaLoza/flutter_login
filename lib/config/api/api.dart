import 'package:dio/dio.dart';
import 'package:login/features/service/key_value_storage_service.dart';

import '../constants/environment.dart';
import '../constants/storage_keys.dart';


class Api {
  final Dio _dioBase = Dio(BaseOptions(baseUrl: Environment.urlBase));

  final keyValueStorageService = KeyValueStorageService();
  InterceptorsWrapper interceptor = InterceptorsWrapper();

  Api() {
    interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token =
            await keyValueStorageService.getKeyValue<String>(StorageKeys.token);
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['Accept'] = 'application/json';

        return handler.next(options);
      },
    );
    _dioBase.interceptors.add(interceptor); //Añade interceptores en cada petición
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dioBase.get(path, queryParameters: queryParameters); //Realiza peticiones GET con los parámetros
  }

  Future<Response> post(String path, {required Object data}) async {
    return _dioBase.post(path, data: data); //Realiza peticiones post con los parámetros
  }
}
