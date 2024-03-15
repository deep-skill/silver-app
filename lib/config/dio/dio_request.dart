import 'package:dio/dio.dart';
import 'package:silverapp/env/env.dart';

const dio = getDio;

Dio getDio(String accessToken) {
  return Dio(BaseOptions(
      baseUrl: Env.httpRequest,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }));
}
