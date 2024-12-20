// ignore_for_file: unused_import

import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/views/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/product_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyAVpYB2c5TXjx-1DyHpUfvalbA-Ti2KSJo',
    appId: '1:499382768324:android:f27f6996daaab076f1ef91',
    messagingSenderId: '499382768324',
    projectId: 'emart-93110',
    storageBucket: 'emart-93110.firebasestorage.app',
  ));
  //Get.lazyPut(() => ProductController());
  Get.put(ProductController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //we are using getx so have to change this material app into getmaterial app

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
          fontFamily: regular,
          iconTheme: IconThemeData(
            color: darkFontGrey,
          )),
      home: const SplashScreen(),
    );
  }
}
