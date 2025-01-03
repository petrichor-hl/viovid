import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';
// import 'package:viovid/base/components/search_field.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Dashboard',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: secondaryColorTitle),
        ),
        const Spacer(),
        // const Expanded(child: SearchField()),
      ],
    );
  }
}
