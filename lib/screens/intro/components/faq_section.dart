import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/data/static/faq_data.dart';
import 'package:viovid/screens/intro/components/faq_button.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        children: [
          const Text(
            'Những câu hỏi thường gặp',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(80),
          for (var faq in faqData) FAQButton(faq: faq),
          const Gap(80),
        ],
      ),
    );
  }
}
