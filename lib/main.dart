import 'package:flutter/material.dart';

import 'package:geul_gil/pages/app_bar_screens/account_screen.dart';
import 'package:geul_gil/pages/app_bar_screens/notification_screen.dart';
import 'package:geul_gil/pages/app_bar_screens/settings_screen.dart';
import 'package:geul_gil/pages/main_screen/tabs_screen.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

// TODO: 수업 사진과 단어장 연결 -> 단어가 어떤 수업에서 쓰였는지 리다이렉트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(
        GraphQLClient(
          link: HttpLink("http://localhost:4000"),
          cache: GraphQLCache(),
        ),
      ),
      child: MaterialApp(
        title: '글길',
        theme: ThemeData(
          fontFamily: "Sanfrancisco",
          brightness: Brightness.light,
          useMaterial3: true,
          textButtonTheme: TextButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 100, 115, 230),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.25,
            ),
            color: Color.fromARGB(255, 100, 115, 230),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 100, 115, 230),
            background: Colors.white,
          ),
        ),
        routes: {
          "/": (_) => const TabsScreen(),
          NotificationScreen.routeName: (_) => const NotificationScreen(),
          AccountScreen.routeName: (_) => const AccountScreen(),
          SettingsScreen.routeName: (_) => const SettingsScreen(),
        },
      ),
    );
  }
}
