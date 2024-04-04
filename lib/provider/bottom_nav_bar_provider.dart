import 'package:flutter/material.dart';
import 'package:todo/ui/screens/done_tasks.dart';
import 'package:todo/ui/screens/tasks.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int index = 0;
  List<Widget> tabs = [
    const TaskTab(),
    const DoneTasks(),
  ];

  void onTap(int value) {
    index = value;
    notifyListeners();
  }
}
