import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/shared/network/firebase/firebase_functions.dart';
import 'package:todo/styles/app_colors.dart';
import 'package:todo/ui/screens/edit_task.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;

  const TaskItem(this.task);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                FirebaseFunctions.deleteTask(task.id);
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
        ),
        endActionPane: task.status == false
            ? ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.4,
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      Navigator.pushNamed(
                        context,
                        EditTask.routeName,
                        arguments: task,
                      );
                    },
                    backgroundColor: AppColors.lightBlueColor,
                    icon: Icons.edit,
                    label: 'Edit',
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ],
              )
            : null,
        child: Card(
          elevation: 10,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            borderSide: const BorderSide(color: AppColors.lightBlueColor),
          ),
          child: Row(
            children: [
              if (task.status)
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 18.h,
                    horizontal: 18.w,
                  ),
                  height: 90.h,
                  width: 6.w,
                  decoration:
                      const BoxDecoration(color: AppColors.lightGreenColor),
                )
              else
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 18.h,
                    horizontal: 18.w,
                  ),
                  height: 90.h,
                  width: 6.w,
                  decoration:
                      const BoxDecoration(color: AppColors.lightBlueColor),
                ),
              SizedBox(
                width: 16.w,
              ),
              Column(
                children: [
                  if (task.status)
                    Text(
                      task.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: AppColors.lightGreenColor),
                    )
                  else
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  if (task.status)
                    Text(
                      task.description,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: AppColors.lightGreenColor)
                          : Theme.of(context).textTheme.bodySmall,
                    )
                  else
                    Text(
                      task.description,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.black)
                          : Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              const Spacer(),
              if (task.status)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: provider.language == 'en'
                      ? Text(
                          "Done!",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: AppColors.lightGreenColor),
                        )
                      : Text(
                          "تمت!",
                          style: GoogleFonts.cairo(
                            color: AppColors.lightGreenColor,
                            fontSize: 24.sp,
                          ),
                        ),
                )
              else
                InkWell(
                  onTap: () {
                    task.status = true;
                    FirebaseFunctions.updateTask(task.id, task);
                  },
                  child: Container(
                    margin: provider.language == 'en'
                        ? EdgeInsets.only(right: 16.w)
                        : EdgeInsets.only(left: 16.w),
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlueColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: const Icon(Icons.done, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
