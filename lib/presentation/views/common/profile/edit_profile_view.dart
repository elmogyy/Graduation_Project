import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ennovation/controllers/profile_controller.dart';
import 'package:ennovation/presentation/widgets/custom_button.dart';

import '../../../../consts/app_consts.dart';
import '../../../../models/user_model.dart';
import '../../../widgets/custom_background.dart';
import '../../../widgets/custom_text_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final nameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final controller = Get.put(ProfileController());
  final formKey = GlobalKey<FormState>();

  updateProfile() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      controller.updateProfile(
        name: nameController.text,
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        context: context,
      );
    }
  }

  @override
  void initState() {
    nameController.text = widget.userModel.name;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: "Edit Profile"
              .tr
              .text
              .white
              .fontFamily(AppStyles.semiBold)
              .make(),
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Obx(
                  () => Stack(
                    children: [
                      (controller.profileImagePath.isEmpty
                              ? CachedNetworkImage(
                                  imageUrl: widget.userModel.profileUrl,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(controller.profileImagePath.value),
                                  fit: BoxFit.cover,
                                ))
                          .box
                          .width(120)
                          .height(120)
                          .color(AppColors.lightGrey)
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make(),
                      PositionedDirectional(
                        bottom: 0,
                        end: 10,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.redColor,
                          child: IconButton(
                            onPressed: () {
                              controller.pickProfileImage();
                            },
                            icon: const Icon(Icons.edit),
                            padding: EdgeInsets.zero,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                10.heightBox,
                Form(
                  key: formKey,
                  child: CustomTextField(
                    title: "name".tr,
                    hint: "nameHint".tr,
                    controller: nameController,
                  ),
                ),
                CustomTextField(
                  title: "Old Password".tr,
                  hint: "passwordHint".tr,
                  controller: oldPasswordController,
                  isPassword: true,
                ),
                CustomTextField(
                  title: "New Password".tr,
                  hint: "passwordHint".tr,
                  controller: newPasswordController,
                  isPassword: true,
                ),
                20.heightBox,
                Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          onPressed: updateProfile,
                          text: "Save".tr,
                        ),
                ),
              ],
            )
                .box
                .white
                .roundedSM
                .shadowSm
                .margin(const EdgeInsets.only(bottom: 50, right: 16, left: 16))
                .padding(const EdgeInsets.all(16))
                .makeCentered(),
          ),
        ),
      ),
    );
  }
}
