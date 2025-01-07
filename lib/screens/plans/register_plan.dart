import 'package:flutter/services.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:http/http.dart';
// import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/assets.dart';
// import 'package:viovid/base/common_variables.dart';
import 'package:viovid/base/components/skeleton_loading.dart';
import 'package:viovid/main.dart';
import 'package:viovid/models/plan.dart';
import 'package:viovid/payment/server/ethers.dart';
import 'package:viovid/screens/plans/components/plan_item.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/web3dart.dart';

// const _contractAddress = '0x39f13B61cEF5939A30D1ac89E1bF441a62371E7C';
const _receiverAddress = '0x8F3550A693aaDA5005061a84ee8EdA4942822B8d';
const _sepRpcUrl =
    'https://sepolia.infura.io/v3/2682fb5ba7214f63ad1b4b90c9169b38';

class RegisterPlan extends StatefulWidget {
  const RegisterPlan({super.key});

  @override
  State<RegisterPlan> createState() => _RegisterPlanState();
}

class _RegisterPlanState extends State<RegisterPlan> {
  // static const String walletAbi = 'assets/abi/abi_wallet.json';
  late ContractEvent contractEvent;
  late String walletAddress;
  late Web3Client ethClient;
  late Client httpClient;
  // late DeployedContract _contract;
  final int amount = 100;
  int chainId = 1;
  BrowserProvider? web3;

  String transactionStatus = 'Not started';
  String balance = '';

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

  Future<void> initWeb3() async {
    // Initialize the Web3Client (use a provider like Infura or Alchemy)
    if (ethereum != null) {
      httpClient = Client();
      ethClient = Web3Client(_sepRpcUrl, httpClient);
      web3 = BrowserProvider(ethereum!);

      setState(() {
        // Web3 is initialized
      });
    }
  }

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(_sepRpcUrl, httpClient);
    initWeb3();
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
                                  plan: plan,
                                  lighter: index % 2 == 1,
                                  web3: web3!,
                                  receiverAddress: _receiverAddress,
                                  web3client: ethClient,
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
            ],
          );
        },
      ),
    );
  }
}
