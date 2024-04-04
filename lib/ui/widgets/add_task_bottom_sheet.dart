import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/shared/network/firebase/firebase_functions.dart';
import 'package:todo/styles/app_colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime selectedDateG = DateUtils.dateOnly(DateTime.now());
  TimeOfDay selectedTimeG = TimeOfDay.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppProvider>(context);
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                Text(
                  provider.language == "en"
                      ? "Add new Task"
                      : "إضافة مهمة جديدة",
                  style: Brightness.light == Theme.of(context).brightness
                      ? provider.language == "en"
                          ? GoogleFonts.novaSquare(color: Colors.black)
                          : GoogleFonts.cairo(color: Colors.black)
                      : provider.language == "en"
                          ? GoogleFonts.novaSquare(color: Colors.white)
                          : GoogleFonts.cairo(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
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
                        ? Text(
                            "Task Title",
                            style: GoogleFonts.novaSquare(),
                          )
                        : Text(
                            "إسم المهمة",
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: AppColors.lightBlueColor),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    AppLocalizations.of(context)!.selectDate,
                    style: provider.language == "en"
                        ? GoogleFonts.novaSquare(
                            color:
                                Brightness.light == Theme.of(context).brightness
                                    ? Colors.black
                                    : Colors.white,
                          )
                        : GoogleFonts.cairo(
                            color:
                                Brightness.light == Theme.of(context).brightness
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
                    selectedDateG.toString().substring(0, 10),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: provider.language == "en"
                      ? Text(
                          AppLocalizations.of(context)!.selectTime,
                          style: GoogleFonts.novaSquare(
                            color:
                                Brightness.light == Theme.of(context).brightness
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        )
                      : Text(
                          AppLocalizations.of(context)!.selectTime,
                          style: GoogleFonts.cairo(
                            color:
                                Brightness.light == Theme.of(context).brightness
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
                    selectedTimeG.toString().substring(10, 15),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final TaskModel task = TaskModel(
                        userID: FirebaseAuth.instance.currentUser!.uid,
                        title: titleController.text,
                        description: descriptionController.text,
                        date: selectedDateG.millisecondsSinceEpoch,
                        time: DateTime.now().microsecondsSinceEpoch,
                        status: false,
                      );
                      FirebaseFunctions.addTaskToFireStore(task);
                      Navigator.pop(context);
                    }
                  },
                  child: provider.language == "en"
                      ? Text(
                          AppLocalizations.of(context)!.addTask,
                          style: GoogleFonts.novaSquare(),
                        )
                      : Text(
                          AppLocalizations.of(context)!.addTask,
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (selectedDate != null) {
      selectedDateG = DateUtils.dateOnly(selectedDate);
    }
    setState(() {});
  }

  Future<void> chooseTime() async {
    final TimeOfDay? selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime != null) {
      selectedTimeG = selectedTime;
    }
    setState(() {});
  }
}
