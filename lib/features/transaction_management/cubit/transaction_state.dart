import 'package:flutter_web3_provider/ethereum.dart';

class TransactionState {
  final String currentAddress;
  final int currentChain;
  final BigInt? balance;
  final bool transactionSent;
  final String errorMessage;
  final bool isLoading;

  TransactionState({
    this.currentAddress = '',
    this.currentChain = -1,
    this.balance,
    this.transactionSent = false,
    this.errorMessage = "",
    this.isLoading = false,
  });

  bool get isEnabled => ethereum != null;

  bool get isConnected => currentAddress.isNotEmpty;

  TransactionState copyWith({
    String? currentAddress,
    int? currentChain,
    BigInt? balance,
    bool? transactionSent,
    String? errorMessage,
    bool? isLoading,
  }) {
    return TransactionState(
      currentAddress: currentAddress ?? this.currentAddress,
      currentChain: currentChain ?? this.currentChain,
      balance: balance ?? this.balance,
      transactionSent: transactionSent ?? this.transactionSent,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSent extends TransactionState {
  final String txHash;

  TransactionSent(this.txHash);
}

class TransactionConfirmed extends TransactionState {
  final String txHash;

  TransactionConfirmed(this.txHash);
}

class TransactionError extends TransactionState {
  final String error;

  TransactionError(this.error);
}
