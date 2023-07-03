import '../../../consts/app_consts.dart';
import '../../widgets/custom_exit_dialog.dart';
import 'cart/cart_view.dart';
import 'categories/categories_view.dart';
import 'home/home_view.dart';
import 'profile/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var bodyItems = [
      const HomeView(),
      const CategoriesView(),
      const CartView(),
      const ProfileView(),
    ];

    var navItems = [
      BottomNavigationBarItem(
        icon: Image.asset(
          AppImages.icHome,
          width: 26,
          color: currentIndex == 0 ? AppColors.redColor : Colors.grey,
        ),
        label: "Home".tr,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          AppImages.icCategories,
          width: 26,
          color: currentIndex == 1 ? AppColors.redColor : Colors.grey,
        ),
        label: "Categories".tr,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          AppImages.icCart,
          width: 26,
          color: currentIndex == 2 ? AppColors.redColor : Colors.grey,
        ),
        label: "Cart".tr,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          AppImages.icProfile,
          width: 26,
          color: currentIndex == 3 ? AppColors.redColor : Colors.grey,
        ),
        label: "Profile".tr,
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const CustomExitDialog(),
        );
        return false;
      },
      child: Scaffold(
        body: bodyItems[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: navItems,
          selectedItemColor: AppColors.redColor,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
