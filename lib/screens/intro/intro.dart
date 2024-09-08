import 'package:flutter/material.dart';
import 'package:viovid/screens/intro/components/faq_section.dart';
import 'package:viovid/screens/intro/components/head_section.dart';
import 'package:viovid/screens/intro/components/middle_section.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadSection(),
            MiddleSection(),
            FAQSection(),
          ],
        ),
      ),
    );
  }
}
