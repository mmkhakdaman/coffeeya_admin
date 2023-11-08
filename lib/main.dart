import 'dart:io';

import 'package:coffeeya_admin/auth/screens/auth_screen.dart';
import 'package:coffeeya_admin/core/config/token.dart';
import 'package:coffeeya_admin/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/config/constant.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/auth',
      name: "auth",
      builder: (context, state) => const AuthScreen(),
      redirect: (context, state) {
        if (Token.isLoggedIn()) {
          return '/';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/',
      name: "home",
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) {
        if (!Token.isLoggedIn()) {
          return '/auth';
        }
        return null;
      },
    ),
  ],
);

main() async {
  HttpOverrides.global = MyHttpOverrides();

  // if (Platform.isAndroid) {
  await Hive.initFlutter();
  // } else {
  // var path = Directory.current.path;
  // Hive.init(path);
  // }

  await Hive.openBox(Constants.userBox);
  await Hive.openBox(Constants.configBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Global.context = context;
    return MaterialApp.router(
      title: 'کافیا ادمین',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "IRANSansX",
        colorScheme: ColorScheme.light(
          background: Colors.grey[100]!,
          surfaceTint: Colors.grey[100]!,
        ),
        primaryColor: Colors.grey[900],
        focusColor: Colors.grey[200],
        hintColor: Colors.grey[900],
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
            gapPadding: 10,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red[300]!,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.red[300]!,
            ),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.grey,
          selectionColor: Colors.grey,
          selectionHandleColor: Colors.grey,
        ),
      ),
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'),
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      routerConfig: _router,
    );
  }
}
