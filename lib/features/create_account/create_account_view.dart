import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/base.dart';
import 'package:todo/features/create_account/create_account_connector.dart';
import 'package:todo/features/create_account/create_account_view_model.dart';
import 'package:todo/features/login/login_view.dart';
import 'package:todo/helper_methods.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/styles/app_colors.dart';
import 'package:todo/ui/screens/home_layout.dart';
import 'package:todo/ui/widgets/custom_calender.dart';

class CreateAccountView extends StatefulWidget {
  static const String routName = "CreatAccount";

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState
    extends BaseView<CreateAccountViewModel, CreateAccountView>
    implements CreateAccountConnector {
  @override
  void initState() {
    super.initState();
    viewModel.connector = this;
  }

  final _formKey = GlobalKey<FormState>();

  bool obscureTextCheck = true;

  final passwordController = TextEditingController();

  final emailController = TextEditingController();

  final userNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final ageController = TextEditingController();
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyAppProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      builder: (context, child) => Scaffold(
        body: Stack(
          children: [
            if (provider.themeMode == ThemeMode.light)
              Image.asset(
                "assets/images/login_screen.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Image.asset(
                "assets/images/splash_dark_bg.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      InkWell(
                        onTap: () {
                          provider.themeMode == ThemeMode.dark
                              ? provider.changeTheme(ThemeMode.light)
                              : provider.changeTheme(ThemeMode.dark);
                        },
                        child: Text(
                          provider.language == "en"
                              ? "Create New Account"
                              : "إنشاء حساب جديد",
                          style: provider.language == "en"
                              ? GoogleFonts.novaSquare(
                                  fontSize: 30.sp,
                                  color: provider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                )
                              : GoogleFonts.cairo(
                                  fontSize: 30.sp,
                                  color: provider.themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                      SizedBox(height: 60.h),
                      TextFormField(
                        validator: (value) => validateGeneral(
                          value,
                          provider.language == 'en'
                              ? 'User Name'
                              : 'إسم المستخدم',
                          context,
                        ),
                        controller: userNameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.lightBlueColor),
                          ),
                          label: Text(
                            provider.language == "en"
                                ? "User Name"
                                : "إسم المستخدم",
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    color: AppColors.lightBlueColor,
                                  )
                                : GoogleFonts.cairo(
                                    color: AppColors.lightBlueColor,
                                  ),
                          ),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      TextFormField(
                        validator: (email) => validateEmail(email, context),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.lightBlueColor),
                          ),
                          label: Text(
                            provider.language == "en"
                                ? "Email"
                                : "البريد الإلكتروني",
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    color: AppColors.lightBlueColor,
                                  )
                                : GoogleFonts.cairo(
                                    color: AppColors.lightBlueColor,
                                  ),
                          ),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.email,
                          ),
                          suffix: const Icon(
                            Icons.alternate_email,
                            color: AppColors.lightBlueColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      TextFormField(
                        validator: (password) =>
                            validatePassword(password, context),
                        obscureText: obscureTextCheck,
                        controller: passwordController,
                        decoration: InputDecoration(
                          label: Text(
                            provider.language == "en"
                                ? "Password"
                                : "كلمة المرور",
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    color: AppColors.lightBlueColor,
                                  )
                                : GoogleFonts.cairo(
                                    color: AppColors.lightBlueColor,
                                  ),
                          ),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.lightBlueColor),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                obscureTextCheck = !obscureTextCheck;
                              });
                            },
                            child: obscureTextCheck
                                ? const Icon(
                                    Icons.visibility,
                                    color: AppColors.lightBlueColor,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: AppColors.lightBlueColor,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {},
                        child: CustomCalender(
                          labelText: "Date of birth",
                          textInputType: TextInputType.datetime,
                          icon: Icons.calendar_month_outlined,
                          controller: dateOfBirthController,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        validator: (age) {
                          if (age!.isEmpty) {
                            return provider.language == "en"
                                ? "Enter Your Age"
                                : "أدخل عمرك";
                          }
                          return null;
                        },
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.lightBlueColor),
                          ),
                          label: Text(
                            provider.language == "en" ? "Age" : "العمر",
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    color: AppColors.lightBlueColor,
                                  )
                                : GoogleFonts.cairo(
                                    color: AppColors.lightBlueColor,
                                  ),
                          ),
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.calendar_month,
                          ),
                          suffix: const Icon(
                            Icons.date_range,
                            color: AppColors.lightBlueColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        width: 230.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: MaterialButton(
                          minWidth: 1.w,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              viewModel.createAccount(
                                emailController.text,
                                passwordController.text,
                                userNameController.text,
                                int.parse(ageController.text),
                              );
                            }
                          },
                          child: Text(
                            provider.language == "en"
                                ? 'Create Account'
                                : "إنشاء حساب",
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    color: Colors.white,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w300,
                                  )
                                : GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.language == "en"
                                ? "Already have an account?"
                                : "بالفعل لديك حساب؟",
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    fontWeight: FontWeight.w600,
                                  )
                                : GoogleFonts.cairo(
                                    fontWeight: FontWeight.w600,
                                  ),
                          ),
                          MaterialButton(
                            minWidth: 1.w,
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                LoginView.routName,
                              );
                            },
                            child: Text(
                              provider.language == "en"
                                  ? 'LOG IN'
                                  : "تسجيل دخول",
                              style: provider.language == "en"
                                  ? GoogleFonts.novaSquare(
                                      color: Colors.purpleAccent,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : GoogleFonts.cairo(
                                      color: Colors.purpleAccent,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> chooseDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (selectedDate != null) {
      selectedDate = DateUtils.dateOnly(selectedDate);
    }
    setState(() {});
  }

  @override
  CreateAccountViewModel initViewModel() {
    return CreateAccountViewModel();
  }

  @override
  void goToHome() {
    Navigator.pushReplacementNamed(context, HomeLayout.routeName);
  }
}
