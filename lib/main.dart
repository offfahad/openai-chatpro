import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:open_ai_chatgpt/authentication/landing_screen.dart';
import 'package:open_ai_chatgpt/authentication/registration_screen.dart';
import 'package:open_ai_chatgpt/authentication/user_information_screen.dart';
import 'package:open_ai_chatgpt/constants/constants.dart';
import 'package:open_ai_chatgpt/main_screens/home_screen.dart';
import 'package:open_ai_chatgpt/providers/authentication_provider.dart';
import 'package:open_ai_chatgpt/providers/chat_provider.dart';
import 'package:open_ai_chatgpt/providers/my_theme_provider.dart';
import 'package:open_ai_chatgpt/themes/my_theme.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MyThemeProvider()),
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider())
    ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  void getCurrentTheme() async {
    await Provider.of<MyThemeProvider>(context, listen: false).getThemeStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<MyThemeProvider>(
      builder: (BuildContext context, value, Widget? child){
        return MaterialApp(
          title: 'OpenAI ChatPro',
          debugShowCheckedModeBanner: false,
          theme: MyTheme.themeData(isDarkTheme: value.themeType, context: context),
          initialRoute: Constants.landingScreen,
          routes: {
            Constants.landingScreen: (context) => const LandingScreen(),
            Constants.registrationScreen: (context) => const RegistrationScreen(),
            Constants.homeScreen: (context) => const HomeScreen(),
            Constants.userInformationScreen: (context) => const UserInformationScreen(),
          },
        );
      },
    );
  }
}

