import '../../consts/app_consts.dart';

class CustomHomeButton extends StatelessWidget {
  const CustomHomeButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.height,
    required this.width,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final String icon;
  final double height;
  final double width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          width: 26,
        ),
        10.heightBox,
        title.text
            .fontFamily(AppStyles.semiBold)
            .color(AppColors.darkFontGrey)
            .center
            .make(),
      ],
    ).box.white.rounded.size(width, height).shadowSm.make();
  }
}
