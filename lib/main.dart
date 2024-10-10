import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:get/get.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set the status bar color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blue, // Change this to your desired color
    statusBarIconBrightness:
        Brightness.light, // Use dark icons on light background
  ));

  runApp(
    GetMaterialApp(
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
      ],
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      title: 'Navigation Basics',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SafeArea(
        child: LoginScreen(),
      ),
    ),
  );
}
