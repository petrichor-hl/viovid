import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final vnDateFormat = DateFormat('dd/MM/yyyy');

const primaryColor = Color.fromARGB(255, 229, 9, 21);

TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).colorScheme.error);
}
