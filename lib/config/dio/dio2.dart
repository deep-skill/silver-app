import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const dio2 = getDio;

Dio getDio(String accessToken) {
  return Dio(BaseOptions(
      baseUrl:
          'http://${dotenv.env['YOUR_IP']}:${dotenv.env['SERVER_PORT']}/silver-api/',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }));
}