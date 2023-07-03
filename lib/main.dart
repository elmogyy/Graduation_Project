import 'package:ennovation/locale/locale.dart';
import 'package:ennovation/locale/locale_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consts/app_consts.dart';
import 'presentation/views/common/splash/splash_view.dart';

SharedPreferences? shareprf;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  shareprf = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyLocaleController controller = Get.put(MyLocaleController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      locale: controller.intialLang,
      translations: MyLocale(),
      theme: ThemeData(
        primaryColor: AppColors.redColor,
        colorScheme: const ColorScheme.light(
          primary: AppColors.redColor,
          secondary: AppColors.redColor,
          onBackground: AppColors.redColor,
          inversePrimary: AppColors.redColor,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: AppColors.darkFontGrey,
          ),
        ),
        fontFamily: AppStyles.regular,
      ),
      home: const SplashView(),
    );
  }
}
