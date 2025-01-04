import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/dto/dto_plan.dart';
import 'package:viovid/service/service.dart';

class AddEditSubscriptionDialog extends StatefulWidget {
  const AddEditSubscriptionDialog({super.key, this.editPlan});

  final DtoPlan? editPlan;

  @override
  State<AddEditSubscriptionDialog> createState() =>
      _AddEditSubscriptionDialogState();
}

class _AddEditSubscriptionDialogState extends State<AddEditSubscriptionDialog> {
  final Color _baseColor = const Color.fromARGB(255, 237, 161, 69);
  final Color _lightBase = const Color(0xFFFEF8F2);
  final Color _secondBase = const Color(0xFFFDFDFD);
  final Color _secondBorder = const Color(0xFFF1F1F1);

  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
    locale: 'vi',
    decimalDigits: 0,
  );

  void savePlan(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      if (widget.editPlan == null) {
        DtoPlan newPlan = DtoPlan(
          name: _nameController.text,
          price: parsePrice(_priceController.text),
          duration: int.parse(_durationController.text),
        );

        String returningId = await createPlan(newPlan);
        newPlan.id = returningId;

        if (mounted) {
          Navigator.of(context).pop(newPlan);
        }
      } else {
        widget.editPlan!.name = _nameController.text;
        widget.editPlan!.price = parsePrice(_priceController.text);
        widget.editPlan!.duration = int.parse(_durationController.text);

        await editPlan(widget.editPlan!);

        if (mounted) {
          Navigator.of(context).pop('updated');
        }
      }

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.editPlan == null
                ? 'Thêm gói thành công.'
                : 'Cập gói plan thành công.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            width: 300,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editPlan != null) {
      _nameController.text = widget.editPlan!.name;
      _priceController.text = _formatter
          .formatEditUpdate(TextEditingValue.empty,
              TextEditingValue(text: widget.editPlan!.price.toString()))
          .text;
      _durationController.text = widget.editPlan!.duration.toString();
    } else {
      _nameController.text = '';
      _priceController.text = '';
      _durationController.text = '';
    }
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
      child: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
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
                      Text(
                        widget.editPlan == null
                            ? 'Tạo gói mới'
                            : 'Chỉnh sửa gói',
                        style: const TextStyle(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.all(14),
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.all(14),
                                      errorMaxLines: 2,
                                    ),
                                    keyboardType: TextInputType.number,
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
                  child: _isProcessing
                      ? const SizedBox(
                          height: 44,
                          width: 44,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: vibrantColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            onPressed: () => savePlan(context),
                            child: Text(
                              widget.editPlan == null
                                  ? 'Tạo gói mới'
                                  : 'Chỉnh sửa gói',
                              style: const TextStyle(
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
      ),
    );
  }

  int parsePrice(String price) {
    String cleanedPrice = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(cleanedPrice);
  }
}
