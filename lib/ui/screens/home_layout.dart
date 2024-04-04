import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/provider/bottom_nav_bar_provider.dart';
import 'package:todo/ui/screens/settings_tab.dart';
import 'package:todo/ui/widgets/add_task_bottom_sheet.dart';

class HomeLayout extends StatefulWidget {
  static const String routeName = "HomeLayout";

  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavBarProvider(),
      builder: (context, child) {
        final provider = Provider.of<BottomNavBarProvider>(context);
        final prov = Provider.of<MyAppProvider>(context);
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SettingsTab.routeName);
                  },
                  child: const Icon(Icons.settings),
                ),
              ),
            ],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            toolbarHeight: 60,
            title: provider.tabs[provider.index] == provider.tabs[0]
                ? prov.language == 'en'
                    ? Text(
                        "Unfinished Tasks",
                        style: GoogleFonts.novaSquare(),
                      )
                    : Text(
                        "مهام لم تنتهي",
                        style: GoogleFonts.cairo(),
                      )
                : prov.language == 'en'
                    ? Text(
                        "Finished tasks",
                        style: GoogleFonts.novaSquare(),
                      )
                    : Text(
                        "المهام المنتهية",
                        style: GoogleFonts.cairo(),
                      ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            shape: StadiumBorder(
              side: BorderSide(
                color: Brightness.light == Theme.of(context).brightness
                    ? const Color(0xffffffff)
                    : const Color(0xff141922),
                width: 4,
              ),
            ),
            onPressed: () {
              showAddTaskSheet();
            },
            child: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.zero,
            height: 60.h,
            color: Brightness.light == Theme.of(context).brightness
                ? Colors.white
                : const Color(0xff141922),
            notchMargin: 8,
            shape: const CircularNotchedRectangle(),
            child: BottomNavigationBar(
              currentIndex: provider.index,
              onTap: (value) {
                provider.onTap(value);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "",
                ),
              ],
            ),
          ),
          body: provider.tabs[provider.index],
        );
      },
    );
  }

  void showAddTaskSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddTaskBottomSheet(),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}
