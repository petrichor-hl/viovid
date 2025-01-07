import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://192.168.1.83:5262/api',
  ),
);
