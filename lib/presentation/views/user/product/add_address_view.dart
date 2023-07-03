import 'package:ennovation/controllers/product_controller.dart';
import 'package:ennovation/presentation/widgets/custom_button.dart';

import '../../../../consts/app_consts.dart';
import '../../../../controllers/cart_controller.dart';
import '../../../widgets/custom_text_field.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({Key? key}) : super(key: key);

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final postalCodeController = TextEditingController();
  final phoneController = TextEditingController();

  dynamic controller;
  @override
  void initState() {
    Get.isRegistered<ProductController>()
        ? controller = Get.find<ProductController>()
        : controller = Get.find<CartController>();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  login() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      controller.saveAddress(
        context: context,
        address: addressController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
        postalCode: postalCodeController.text,
        phone: phoneController.text,
      );
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: "Add New Address"
            .tr
            .text
            .color(AppColors.darkFontGrey)
            .fontFamily(AppStyles.semiBold)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            title: "Address".tr,
                            hint: "Address".tr,
                            controller: addressController,
                          ),
                          CustomTextField(
                            title: "City".tr,
                            hint: "City".tr,
                            controller: cityController,
                          ),
                          CustomTextField(
                            title: "State".tr,
                            hint: "State".tr,
                            controller: stateController,
                          ),
                          CustomTextField(
                            title: "Country".tr,
                            hint: "Country".tr,
                            controller: countryController,
                          ),
                          CustomTextField(
                            title: "Postal Code".tr,
                            hint: "Postal Code".tr,
                            controller: postalCodeController,
                            keyboardType: TextInputType.number,
                          ),
                          CustomTextField(
                            title: "Phone".tr,
                            hint: "Phone".tr,
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => controller.isAddingAddress.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      onPressed: login,
                      text: "Save".tr,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
