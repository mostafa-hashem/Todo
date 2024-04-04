import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/shared/network/firebase/firebase_functions.dart';
import 'package:todo/styles/app_colors.dart';

class EditTask extends StatefulWidget {
  static const String routeName = "EditTask";

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late TaskModel taskDetails;

  @override
  Widget build(BuildContext context) {
    taskDetails = ModalRoute.of(context)!.settings.arguments! as TaskModel;
    getDetails();
    final provider = Provider.of<MyAppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To Do App",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                if (provider.language == "en")
                  Text(
                    AppLocalizations.of(context)!.editTask,
                    style: Brightness.light == Theme.of(context).brightness
                        ? const TextStyle(color: Colors.black)
                        : const TextStyle(color: Colors.white),
                  )
                else
                  Text(
                    AppLocalizations.of(context)!.editTask,
                    style: Brightness.light == Theme.of(context).brightness
                        ? GoogleFonts.cairo(color: Colors.black)
                        : GoogleFonts.cairo(color: Colors.white),
                  ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  validator: (taskTitle) {
                    if (taskTitle == null || taskTitle.isEmpty) {
                      return provider.language == "en"
                          ? "Please Enter Task Title"
                          : "يرجى إدخال إسم المهمة";
                    }
                    return null;
                  },
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: provider.language == "en"
                        ? Text("Task Title", style: GoogleFonts.novaSquare())
                        : Text("إسم المهمة", style: GoogleFonts.cairo()),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.lightBlueColor),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.lightBlueColor),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  validator: (taskDescription) {
                    if (taskDescription == null || taskDescription.isEmpty) {
                      return provider.language == "en"
                          ? "Please Enter Task Description"
                          : "يرجى إدخال محتوى المهمة";
                    }
                    return null;
                  },
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    label: provider.language == "en"
                        ? Text(
                            "Task Description",
                            style: GoogleFonts.novaSquare(),
                          )
                        : Text(
                            "محتوى المهمة",
                            style: GoogleFonts.cairo(),
                          ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.lightBlueColor),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.lightBlueColor),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    AppLocalizations.of(context)!.selectDate,
                    style: provider.language == "en"
                        ? TextStyle(
                            color:
                                Brightness.light == Theme.of(context).brightness
                                    ? Colors.black
                                    : Colors.white,
                          )
                        : GoogleFonts.cairo(
                            color: provider.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () {
                    chooseDate();
                  },
                  child: Text(
                    DateTime.fromMillisecondsSinceEpoch(taskDetails.date)
                        .toString()
                        .substring(0, 10),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    AppLocalizations.of(context)!.selectTime,
                    style: provider.language == "en"
                        ? TextStyle(
                            color:
                                Brightness.light == Theme.of(context).brightness
                                    ? Colors.black
                                    : Colors.white,
                          )
                        : GoogleFonts.cairo(
                            color: provider.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () {
                    chooseTime();
                  },
                  child: Text(
                    TimeOfDay.fromDateTime(
                      DateTime.fromMicrosecondsSinceEpoch(taskDetails.time),
                    ).toString().substring(10, 15),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(150.w, 40.h)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final TaskModel task = TaskModel(
                        id: taskDetails.id,
                        userID: taskDetails.userID,
                        title: titleController.text,
                        description: descriptionController.text,
                        date: taskDetails.date,
                        time: taskDetails.time,
                        status: taskDetails.status,
                      );
                      FirebaseFunctions.updateTask(taskDetails.id, task)
                          .whenComplete(() => Navigator.pop(context));
                    }
                  },
                  child: provider.language == "en"
                      ? Text(
                          "Edit",
                          style: GoogleFonts.novaSquare(),
                        )
                      : Text(
                          "تعديل",
                          style: GoogleFonts.cairo(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> chooseDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(taskDetails.date),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (selectedDate != null) {
      taskDetails.date =
          DateUtils.dateOnly(selectedDate).millisecondsSinceEpoch;
    }
    setState(() {});
  }

  Future<void> chooseTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.fromMicrosecondsSinceEpoch(
          taskDetails.time,
        ),
      ),
    );
    if (selectedTime != null) {
      final DateTime currentDate =
          DateTime.fromMillisecondsSinceEpoch(taskDetails.date);

      final DateTime newDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      taskDetails.time = newDateTime.microsecondsSinceEpoch;
    }
    setState(() {});
  }

  void getDetails() {
    titleController.text = taskDetails.title;
    descriptionController.text = taskDetails.description;
  }
}
