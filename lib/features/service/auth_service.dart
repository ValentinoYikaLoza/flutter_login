import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login/features/service/storage_service.dart';
import 'package:login/features/service/service_exception.dart';

import '../../../config/api/api.dart';
import '../models/login_response.dart';

final api = Api();

class AuthService {
  static Future<LoginResponse> login({
    required String user,
    required String password,
  }) async {
    try {
      Map<String, dynamic> form = {
        'username': user,
        'password': password,
      };

      final response = await api.post('/login', data: form);
      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw ServiceException('Usuario o contraseña incorrecta');
      }
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response?.statusCode == 401) {
        errorMessage = 'Usuario o contraseña incorrecta';
      } else {
        errorMessage = 'Hubo un error en la conexión.';
      }
      throw ServiceException(errorMessage);
    } catch (e) {
      throw ServiceException('Algo salió mal.');
    }
  }

  //JSON WEB TOKENS
  static Future<(bool, int)> verifyToken() async {
    final token = await StorageService.get<String>('token');
    if (token == null) return (false, 0);

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Obtiene la marca de tiempo de expiración del token
    int expirationTimestamp = decodedToken['exp'];

    // Obtiene la marca de tiempo actual
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    //si el token es invalido

    // Calcula el tiempo restante hasta la expiración en segundos
    int timeRemainingInSeconds = expirationTimestamp - currentTimestamp;

    if (timeRemainingInSeconds <= 0) {
      return (false, 0);
    }
    return (true, timeRemainingInSeconds);
  }
}
