import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/app_provider.dart';

String? validatePassword(String? password, BuildContext context) {
  final provider = Provider.of<MyAppProvider>(context, listen: false);
  if (password == null || password.isEmpty) {
    return provider.language == "en" ? "Enter Password" : "أدخل كلمة المرور";
  } else if (password.length < 6) {
    return provider.language == "en"
        ? "Password length shouldn't be less than 6 characters"
        : "يجب ألا يقل طول كلمة المرور عن 6 أحرف";
  }
  final bool passwordValid = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d).{8,}$',
  ).hasMatch(password);
  if (!passwordValid) {
    return provider.language == "en"
        ? "Enter Valid Password"
        : "أدخل كلمة مرور صالحة";
  }
  return null;
}

String? validateEmail(String? email, BuildContext context) {
  final provider = Provider.of<MyAppProvider>(context, listen: false);
  if (email == null || email.isEmpty) {
    return provider.language == "en" ? "Enter Email" : "أدخل البريد الإلكتروني";
  }
  final bool emailValid = RegExp(
    r"^[a-zA-Z\d.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+",
  ).hasMatch(email);
  if (!emailValid) {
    return provider.language == "en"
        ? "Enter Valid Email"
        : "أدخل بريد إلكتروني صالح";
  }
  return null;
}

String? validateGeneral(String? value, String label, BuildContext context) {
  final provider = Provider.of<MyAppProvider>(context, listen: false);
  if (value == null || value.isEmpty) {
    return provider.language == "en" ? "Enter $label" : "أدخل $label";
  }
  return null;
}
