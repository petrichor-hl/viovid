import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://192.168.1.7:5262/api',
  ),
);
