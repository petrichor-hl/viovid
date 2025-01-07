import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/transaction_management/cubit/transaction_state.dart';
import 'package:js/js_util.dart';
import 'package:web3dart/web3dart.dart' as web3dart;
import 'package:flutter_web3/flutter_web3.dart';
import 'package:viovid/payment/server/ethers.dart';

// const _receiverAddress = '0x8F3550A693aaDA5005061a84ee8EdA4942822B8d';

class TransactionCubit extends Cubit<TransactionState> {
  final web3dart.Web3Client _client;

  TransactionCubit(this._client) : super(TransactionState());

  void init() {
    // Initialize listener

    if (state.isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        // Account change
        clear();
      });
      ethereum!.onChainChanged((chainId) {
        // Chain change
        emit(state.copyWith(currentChain: chainId));
      });
    }
  }

  void clear() {
    emit(TransactionState(
      currentAddress: '',
      currentChain: -1,
      balance: null,
      transactionSent: false,
    ));
  }

  Future<void> sendTransaction(
      BrowserProvider web3, String value, String receiverAddress) async {
    try {
      emit(TransactionLoading());

      var signer = await promiseToFuture(web3.getSigner());
      var txResponse = await promiseToFuture(signer.sendTransaction(TxParams(
        to: receiverAddress,
        value: value,
      )));

      emit(TransactionSent(txResponse.hash));

      // Optionally, you can wait for the transaction to be confirmed
      web3dart.TransactionReceipt? receipt;
      while (receipt == null) {
        emit(TransactionLoading());
        receipt = await _client.getTransactionReceipt(txResponse.hash);
        await Future.delayed(const Duration(seconds: 1));
      }
      emit(TransactionConfirmed(txResponse.hash));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
