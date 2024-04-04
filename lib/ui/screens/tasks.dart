import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/shared/network/firebase/firebase_functions.dart';
import 'package:todo/ui/widgets/task_item.dart';

class TaskTab extends StatefulWidget {
  static const String routeName = "TaskTab";

  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppProvider>(context);
    return Column(
      children: [
        CalendarTimeline(
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
          onDateSelected: (newDate) {
            setState(() {
              date = newDate;
            });
          },
          leftMargin: 20,
          monthColor: Colors.blueGrey,
          dayColor: Colors.teal[200],
          activeDayColor: Colors.white,
          activeBackgroundDayColor: Colors.redAccent[100],
          dotsColor: const Color(0xFF333A47),
          locale: 'en_ISO',
        ),
        SizedBox(
          height: 15.h,
        ),
        StreamBuilder(
          stream: FirebaseFunctions.getTasksFromFireStore(date),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    if (provider.language == "en")
                      Text(
                        "Something went wrong",
                        style: GoogleFonts.novaSquare(),
                      )
                    else
                      Text("عذرً, حدث خطأ", style: GoogleFonts.cairo()),
                    ElevatedButton(
                      onPressed: () {},
                      child: provider.language == "en"
                          ? Text(
                              "Try again",
                              style: GoogleFonts.novaSquare(),
                            )
                          : Text("حاول مجددًا", style: GoogleFonts.cairo()),
                    ),
                  ],
                ),
              );
            }
            final List<TaskModel> tasks = snapshot.data?.docs
                    .map((doc) => doc.data())
                    .where((task) => !task.status)
                    .toList() ??
                [];
            if (tasks.isEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  if (provider.language == "en")
                    Text(
                      "No Tasks Yet",
                      style: GoogleFonts.novaSquare(fontSize: 30.sp),
                    )
                  else
                    Text(
                      "لا يوجد مهام بعد",
                      style: GoogleFonts.cairo(fontSize: 30.sp),
                    ),
                  const Icon(Icons.list, size: 70),
                ],
              );
            }
            return Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return TaskItem(tasks[index]);
                },
                itemCount: tasks.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 8.h,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
