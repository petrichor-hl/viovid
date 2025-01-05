import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viovid/data/dynamic/profile_data.dart';

final vnDateFormat = DateFormat('dd/MM/yyyy');

const primaryColor = Color.fromARGB(255, 229, 9, 21);

const adminPrimaryColor = Color(0xFF695CFE);

TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).colorScheme.error);
}

bool isNormalUser = profileData['end_date'] == null ||
    (profileData['end_date'] != null &&
        DateTime.tryParse(profileData['end_date']) != null &&
        DateTime.parse(profileData['end_date']).isBefore(DateTime.now()));
