import 'package:ennovation/models/order_model.dart';

import '../../../../consts/app_consts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../widgets/custom_details_row.dart';
import '../../../widgets/custom_order_status.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({Key? key, required this.order}) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                      .format(DateTime.fromMillisecondsSinceEpoch(order.time)),
                  title2: "Payment Method".tr,
                  detail2: order.paymentMethod.tr,
                  color1: AppColors.redColor,
                ),
                18.heightBox,
                CustomDetailsRow(
                  title1: "Payment Status".tr,
                  detail1: order.paymentMethod == "Cash On Delivery"
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
                    "${order.quantity}x".text.color(AppColors.redColor).make(),
                    VxBox().size(30, 15).color(Color(order.color)).make(),
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
    );
  }
}
