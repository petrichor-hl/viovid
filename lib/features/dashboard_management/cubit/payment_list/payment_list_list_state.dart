import 'package:viovid/features/dashboard_management/dtos/payment_dto.dart';

class PaymentListState {
  final bool isLoading;
  final List<PaymentDto>? payments;
  final String? mostUsedPaymentType;
  final String errorMessage;

  PaymentListState({
    this.isLoading = false,
    this.payments,
    this.mostUsedPaymentType,
    this.errorMessage = "",
  });

  PaymentListState copyWith({
    bool? isLoading,
    List<PaymentDto>? payments,
    String? mostUsedPaymentType,
    String? errorMessage,
  }) {
    return PaymentListState(
      isLoading: isLoading ?? this.isLoading,
      payments: payments ?? this.payments,
      mostUsedPaymentType: mostUsedPaymentType ?? this.mostUsedPaymentType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
