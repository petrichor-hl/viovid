import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/base/extension.dart';
import 'package:viovid/features/transaction_management/cubit/transaction_cubit.dart';
import 'package:viovid/features/transaction_management/cubit/transaction_state.dart';
import 'package:viovid/models/plan.dart';
import 'package:viovid/payment/server/ethers.dart';
import 'package:web3dart/web3dart.dart';

class PlanItem extends StatefulWidget {
  final Plan plan;
  final bool lighter;
  final BrowserProvider web3;
  final String receiverAddress;
  final Web3Client web3client;

  const PlanItem({
    Key? key,
    required this.plan,
    required this.lighter,
    required this.web3,
    required this.receiverAddress,
    required this.web3client,
  }) : super(key: key);

  @override
  State<PlanItem> createState() => _PlanItemState();
}

class _PlanItemState extends State<PlanItem> {
  String exchangeTimeUnit(String timeUnit) {
    if (timeUnit == 'month') {
      return 'tháng';
    } else if (timeUnit == 'year') {
      return 'năm';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(widget.web3client),
      child: Container(
        decoration: BoxDecoration(
          color: widget.lighter ? const Color(0xCC191C21) : Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 350,
        constraints: const BoxConstraints(minWidth: 240, maxWidth: 400),
        width: MediaQuery.of(context).size.width * 0.15,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.plan.name,
                    style: TextStyle(
                      fontSize: 28,
                      color: widget.plan.name == 'Thường'
                          ? const Color(0xFF949AA4)
                          : Colors.white,
                    ),
                  ),
                  const Gap(30),
                  widget.plan.name == 'Thường'
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF949AA4),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            child: Text(
                              'Đang sử dụng',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF949AA4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : BlocConsumer<TransactionCubit, TransactionState>(
                          listener: (context, state) {
                            if (state is TransactionSent) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text('Giao dịch đã được gửi'),
                                  content:
                                      Text('Mã giao dịch: ${state.txHash}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (state is TransactionConfirmed) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  title:
                                      const Text('Giao dịch đã được xác nhận'),
                                  content:
                                      Text('Mã giao dịch: ${state.txHash}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        context.go('/sign-in');
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else if (state is TransactionError) {
                              showDialog(
                                context: context,
                                builder: (context) => ErrorDialog(
                                    errorMessage: state.errorMessage),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is TransactionLoading) {
                              return const CircularProgressIndicator();
                            }
                            return ElevatedButton(
                              onPressed: () async {
                                final value = await convertVndToEth(
                                    widget.plan.price.toDouble());

                                // ignore: use_build_context_synchronously
                                context
                                    .read<TransactionCubit>()
                                    .sendTransaction(
                                      widget.web3,
                                      value, // Example value
                                      widget.receiverAddress,
                                    );
                              },
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: primaryColor,
                                fixedSize: const Size(130, 40),
                              ),
                              child: const Text(
                                'Chọn',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                  const Gap(40),
                  Text(
                    widget.plan.name == 'Thường'
                        ? 'Miễn phí'
                        : widget.plan.price.toVnCurrencyFormat(),
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.plan.name == 'Thường'
                          ? const Color(0xFF949AA4)
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    widget.plan.name == 'Thường'
                        ? ''
                        : '${widget.plan.duration} ${exchangeTimeUnit(widget.plan.timeUnit)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.plan.recommended)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: const Offset(0, -16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                        child: Text(
                          'Khuyên dùng',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
