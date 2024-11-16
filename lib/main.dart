import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/core/theme/app_theme.dart';
import 'package:dashboard/features/addFeature/addInHospital.dart';
import 'package:dashboard/features/addFeature/add_info.dart';
import 'package:dashboard/features/addFeature/add_info_er.dart';
import 'package:dashboard/features/addFeature/add_surgery.dart';
import 'package:dashboard/screens/SigninScreen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final backgroundColor = AppTheme.lightTheme.scaffoldBackgroundColor;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: backgroundColor,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: GetMaterialApp(
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
        home: SafeArea(
          child: addInHospital(
            record: {},
            onBack: () {},
            patientData: {},
            fullRecord: {},
          ),
        ),
      ),
    ),
  );
}
