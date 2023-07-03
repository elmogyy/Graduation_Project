import 'package:ennovation/controllers/auth_controller.dart';
import 'package:ennovation/presentation/widgets/custom_app_logo.dart';
import 'package:ennovation/presentation/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';

import '../../../../consts/app_consts.dart';
import '../../../widgets/custom_background.dart';
import '../../../widgets/custom_privacy_policy_dialog.dart';
import '../../../widgets/custom_terms_and_conditions_dialog.dart';
import '../../../widgets/custom_text_field.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  var controller = Get.put(AuthController());

  final formKey = GlobalKey<FormState>();

  signUp() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      controller.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        context: context,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                const CustomAppLogo(),
                15.heightBox,
                "${"Join the".tr} ${"appName".tr}"
                    .text
                    .white
                    .fontFamily(AppStyles.bold)
                    .size(18)
                    .make(),
                15.heightBox,
                Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            title: "name".tr,
                            hint: "nameHint".tr,
                            controller: nameController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          10.heightBox,
                          CustomTextField(
                            title: "email".tr,
                            hint: "emailHint".tr,
                            controller: emailController,
                          ),
                          10.heightBox,
                          CustomTextField(
                            title: "password".tr,
                            hint: "passwordHint".tr,
                            controller: passwordController,
                            isPassword: true,
                          ),
                          10.heightBox,
                          CustomTextField(
                            title: "rePassword".tr,
                            hint: "passwordHint".tr,
                            controller: rePasswordController,
                            isPassword: true,
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RadioMenuButton<bool>(
                            value: true,
                            groupValue: controller.isUser.value,
                            onChanged: (value) {
                              controller.isUser(true);
                            },
                            child: "User".tr.text.make(),
                          ),
                          RadioMenuButton<bool>(
                            value: false,
                            groupValue: controller.isUser.value,
                            onChanged: (value) {
                              controller.isUser(false);
                            },
                            child: "Seller".tr.text.make(),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.isTermsAgreed.value,
                            onChanged: (value) {
                              controller.isTermsAgreed(value ?? false);
                            },
                          ),
                        ),
                        18.widthBox,
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "I agree to the ".tr,
                                  style: const TextStyle(
                                    fontFamily: AppStyles.regular,
                                    color: AppColors.fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) =>
                                            const CustomTermsAndConditionsDialog(),
                                      );
                                    },
                                  text: "termsAndConditions".tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: AppStyles.semiBold,
                                    color: AppColors.redColor,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: " & ".tr,
                                  style: const TextStyle(
                                    fontFamily: AppStyles.regular,
                                    color: AppColors.fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) =>
                                            const CustomPrivacyPolicyDialog(),
                                      );
                                    },
                                  text: "privacyPolicy".tr,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: AppStyles.semiBold,
                                    color: AppColors.redColor,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              onPressed: controller.isTermsAgreed.value
                                  ? signUp
                                  : null,
                              text: "signUp".tr,
                            ),
                    ),
                    10.heightBox,
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "alreadyHaveAccount".tr,
                            style: const TextStyle(
                              fontFamily: AppStyles.semiBold,
                              color: AppColors.fontGrey,
                            ),
                          ),
                          TextSpan(
                            text: "login".tr,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.off(() => const LoginView());
                              },
                            style: const TextStyle(
                              fontFamily: AppStyles.semiBold,
                              color: AppColors.redColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
