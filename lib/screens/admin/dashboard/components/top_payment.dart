import 'package:flutter/material.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/service/service.dart';

class TopPaymentType extends StatelessWidget {
  const TopPaymentType({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Phương thức thanh toán phổ biến nhất năm nay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: secondaryColorTitle,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: FutureBuilder(
            future: getMostUsedPaymentType(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading data'));
              } else {
                String imagePath;
                switch (snapshot.data!.toLowerCase()) {
                  case 'momo':
                    imagePath = Assets.momoBadge;
                    break;
                  case 'vnpay':
                    imagePath = Assets.vnPayBadge;
                    break;
                  case 'stripe':
                    imagePath = Assets.stripeBadge;
                    break;
                  case 'wallet':
                    imagePath = Assets.metaMaskBadge;
                    break;
                  default:
                    imagePath = Assets.momoBadge;
                    break;
                }
                return Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                );
              }
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    ));
  }
}
