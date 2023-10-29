import 'dart:io';

import 'package:coffeeya_admin/product/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'core/config/constant.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

main() async {
  HttpOverrides.global = MyHttpOverrides();

  var path = Directory.current.path;
  Hive.init(path);
  await Hive.openBox(Constants.userBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'کافیا ادمین',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "IRANSansX",
      ),
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const ProductScreen(),
    );
  }
}
