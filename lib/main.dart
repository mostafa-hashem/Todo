import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/features/create_account/create_account_view.dart';
import 'package:todo/features/login/login_view.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/provider/app_provider.dart';
import 'package:todo/styles/my_theme.dart';
import 'package:todo/ui/screens/edit_task.dart';
import 'package:todo/ui/screens/forget_password_screen.dart';
import 'package:todo/ui/screens/home_layout.dart';
import 'package:todo/ui/screens/settings_tab.dart';
import 'package:todo/ui/screens/tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => MyAppProvider(),
      child: TodoApp(),
    ),
  );
}

class TodoApp extends StatefulWidget {
  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late MyAppProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MyAppProvider>(context);
    getPreferences();
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: provider.firebaseUser != null
              ? HomeLayout.routeName
              : LoginView.routName,
          routes: {
            LoginView.routName: (c) => LoginView(),
            CreateAccountView.routName: (c) => CreateAccountView(),
            HomeLayout.routeName: (c) => const HomeLayout(),
            TaskTab.routeName: (c) => const TaskTab(),
            SettingsTab.routeName: (c) => SettingsTab(),
            EditTask.routeName: (c) => EditTask(),
            ForgotPassword.routName: (c) => ForgotPassword(),
          },
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: provider.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(provider.language),
        );
      },
    );
  }

  Future<void> getPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? language = prefs.getString('language');
    provider.changeLanguage(language!);
    if (prefs.getString('theme') == 'dark') {
      provider.changeTheme(ThemeMode.dark);
    } else if (prefs.getString('theme') == 'system') {
      provider.changeTheme(ThemeMode.system);
    } else {
      provider.changeTheme(ThemeMode.light);
    }
  }
}
