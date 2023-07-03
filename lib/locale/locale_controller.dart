import 'package:ennovation/consts/app_consts.dart';
import 'package:ennovation/main.dart';

class MyLocaleController extends GetxController {
  Locale intialLang = shareprf!.getString("lang") == null
      ? Get.deviceLocale!
      : Locale(shareprf!.getString("lang")!);
  void changelang(String codelang) {
    Locale locale = Locale(codelang);
    shareprf!.setString("lang", codelang);
    Get.updateLocale(locale);
  }
}
