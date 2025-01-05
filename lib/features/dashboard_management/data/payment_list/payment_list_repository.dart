import 'dart:developer';
import 'package:viovid/features/dashboard_management/data/payment_list/payment_list_api_service.dart';
import 'package:viovid/features/dashboard_management/dtos/payment_dto.dart';
import 'package:viovid/features/result_type.dart';

class PaymentListRepository {
  final PaymentListService paymentListService;

  PaymentListRepository({
    required this.paymentListService,
  });

  Future<Result<List<PaymentDto>>> getPaymentsList(int year) async {
    try {
      return Success(await paymentListService.getPaymentsList(year));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> getMostUsedPaymentType() async {
    try {
      return Success(await paymentListService.getMostUsedPaymentType());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
