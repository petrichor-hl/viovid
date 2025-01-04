import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.10.10.192:5262/api',
  ),
);
