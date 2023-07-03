import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/controllers/cart_controller.dart';
import 'package:ennovation/models/cart_model.dart';
import 'package:ennovation/models/product_model.dart';

import 'package:ennovation/presentation/views/user/product/shipping_info_view.dart';

import '../../../../consts/app_consts.dart';
import '../../../../services/firestore_services.dart';
import '../../../widgets/custom_button.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartController controller = Get.put(CartController());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: "Shopping cart"
              .tr
              .text
              .color(AppColors.darkFontGrey)
              .fontFamily(AppStyles.semiBold)
              .make(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreServices.getcart(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                  child: "Cart is empty"
                      .tr
                      .text
                      .color(AppColors.darkFontGrey)
                      .make());
            } else {
              List<CartModel> cart = List.from(
                snapshot.data!.docs.map(
                  (e) => CartModel.fromMap(e.data() as Map<String, dynamic>),
                ),
              );
              controller.calculate(cart: cart);
              controller.isPlacingOrder.value == false
                  ? controller.cart = cart
                  : null;
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: cart[index].product.images.first,
                                  width: 80,
                                  fit: BoxFit.fill,
                                ),
                                title:
                                    "${cart[index].product.name}  (x${cart[index].quantity})"
                                        .text
                                        .fontFamily(AppStyles.semiBold)
                                        .size(16)
                                        .make(),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child:
                                          "${"EGP".tr} ${cart[index].productPrice.numCurrency} + ${"EGP".tr} ${cart[index].shippingPrice.numCurrency} ${"for shipping".tr}"
                                              .text
                                              .size(12)
                                              .fontFamily(AppStyles.semiBold)
                                              .color(AppColors.redColor)
                                              .make(),
                                    )
                                        .box
                                        .padding(const EdgeInsets.only(top: 3))
                                        .make(),
                                    3.heightBox,
                                    Row(
                                      children: [
                                        "Color: "
                                            .tr
                                            .text
                                            .fontFamily(AppStyles.semiBold)
                                            .color(AppColors.darkFontGrey)
                                            .make(),
                                        VxBox()
                                            .size(20, 20)
                                            .color(Color(cart[index].color))
                                            .roundedFull
                                            .margin(const EdgeInsets.symmetric(
                                                horizontal: 4))
                                            .make(),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.delete,
                                  color: AppColors.redColor,
                                ).onTap(() {
                                  controller.deletefromcart(id: cart[index].id);
                                }),
                              );
                            }),
                      ),
                      Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            "Total price"
                                .tr
                                .text
                                .color(AppColors.darkFontGrey)
                                .fontFamily(AppStyles.semiBold)
                                .make(),
                            Obx(
                              () => "${controller.totalP.value}"
                                  .numCurrency
                                  .text
                                  .color(AppColors.redColor)
                                  .fontFamily(AppStyles.semiBold)
                                  .make(),
                            ),
                          ])
                          .box
                          .padding(const EdgeInsets.all(12))
                          .color(AppColors.lightGolden)
                          .width(context.screenWidth - 60)
                          .roundedSM
                          .make(),
                      10.heightBox,
                      SizedBox(
                        height: 60,
                        width: context.screenWidth,
                        child: CustomButton(
                          onPressed: () {
                            Get.to(() => const ShippingInfoView());
                          },
                          text: "Proceed to shipping".tr,
                        ),
                      ),
                    ],
                  ));
            }
          },
        ));
  }
}
