import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/controllers/seller_orders_controller.dart';
import 'package:ennovation/models/order_model.dart';
import 'package:ennovation/presentation/widgets/custom_button.dart';

import '../../../../consts/app_consts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../services/firestore_services.dart';
import '../../../widgets/custom_details_row.dart';
import '../../../widgets/custom_order_status.dart';

class SellerOrderDetailsView extends StatelessWidget {
  const SellerOrderDetailsView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SellerOrdersController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: "Order Details"
            .tr
            .text
            .color(AppColors.darkFontGrey)
            .fontFamily(AppStyles.semiBold)
            .make(),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirestoreServices.getOrder(id: id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              OrderModel order = OrderModel.fromMap(
                  snapshot.data!.data() as Map<String, dynamic>);
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomOrderStatus(
                            title: "Placed".tr,
                            isDone: order.isPlaced,
                          ),
                          CustomOrderStatus(
                            title: "Confirmed".tr,
                            isDone: order.isConfirmed,
                          ),
                          CustomOrderStatus(
                            title: "On Delivery".tr,
                            isDone: order.isOnDelivery,
                          ),
                          CustomOrderStatus(
                            title: "Delivered".tr,
                            isDone: order.isDelivered,
                          ),
                          Column(
                            children: [
                              CustomDetailsRow(
                                title1: "Order Date".tr,
                                detail1: intl.DateFormat("MMM d hh:mm a")
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        order.time)),
                                title2: "Payment Method".tr,
                                detail2: order.paymentMethod.tr,
                                color1: AppColors.redColor,
                              ),
                              18.heightBox,
                              CustomDetailsRow(
                                title1: "Payment Status".tr,
                                detail1:
                                    order.paymentMethod == "Cash On Delivery" &&
                                            order.isDelivered != true
                                        ? "Unpaid".tr
                                        : "Paid".tr,
                                title2: "Delivery Status".tr,
                                detail2: order.isDelivered
                                    ? "Delivered".tr
                                    : order.isOnDelivery
                                        ? "On Delivery".tr
                                        : order.isConfirmed
                                            ? "Confirmed".tr
                                            : "Placed".tr,
                                color1: AppColors.redColor,
                              ),
                              18.heightBox,
                              CustomDetailsRow(
                                title1: "Product Price".tr,
                                detail1: "${"EGP".tr} ${order.productPrice}",
                                title2: "Shipping Price".tr,
                                detail2: "${"EGP".tr} ${order.shippingPrice}",
                                color1: AppColors.redColor,
                                color2: AppColors.redColor,
                              ),
                              18.heightBox,
                              CustomDetailsRow(
                                title1: "Shipping Address".tr,
                                detail1:
                                    "${order.address.address}\n${order.address.city}\n${order.address.state}\n${order.address.country}\n${order.address.postalCode}\n${order.address.phone}",
                                title2: "Total price".tr,
                                detail2: "${"EGP".tr} ${order.totalPrice}",
                                color2: AppColors.redColor,
                              ),
                            ],
                          )
                              .box
                              .white
                              .roundedSM
                              .shadowSm
                              .margin(const EdgeInsets.all(16))
                              .padding(const EdgeInsets.all(12))
                              .make(),
                          "Ordered Product"
                              .tr
                              .text
                              .size(18)
                              .fontFamily(AppStyles.semiBold)
                              .color(AppColors.darkFontGrey)
                              .make()
                              .box
                              .margin(
                                  const EdgeInsets.symmetric(horizontal: 16))
                              .make(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  order.product.name.text
                                      .size(16)
                                      .fontFamily(AppStyles.semiBold)
                                      .color(AppColors.darkFontGrey)
                                      .make(),
                                  "${order.quantity}x"
                                      .text
                                      .color(AppColors.redColor)
                                      .make(),
                                  VxBox()
                                      .size(30, 15)
                                      .color(Color(order.color))
                                      .make(),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "${"EGP".tr} ${order.productPrice}"
                                      .text
                                      .size(16)
                                      .fontFamily(AppStyles.semiBold)
                                      .color(AppColors.redColor)
                                      .make(),
                                  "Refundable".tr.text.make(),
                                ],
                              ),
                            ],
                          ).box.margin(const EdgeInsets.all(16)).make(),
                        ],
                      ),
                    ),
                  ),
                  order.isDelivered
                      ? const SizedBox.shrink()
                      : Obx(
                          () => controller.isLoading.value
                              ? const Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : CustomButton(
                                  onPressed: () {
                                    controller.changeOrderStatus(
                                      context: context,
                                      id: order.id,
                                      status: !(order.isConfirmed)
                                          ? "isConfirmed"
                                          : !(order.isOnDelivery)
                                              ? "isOnDelivery"
                                              : "isDelivered",
                                    );
                                  },
                                  text: !(order.isConfirmed)
                                      ? "Confirm Order".tr
                                      : !(order.isOnDelivery)
                                          ? "Send Order".tr
                                          : "Deliver Order".tr,
                                )
                                  .box
                                  .margin(const EdgeInsets.symmetric(
                                      horizontal: 16))
                                  .make(),
                        ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
