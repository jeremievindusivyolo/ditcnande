import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nandedic/screens/ctrl/dict_repo.dart';
import 'package:nandedic/screens/ctrl/dictionnary_sync.dart';
import 'package:nandedic/screens/dictionary_screen.dart';
import 'package:provider/provider.dart';
import 'screens/ctrl/getCTRL.dart';
import 'screens/ctrl/api.dart';

//THEME
import 'screens/light_theme.dart';
import 'screens/dark_theme.dart';

//SCREENS
import 'screens/landingPage.dart';
import 'screens/home.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sync  = DictionarySync(API().returnMainApi());
  final repo  = DictionaryRepository(sync);
  try {
    await repo.init();                 // opens DB + first sync
  } catch (e, s) {
    debugPrint('Initial sync failed: $e\n$s');
    // App can still run offline with the existing DB
  }

  runApp(
    ChangeNotifierProvider<DictionaryRepository>.value(
      value: repo,
      child: const MyApp(),
    ),
  );
}

final ctrl = Get.put(ControllerApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NandeDic',
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/dictionnary',
      getPages: [
        //Simple GetPage
        GetPage(name: '/landing', page: () => LandingScreen(title: 'Welcome')),
        GetPage(name: '/home', page: () => HomeScreen(title: 'Home')),
        GetPage(name: '/dictionnary', page: () => DictionaryScreen()),
      ],
    );
  }
}
