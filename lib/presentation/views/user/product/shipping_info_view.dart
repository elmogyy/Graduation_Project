import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/controllers/product_controller.dart';
import 'package:ennovation/models/address_model.dart';
import 'package:ennovation/presentation/widgets/custom_button.dart';

import '../../../../consts/app_consts.dart';
import '../../../../controllers/cart_controller.dart';
import '../../../../services/firestore_services.dart';
import 'add_address_view.dart';
import 'payment_methods_view.dart';

class ShippingInfoView extends StatefulWidget {
  const ShippingInfoView({Key? key}) : super(key: key);

  @override
  State<ShippingInfoView> createState() => _ShippingInfoViewState();
}

class _ShippingInfoViewState extends State<ShippingInfoView> {
  dynamic controller;
  @override
  void initState() {
    Get.isRegistered<ProductController>()
        ? controller = Get.find<ProductController>()
        : controller = Get.find<CartController>();
    super.initState();
  }

  @override
  void dispose() {
    controller.selectedAddressIndex(-1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .tr
            .text
            .color(AppColors.darkFontGrey)
            .fontFamily(AppStyles.semiBold)
            .make(),
        leading: IconButton(
          onPressed: () {
            controller.selectedAddressIndex(-1);
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            "Select Shipping Address:"
                .tr
                .text
                .size(18)
                .fontFamily(AppStyles.semiBold)
                .color(AppColors.darkFontGrey)
                .start
                .make(),
            10.heightBox,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreServices.getAddresses(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<AddressModel> addresses = List.from(
                        snapshot.data!.docs.map(
                          (e) => AddressModel.fromMap(
                              e.data() as Map<String, dynamic>),
                        ),
                      );
                      // if (addresses.isNotEmpty && controller.selectedAddressIndex.value == -1) controller.selectedAddressIndex(0);
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: addresses.length,
                        separatorBuilder: (context, index) => 10.heightBox,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              controller.selectedAddressIndex(index);
                              controller.addressModel = addresses[index];
                            },
                            child: Obx(
                              () => Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          "Address"
                                              .tr
                                              .text
                                              .color(Colors.grey)
                                              .make()
                                              .box
                                              .width(100)
                                              .make(),
                                          Expanded(
                                              child: addresses[index]
                                                  .address
                                                  .text
                                                  .make()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          "City"
                                              .tr
                                              .text
                                              .color(Colors.grey)
                                              .make()
                                              .box
                                              .width(100)
                                              .make(),
                                          Expanded(
                                              child: addresses[index]
                                                  .city
                                                  .text
                                                  .make()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          "State"
                                              .tr
                                              .text
                                              .color(Colors.grey)
                                              .make()
                                              .box
                                              .width(100)
                                              .make(),
                                          Expanded(
                                              child: addresses[index]
                                                  .state
                                                  .text
                                                  .make()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          "Country"
                                              .tr
                                              .text
                                              .color(Colors.grey)
                                              .make()
                                              .box
                                              .width(100)
                                              .make(),
                                          Expanded(
                                              child: addresses[index]
                                                  .country
                                                  .text
                                                  .make()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          "Postal Code"
                                              .tr
                                              .text
                                              .color(Colors.grey)
                                              .make()
                                              .box
                                              .width(100)
                                              .make(),
                                          Expanded(
                                              child: addresses[index]
                                                  .postalCode
                                                  .text
                                                  .make()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          "Phone"
                                              .tr
                                              .text
                                              .color(Colors.grey)
                                              .make()
                                              .box
                                              .width(100)
                                              .make(),
                                          Expanded(
                                              child: addresses[index]
                                                  .phone
                                                  .text
                                                  .make()),
                                        ],
                                      ),
                                    ],
                                  )
                                      .box
                                      .white
                                      .shadowSm
                                      .roundedSM
                                      .padding(const EdgeInsets.all(12))
                                      .clip(Clip.antiAlias)
                                      .border(
                                        color: controller.selectedAddressIndex
                                                    .value ==
                                                index
                                            ? AppColors.redColor
                                            : Colors.transparent,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      )
                                      .make(),
                                  controller.selectedAddressIndex.value == index
                                      ? const Padding(
                                          padding:
                                              EdgeInsetsDirectional.all(12),
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: AppColors.redColor,
                                            child: Icon(Icons.done,
                                                size: 20, color: Colors.white),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            10.heightBox,
            TextButton(
              onPressed: () {
                Get.to(() => const AddAddressView());
              },
              child: "Add New Address".tr.text.make(),
            ),
            10.heightBox,
            Obx(
              () => CustomButton(
                onPressed: controller.selectedAddressIndex.value < 0
                    ? null
                    : () {
                        Get.to(() => const PaymentMethodsView());
                      },
                text: "Confirm".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
