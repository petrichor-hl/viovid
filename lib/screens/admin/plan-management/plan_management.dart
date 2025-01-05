import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/confirm_dialog.dart';
import 'package:viovid/base/components/error_dialog.dart';
import 'package:viovid/features/plan_management/cubit/plan_list_cubit.dart';
import 'package:viovid/features/plan_management/cubit/plan_list_state.dart';
import 'package:viovid/features/plan_management/dtos/plan_dto.dart';
import 'package:viovid/screens/admin/dashboard/components/header.dart';
import 'package:viovid/screens/admin/plan-management/components/add_plan_dialog.dart';
import 'package:viovid/screens/admin/plan-management/components/edit_plan_dialog.dart';

class PlanManagementScreen extends StatefulWidget {
  const PlanManagementScreen({super.key});

  @override
  State<PlanManagementScreen> createState() => _PlanManagementScreenState();
}

class _PlanManagementScreenState extends State<PlanManagementScreen> {
  int _selectedRow = -1;
  // ignore: non_constant_identifier_names
  TextStyle cellTextStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  @override
  void initState() {
    super.initState();
    context.read<PlanListCubit>().getPlanList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanListCubit, PlanListState>(
      listenWhen: (previous, current) => current.errorMessage.isNotEmpty,
      listener: (ctx, state) {
        if (state.errorMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => ErrorDialog(errorMessage: state.errorMessage),
          );
        }
      },
      builder: (ctx, state) {
        if (state.isLoading) {
          return _buildInProgressWidget();
        }
        if (state.plans != null) {
          return _buildPlanManagement(state.plans!);
        }
        if (state.errorMessage.isNotEmpty) {
          return _buildFailureWidget(state.errorMessage);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildInProgressWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Gap(14),
        Text(
          'Đang xử lý ...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(50),
      ],
    );
  }

  Widget _buildFailureWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanManagement(List<PlanDto> plans) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Header(header: "Quản lý gói"),
            const SizedBox(height: 6),
            const Divider(
              color: secondaryColorBorder,
              thickness: 1,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                const Text(
                  'Danh sách các gói',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => BlocProvider.value(
                        value: context.read<PlanListCubit>(),
                        child: AddPlanDialog(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: vibrantColor,
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  iconAlignment: IconAlignment.end,
                  label: const Text(
                    'Thêm gói mới',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const Gap(20),
                FilledButton.icon(
                  onPressed: _selectedRow == -1
                      ? null
                      : () async {
                          await showDialog(
                            context: context,
                            builder: (ctx) => BlocProvider.value(
                              value: context.read<PlanListCubit>(),
                              child: EditPlanDialog(
                                editPlan: plans[_selectedRow],
                                planId: plans[_selectedRow].id!,
                              ),
                            ),
                          );
                          setState(() {
                            _selectedRow = -1;
                            context.read<PlanListCubit>().getPlanList();
                          });
                        },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor:
                        _selectedRow == -1 ? neutral300 : vibrantColor,
                  ),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  iconAlignment: IconAlignment.end,
                  label: const Text(
                    'Chỉnh sửa',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const Gap(20),
                FilledButton.icon(
                  onPressed: _selectedRow == -1
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (ctx) => ConfirmDialog(
                              confirmMessage: 'Bạn có chắc muốn xoá Gói này',
                              onConfirm: () => context
                                  .read<PlanListCubit>()
                                  .deletePlan(plans[_selectedRow].id!),
                            ),
                          );
                          setState(() {
                            _selectedRow = -1;
                          });
                        },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor:
                        _selectedRow == -1 ? neutral300 : vibrantColor,
                  ),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Xoá',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(
              color: neutral100,
              thickness: 1,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        decoration: const BoxDecoration(
                          color: secondary200,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text('STT', style: cellTextStyle),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text('Tên gói', style: cellTextStyle),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text('Giá', style: cellTextStyle),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text('Thời gian hiệu lực',
                                    style: cellTextStyle),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: ListView.separated(
                            itemCount: plans.length,
                            separatorBuilder: (context, index) => const Divider(
                              color: neutral100,
                              thickness: 1,
                            ),
                            itemBuilder: (context, index) {
                              return Ink(
                                color: _selectedRow == index
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1)
                                    : null,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedRow = index;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      const Gap(30),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          (index + 1).toString(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            plans[index].name,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            plans[index].price.toString(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                plans[index]
                                                    .duration
                                                    .toString(),
                                              ),
                                              const Spacer(),
                                              if (_selectedRow == index)
                                                Icon(
                                                  Icons.check,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Gap(30),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
