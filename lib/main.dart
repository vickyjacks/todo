import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:todo_app/views/home_screen.dart';
import 'package:todo_app/provider/task_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TasksProvider()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
      ],
      child:  Consumer<ThemeNotifier>(
        builder: (context, provider, child) {
          print("++++++++++++27 :: ${provider.getTheme()}");
          return MaterialApp(
            theme: provider.getTheme(),
            // theme: ThemeData(
            //     appBarTheme: const AppBarTheme(
            //         backgroundColor: Colors.white,
            //         elevation: 0,
            //         scrolledUnderElevation: 0,
            //         titleTextStyle: TextStyle(
            //             fontFamily: 'Outfit',
            //             fontSize: 20,
            //             color: Colors.black,
            //             fontWeight: FontWeight.w500
            //         )),
            //     fontFamily: "Outfit",
            //     colorScheme: ColorScheme.fromSeed(
            //         seedColor: themeBlue
            //     ),
            //     useMaterial3: true),
            home:   TaskScreen(),
          );

        }
      ),
    );
  }
}
