import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/dto/dto_plan.dart';
import 'package:viovid/screens/admin/dashboard/components/header.dart';
import 'package:viovid/screens/admin/plan-management/components/add_edit_subscription_dialog.dart';
import 'package:viovid/service/service.dart';

class PlanManagementScreen extends StatefulWidget {
  const PlanManagementScreen({super.key});

  @override
  State<PlanManagementScreen> createState() => _PlanManagementScreenState();
}

class _PlanManagementScreenState extends State<PlanManagementScreen> {
  int _selectedRow = -1;
  // ignore: non_constant_identifier_names
  late List<DtoPlan> _UserRows;
  TextStyle cellTextStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  late final Future<void> _futureRecentUsers = _getRecentUsers();
  Future<void> _getRecentUsers() async {
    await Future.delayed(kTabScrollDuration);
    _UserRows = await fetchPlans();
  }

  Future<void> _logicAddStaff() async {
    DtoPlan? newUser = await showDialog(
      context: context,
      builder: (ctx) => const AddEditSubscriptionDialog(),
    );

    if (newUser != null) {
      setState(() {
        _UserRows.add(newUser);
      });
    }
  }

  Future<void> _logicEditStaff() async {
    String? message = await showDialog(
      context: context,
      builder: (ctx) => AddEditSubscriptionDialog(
        editPlan: _UserRows[_selectedRow],
      ),
    );

    // print(message);
    if (message == "updated") {
      setState(() {});
    }
  }

  Future<void> _logicDeleteStaff(BuildContext ctx) async {
    var deleteUserName = _UserRows[_selectedRow].name;

    /* Xóa dòng dữ liệu*/
    await deletePlan(_UserRows[_selectedRow].id!);

    // print('totalPage = $totalPages');

    _UserRows.removeAt(_selectedRow);
    _selectedRow = -1;
    setState(() {});

    if (mounted) {
      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).clearSnackBars();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Xoá gói $deleteUserName.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _logicAddStaff,
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
                  onPressed: _selectedRow == -1 ? null : _logicEditStaff,
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
                      : () async {
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text('Xác nhận'),
                              content: Text(
                                  'Bạn muốn xoá gói ${_UserRows[_selectedRow].name}?'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('Huỷ'),
                                ),
                                FilledButton(
                                  onPressed: () => _logicDeleteStaff(ctx),
                                  child: const Text('Đồng ý'),
                                ),
                              ],
                            ),
                          );

                          if (_selectedRow >= _UserRows.length) {
                            _selectedRow = -1;
                          }
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
                child: FutureBuilder(
                  future: _futureRecentUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30,
                            ),
                            decoration: const BoxDecoration(
                              color: secondary200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
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
                                    child:
                                        Text('Tên gói', style: cellTextStyle),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: ListView.separated(
                                itemCount: _UserRows.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
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
                                      onLongPress: () async {
                                        setState(() {
                                          _selectedRow = index;
                                        });
                                        _logicEditStaff();
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _UserRows[index].name,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _UserRows[index]
                                                    .price
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _UserRows[index]
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
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
