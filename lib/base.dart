import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class BaseConnector {
  void showLoading(String message);

  void showMessage(String message);

  void hideDialog();
}

class BaseViewModel<CON extends BaseConnector> extends ChangeNotifier {
  CON? connector;
}

abstract class BaseView<VM extends BaseViewModel, T extends StatefulWidget>
    extends State<T> implements BaseConnector {
  late VM viewModel;

  VM initViewModel();

  @override
  void initState() {
    super.initState();
    viewModel = initViewModel();
  }

  @override
  void hideDialog() {
    Navigator.pop(context);
  }

  @override
  void showLoading(String message) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Center(
                  child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 12),
                  Text(message),
                ],
              ),),
            ),);
  }

  @override
  void showMessage(String message) {
    hideDialog();
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Center(
                  child: Text(
                "Error",
                style: GoogleFonts.ubuntu(),
              ),),
              content: Text(
                message,
                style: GoogleFonts.ubuntu(),
              ),
            ),);
  }
}
