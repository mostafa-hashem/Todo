import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/base.dart';
import 'package:todo/features/create_account/create_account_view.dart';
import 'package:todo/features/login/connector.dart';
import 'package:todo/features/login/login_viewmodel.dart';
import 'package:todo/helper_methods.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/styles/app_colors.dart';
import 'package:todo/ui/screens/forget_password_screen.dart';
import 'package:todo/ui/screens/home_layout.dart';

class LoginView extends StatefulWidget {
  static const String routName = "LoginScreen";

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseView<LoginViewModel, LoginView>
    implements LoginConnector {
  final formKey = GlobalKey<FormState>();
  bool obscureTextCheck = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.connector = this;
  }

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
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15.r),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60.h,
                        ),
                        InkWell(
                          onTap: () {
                            provider.themeMode == ThemeMode.dark
                                ? provider.changeTheme(ThemeMode.light)
                                : provider.changeTheme(ThemeMode.dark);
                          },
                          child: Text(
                            provider.language == "en" ? 'HI' : 'أهلًا',
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    color: const Color.fromARGB(
                                      255,
                                      137,
                                      161,
                                      238,
                                    ),
                                    fontSize: 50.sp,
                                    letterSpacing: 11.w,
                                  )
                                : GoogleFonts.cairo(
                                    color: const Color.fromARGB(
                                      255,
                                      137,
                                      161,
                                      238,
                                    ),
                                    fontSize: 50.sp,
                                  ),
                          ),
                        ),
                        Text(
                          provider.language == "en"
                              ? "Welcome Back"
                              : 'مرحبًا بعودتك',
                          style: provider.language == "en"
                              ? GoogleFonts.novaSquare(
                                  color: const Color.fromARGB(
                                    255,
                                    137,
                                    161,
                                    238,
                                  ),
                                  fontSize: 45.sp,
                                )
                              : GoogleFonts.cairo(
                                  color: const Color.fromARGB(
                                    255,
                                    137,
                                    161,
                                    238,
                                  ),
                                  fontSize: 50.sp,
                                ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        TextFormField(
                          validator: (email) {
                            if (email!.isEmpty) {
                              return provider.language == "en"
                                  ? "Enter Email"
                                  : "أدخل البريد الإلكتروني";
                            }
                            return null;
                          },
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
                        SizedBox(
                          height: 35.h,
                        ),
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
                              borderSide: BorderSide(
                                color: AppColors.lightBlueColor,
                              ),
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
                        SizedBox(
                          height: 40.h,
                        ),
                        InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              viewModel
                                  .login(
                                    emailController.text,
                                    passwordController.text,
                                  )
                                  .whenComplete(() => provider.initUser());
                            }
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              gradient: const LinearGradient(
                                colors: [Colors.purple, Colors.blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                provider.language == "en"
                                    ? "LOGIN"
                                    : "تسجيل الدخول",
                                style: provider.language == "en"
                                    ? GoogleFonts.novaSquare(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.w,
                                      )
                                    : GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          minWidth: 1.w,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ForgotPassword.routName,
                            );
                          },
                          child: Text(
                            provider.language == "en"
                                ? 'Forgot Password ?'
                                : "نسيت كلمة السر ؟",
                            style: provider.language == "en"
                                ? GoogleFonts.novaSquare(
                                    color: Colors.indigo,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w900,
                                  )
                                : GoogleFonts.cairo(
                                    color: Colors.indigo,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 45.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.language == "en"
                                  ? "Don't have an account?"
                                  : "ليس لديك حساب؟",
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
                                  CreateAccountView.routName,
                                );
                              },
                              child: Text(
                                provider.language == "en"
                                    ? 'SIGN UP'
                                    : "تسجيل حساب جديد",
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void goToHome() {
    Navigator.pushReplacementNamed(context, HomeLayout.routeName);
  }

  @override
  LoginViewModel initViewModel() {
    return LoginViewModel();
  }
}
