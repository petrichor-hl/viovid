import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/features/plan_management/cubit/plan_list_cubit.dart';
import 'package:viovid/features/plan_management/dtos/plan_dto.dart';

class EditPlanDialog extends StatefulWidget {
  const EditPlanDialog({
    super.key,
    required this.editPlan,
    required this.planId,
  });
  final PlanDto editPlan;
  final String planId;

  @override
  State<EditPlanDialog> createState() => _EditPlanDialogState();
}

class _EditPlanDialogState extends State<EditPlanDialog> {
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
    locale: 'vi',
    decimalDigits: 0,
  );
  bool _isProcessing = false;

  final Color _baseColor = const Color.fromARGB(255, 237, 161, 69);

  final Color _lightBase = const Color(0xFFFEF8F2);

  final Color _secondBase = const Color(0xFFFDFDFD);

  final Color _secondBorder = const Color(0xFFF1F1F1);

  late final TextEditingController _nameController =
      TextEditingController(text: widget.editPlan.name);

  late final TextEditingController _priceController = TextEditingController(
      text: _formatter
          .formatEditUpdate(TextEditingValue.empty,
              TextEditingValue(text: widget.editPlan.price.toString()))
          .text);

  late final TextEditingController _durationController =
      TextEditingController(text: widget.editPlan.duration.toString());

  int parsePrice(String price) {
    String cleanedPrice = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(cleanedPrice);
  }

  void handleEditplan(BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });
    if (_nameController.text.isEmpty) {
      return;
    }
    if (_priceController.text.isEmpty) {
      return;
    }
    if (_durationController.text.isEmpty) {
      return;
    }
    widget.editPlan.name = _nameController.text;
    widget.editPlan.price = parsePrice(_priceController.text);
    widget.editPlan.duration = int.parse(_durationController.text);

    try {
      await context
          .read<PlanListCubit>()
          .editPlan(widget.editPlan, widget.planId);
      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.editPlan.name;
    _priceController.text = _formatter
        .formatEditUpdate(TextEditingValue.empty,
            TextEditingValue(text: widget.editPlan.price.toString()))
        .text;
    _durationController.text = widget.editPlan.duration.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: _isProcessing
          ? const SizedBox(
              height: 400,
              width: 400,
              child: Padding(
                padding: EdgeInsets.all(150),
                child: CircularProgressIndicator(
                  color: vibrantColor,
                ),
              ),
            )
          : SizedBox(
              width: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Chỉnh sửa gói',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _lightBase,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _baseColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              height: 40,
                              child: Image.asset(
                                Assets.planIcon,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Thanh toán một lần',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              'Thu phí người dùng một lần để truy cập nội dung.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _secondBase,
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(color: _secondBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Row(
                              children: [
                                Text(
                                  "Tên gói",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " *",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Nhập tên gói',
                                hintStyle:
                                    const TextStyle(color: Color(0xFF888888)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                errorMaxLines: 2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            "Giá gói",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            " *",
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _priceController,
                                        decoration: InputDecoration(
                                          hintText: 'VD: 30.000',
                                          hintStyle: const TextStyle(
                                              color: Color(0xFF888888)),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(14),
                                          errorMaxLines: 2,
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Bạn chưa nhập giá gói';
                                          }
                                          return null;
                                        },
                                        inputFormatters: [_formatter],
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            "Thời gian hiệu lực (ngày)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            " *",
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _durationController,
                                        decoration: InputDecoration(
                                          hintText: '30',
                                          suffixText: 'Ngày',
                                          hintStyle: const TextStyle(
                                              color: Color(0xFF888888)),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(14),
                                          errorMaxLines: 2,
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              int.parse(value) <= 0) {
                                            return 'Thời gian hiệu lực không hop lệ';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: vibrantColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          onPressed: () => handleEditplan(context),
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
