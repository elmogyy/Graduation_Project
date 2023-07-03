import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/controllers/auth_controller.dart';
import 'package:ennovation/locale/locale_controller.dart';
import 'package:ennovation/models/user_model.dart';
import 'package:ennovation/presentation/views/common/profile/edit_profile_view.dart';
import 'package:ennovation/presentation/views/common/splash/splash_view.dart';
import 'package:ennovation/presentation/widgets/custom_terms_and_conditions_dialog.dart';

import '../../../../consts/app_consts.dart';
import '../../../../services/firestore_services.dart';
import '../../../widgets/custom_background.dart';
import '../../../widgets/custom_privacy_policy_dialog.dart';
import '../../common/chat/chat_view.dart';
import '../orders/orders_view.dart';
import 'wishlist_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyLocaleController controllerlang = Get.find();
    return CustomBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirestoreServices.getUser(
                    uid: AppFirebase.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromMap(snapshot.data!.docs.first
                        .data() as Map<String, dynamic>);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: user.profileUrl,
                          fit: BoxFit.cover,
                        )
                            .box
                            .width(70)
                            .height(70)
                            .color(AppColors.lightGrey)
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
                        10.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user.name.text.white
                                  .fontFamily(AppStyles.semiBold)
                                  .make(),
                              user.email.text.white
                                  .fontFamily(AppStyles.semiBold)
                                  .make(),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(() => EditProfileView(userModel: user));
                          },
                          icon: const Icon(Icons.edit_outlined),
                          color: Colors.white,
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              15.heightBox,
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(() => const OrdersView());
                    },
                    leading: Image.asset(AppImages.icOrders,
                        height: 22, color: AppColors.darkFontGrey),
                    title: "My Orders"
                        .tr
                        .text
                        .color(AppColors.darkFontGrey)
                        .fontFamily(AppStyles.semiBold)
                        .make(),
                  ),
                  const Divider(
                      color: AppColors.lightGrey,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10),
                  ListTile(
                    onTap: () {
                      Get.to(() => const WishlistView());
                    },
                    leading: Image.asset(AppImages.icHeart,
                        height: 22, color: AppColors.darkFontGrey),
                    title: "My Wishlist"
                        .tr
                        .text
                        .color(AppColors.darkFontGrey)
                        .fontFamily(AppStyles.semiBold)
                        .make(),
                  ),
                  const Divider(
                      color: AppColors.lightGrey,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10),
                  ListTile(
                    onTap: () {
                      Get.to(() => const ChatsView());
                    },
                    leading: Image.asset(AppImages.icMessages,
                        height: 22, color: AppColors.darkFontGrey),
                    title: "Chats"
                        .tr
                        .text
                        .color(AppColors.darkFontGrey)
                        .fontFamily(AppStyles.semiBold)
                        .make(),
                  ),
                  const Divider(
                      color: AppColors.lightGrey,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10),
                  ListTile(
                    onTap: () {
                      "currentlanguage".tr == "English"
                          ? controllerlang.changelang("en")
                          : controllerlang.changelang("ar");
                      Get.offAll(() => const SplashView());
                    },
                    leading: Image.asset(AppImages.flag,
                        height: 22, color: AppColors.darkFontGrey),
                    title: "language"
                        .tr
                        .text
                        .color(AppColors.darkFontGrey)
                        .fontFamily(AppStyles.semiBold)
                        .make(),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        "currentlanguage"
                            .tr
                            .text
                            .color(AppColors.darkFontGrey)
                            .fontFamily(AppStyles.semiBold)
                            .make(),
                        const Icon(
                          Icons.navigate_next,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                      color: AppColors.lightGrey,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10),
                  ListTile(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            const CustomTermsAndConditionsDialog(),
                      );
                    },
                    leading: const Icon(Icons.policy_outlined,
                        color: AppColors.darkFontGrey),
                    title: "termsAndConditions"
                        .tr
                        .text
                        .color(AppColors.darkFontGrey)
                        .fontFamily(AppStyles.semiBold)
                        .make(),
                  ),
                  const Divider(
                      color: AppColors.lightGrey,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10),
                  ListTile(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => const CustomPrivacyPolicyDialog(),
                      );
                    },
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: AppColors.darkFontGrey),
                    title: "privacyPolicy"
                        .tr
                        .text
                        .color(AppColors.darkFontGrey)
                        .fontFamily(AppStyles.semiBold)
                        .make(),
                  ),
                  const Divider(
                      color: AppColors.lightGrey,
                      thickness: 1.5,
                      indent: 10,
                      endIndent: 10),
                  ListTile(
                    onTap: () {
                      Get.put(AuthController()).logout(context: context);
                    },
                    leading: const Icon(Icons.logout_outlined,
                        color: AppColors.darkFontGrey),
                    title: "Logout"
                        .tr
                        .text
                        .color(AppColors.darkFontGrey)
                        .fontFamily(AppStyles.semiBold)
                        .make(),
                  ),
                ],
              )
                  .box
                  .white
                  .rounded
                  .shadow
                  .padding(const EdgeInsets.all(10))
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
