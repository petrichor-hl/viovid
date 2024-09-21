import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/extension.dart';
import 'package:viovid/models/plan.dart';

class PlanItem extends StatelessWidget {
  const PlanItem(
    this.plan, {
    super.key,
    this.lighter = false,
  });

  final Plan plan;
  final bool lighter;

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
    return Container(
      decoration: BoxDecoration(
        color: lighter ? const Color(0xCC191C21) : Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      // padding: const EdgeInsets.symmetric(vertical: 60),
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
                  plan.name,
                  style: TextStyle(
                    fontSize: 28,
                    color: plan.name == 'Thường'
                        ? const Color(0xFF949AA4)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(30),
                plan.name == 'Thường'
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
                    : FilledButton(
                        onPressed: () {},
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
                      ),
                const Gap(40),
                Text(
                  plan.name == 'Thường'
                      ? 'Miễn phí'
                      : plan.price.toVnCurrencyFormat(),
                  style: TextStyle(
                    fontSize: 18,
                    color: plan.name == 'Thường'
                        ? const Color(0xFF949AA4)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                Text(
                  plan.name == 'Thường'
                      ? ''
                      : '${plan.duration} ${exchangeTimeUnit(plan.timeUnit)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (plan.recommended)
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
    );
  }
}
