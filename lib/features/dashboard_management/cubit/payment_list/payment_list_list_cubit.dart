import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/dashboard_management/cubit/payment_list/payment_list_list_state.dart';
import 'package:viovid/features/dashboard_management/data/payment_list/payment_list_repository.dart';
import 'package:viovid/features/result_type.dart';

class PaymentListCubit extends Cubit<PaymentListState> {
  final PaymentListRepository paymentRepository;

  PaymentListCubit(this.paymentRepository) : super(PaymentListState());

  Future<void> getPaymentsList(int year) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await paymentRepository.getPaymentsList(year);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            payments: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> getMostUsedPaymentType() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await paymentRepository.getMostUsedPaymentType();
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            mostUsedPaymentType: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }
}
