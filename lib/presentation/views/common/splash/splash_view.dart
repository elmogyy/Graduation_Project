import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/services/firestore_services.dart';
import 'package:ennovation/presentation/widgets/custom_app_logo.dart';
import 'package:ennovation/presentation/views/user/main_view.dart';
import 'package:ennovation/presentation/views/seller/seller_main_view.dart';

import '../../../../consts/app_consts.dart';
import '../auth/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  goNext() {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        if (AppFirebase.currentUser == null) {
          Get.off(() => const LoginView());
        } else {
          final DocumentSnapshot<Map<String, dynamic>> data =
              await FirestoreServices.getUserRole(
                  id: AppFirebase.currentUser!.uid);
          if (data.data()!["isUser"].toString() == "true") {
            Get.offAll(() => const MainView());
          } else {
            Get.offAll(() => const SellerMainView());
          }
        }
      },
    );
  }

  @override
  void initState() {
    goNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.redColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            const CustomAppLogo(),
            10.heightBox,
            "appName".tr.text.white.fontFamily(AppStyles.bold).size(22).make(),
            5.heightBox,
            "appVersion".tr.text.white.make(),
            const Spacer(),
            "credits".tr.text.white.fontFamily(AppStyles.semiBold).make(),
            30.heightBox,
          ],
        ),
      ),
    );
  }
}
