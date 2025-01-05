import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viovid/data/dynamic/profile_data.dart';

final vnDateFormat = DateFormat('dd/MM/yyyy');

const primaryColor = Color.fromARGB(255, 229, 9, 21);

const adminPrimaryColor = Color(0xFF695CFE);

TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).colorScheme.error);
}

const secondaryColor = Color.fromARGB(255, 255, 81, 81);

const vibrantColor = Color(0xFFC0000D);

const secondaryColorBg = Color.fromARGB(255, 250, 250, 250);

const secondaryColorSideBorder = Color.fromARGB(255, 241, 241, 241);

const secondaryColorSubtitle = Color(0xFF686868);

const secondaryColorBorder = Color.fromARGB(255, 217, 217, 217);

const secondaryColorTitle = Color.fromARGB(255, 48, 48, 48);

const secondaryColorDisable = Color.fromARGB(255, 178, 178, 178);

const secondaryColorBaseBg = Color.fromARGB(255, 255, 239, 231);

const neutral300 = Color(0xFFBAB8B8);

const neutral100 = Color(0xFFF1F1F1);

const secondary200 = Color(0xFFE7EBEF);

const defaultPadding = 16.0;

bool isNormalUser = profileData['end_date'] == null ||
    (profileData['end_date'] != null &&
        DateTime.tryParse(profileData['end_date']) != null &&
        DateTime.parse(profileData['end_date']).isBefore(DateTime.now()));
