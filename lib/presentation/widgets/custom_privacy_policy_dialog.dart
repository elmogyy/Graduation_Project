import 'package:ennovation/presentation/widgets/custom_button.dart';

import '../../consts/app_consts.dart';

class CustomPrivacyPolicyDialog extends StatelessWidget {
  const CustomPrivacyPolicyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            "privacyPolicy"
                .tr
                .text
                .fontFamily(AppStyles.bold)
                .size(18)
                .color(AppColors.darkFontGrey)
                .make(),
            10.heightBox,
            "Content of the Privacy Policy"
                .tr
                .text
                .size(16)
                .color(AppColors.darkFontGrey)
                .make(),
            10.heightBox,
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Ok".tr,
              ).box.width(80).make(),
            ),
          ],
        ).box.padding(const EdgeInsets.all(16)).rounded.make(),
      ),
    );
  }
}
