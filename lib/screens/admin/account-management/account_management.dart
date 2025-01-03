import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid/features/account_manament/cubit/account_list_cubit.dart';
import 'package:viovid/features/account_manament/cubit/account_list_state.dart';
import 'package:viovid/features/account_manament/dtos/account_dto.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AccountListCubit>().getAccountList();
  }

  void handleSearch() async {
    context
        .read<AccountListCubit>()
        .getAccountList(searchText: _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountListCubit, AccountListState>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        if (state.isLoading) {
          return _buildInProgressWidget();
        }
        if (state.accounts != null) {
          return _buildAccountManagement(state.accounts!);
        }
        if (state.errorMessage != null) {
          return _buildFailureWidget(state.errorMessage!);
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountManagement(List<AccountDto> accounts) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm ...',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    border: MaterialStateOutlineInputBorder.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.focused)) {
                          return const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Color(0xFF695CFE), width: 2),
                          );
                        } else if (states.contains(WidgetState.hovered)) {
                          return OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                                color: const Color(0xFF695CFE).withOpacity(0.3),
                                width: 1),
                          );
                        }
                        return const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(color: Colors.black),
                        );
                      },
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                  onEditingComplete: handleSearch,
                ),
              ),
              const Gap(8),
              IconButton(
                onPressed: handleSearch,
                style: IconButton.styleFrom(
                  fixedSize: const Size(80, 48),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF695CFE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.search_rounded,
                  size: 28,
                ),
              )
            ],
          ),
          const Gap(20),
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF695CFE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Gap(20),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'AVATAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'EMAIL',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'TÊN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'XÁC NHẬN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Gap(20),
                  Gap(60),
                  Gap(20),
                ],
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: ListView.separated(
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Gap(20),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: accounts[index].avatar,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        flex: 3,
                        child: Text(accounts[index].email),
                      ),
                      const Gap(20),
                      Expanded(
                        flex: 2,
                        child: Text(accounts[index].name),
                      ),
                      const Gap(20),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: accounts[index].emailConfirmed
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.remove_rounded,
                                  color: Colors.red,
                                ),
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        width: 60,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              context.read<AccountListCubit>().deleteAccount(
                                    accounts[index].applicationUserId,
                                  );
                            },
                            style: ButtonStyle(
                              iconColor: WidgetStateColor.resolveWith(
                                (state) {
                                  if (state.contains(WidgetState.hovered)) {
                                    return Colors.red;
                                  }
                                  return Colors.black45;
                                },
                              ),
                            ),
                            icon: const Icon(
                              Icons.delete_rounded,
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                );
              },
              separatorBuilder: (ctx, index) => Divider(
                color: const Color(0xFF695CFE).withOpacity(0.3),
              ),
              itemCount: accounts.length,
            ),
          )
        ],
      ),
    );
  }
}
