import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/skeleton_loading.dart';
import 'package:viovid/main.dart';
import 'package:viovid/models/plan.dart';
import 'package:viovid/screens/plans/components/plan_item.dart';

class RegisterPlan extends StatefulWidget {
  const RegisterPlan({super.key});

  @override
  State<RegisterPlan> createState() => _RegisterPlanState();
}

class _RegisterPlanState extends State<RegisterPlan> {
  late final List<Plan> plans;

  late final _future = _fetchPlans();
  Future<void> _fetchPlans() async {
    await Future.delayed(const Duration(milliseconds: 500));
    plans = Plan.fromList(
      await supabase.from('plan').select().order(
            'order',
            ascending: true,
          ),
    );
    plans.insert(
      0,
      Plan(
        planId: '',
        name: 'Thường',
        price: 0,
        duration: 0,
        timeUnit: '',
        recommended: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SkeletonLoading(
                            height: 350,
                            width: 240,
                          ),
                          Gap(10),
                          SkeletonLoading(
                            height: 350,
                            width: 240,
                          ),
                          Gap(10),
                          SkeletonLoading(
                            height: 350,
                            width: 240,
                          ),
                          Gap(10),
                          SkeletonLoading(
                            height: 350,
                            width: 240,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Có lỗi xảy ra khi truy vấn thông tin Gói',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          }

          return Column(
            children: [
              const Gap(80),
              Image.asset(
                Assets.viovidLogo,
                width: 220,
              ),
              const Gap(30),
              const Text(
                'Các gói dịch vụ và mức giá',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...plans
                                .asMap()
                                .entries
                                .where((entry) => entry.value.name != 'Trial')
                                .map(
                              (entry) {
                                final index = entry.key;
                                final plan = entry.value;
                                return PlanItem(
                                  plan,
                                  lighter: index % 2 == 1,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(160),
              Ink(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                color: const Color(0xF2191C21),
                child: Center(
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      fixedSize: const Size.fromWidth(600),
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text(
                      'Trải Nghiệm Gói Vip 24h',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
