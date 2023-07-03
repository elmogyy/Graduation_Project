// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/consts/app_consts.dart';
import 'package:ennovation/models/address_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../presentation/views/user/orders/orders_view.dart';

class CartController extends GetxController {
  var totalP = 0.0.obs;
  calculate({required List<CartModel> cart}) {
    totalP.value = 0.0;
    for (var i = 0; i < cart.length; i++) {
      totalP.value = totalP.value + double.parse(cart[i].totalPrice.toString());
    }
  }

  deletefromcart({required String id}) {
    return FirebaseFirestore.instance
        .collection(AppFirebase.cartCollection)
        .doc(id)
        .delete();
  }

  late AddressModel addressModel;

  var isAddingAddress = false.obs;

  saveAddress({
    required String address,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    required String phone,
    required BuildContext context,
  }) async {
    isAddingAddress(true);
    if (await InternetConnectionChecker().hasConnection) {
      final ref = AppFirebase.firestore
          .collection(AppFirebase.usersCollection)
          .doc(AppFirebase.currentUser!.uid)
          .collection(AppFirebase.addressesCollection)
          .doc();
      addressModel = AddressModel(
        id: ref.id,
        address: address,
        city: city,
        state: state,
        country: country,
        postalCode: postalCode,
        phone: phone,
      );

      await ref.set(addressModel.toMap()).then((value) {
        Get.back();
      });
    } else {
      VxToast.show(context, msg: "No Internet Connection");
    }
    isAddingAddress(false);
  }

  var selectedAddressIndex = (-1).obs;

  var selectedPaymentIndex = 0.obs;

  late List<CartModel> cart;

  var isPlacingOrder = false.obs;

  placeMyOrder({required BuildContext context}) async {
    isPlacingOrder(true);
    for (var i = 0; i < cart.length; i++) {
      if (await InternetConnectionChecker().hasConnection) {
        final ref = AppFirebase.firestore
            .collection(AppFirebase.ordersCollection)
            .doc();
        OrderModel orderModel = OrderModel(
          id: ref.id,
          product: cart[i].product,
          quantity: cart[i].quantity,
          productPrice: cart[i].productPrice,
          shippingPrice: cart[i].shippingPrice,
          totalPrice: cart[i].totalPrice,
          color: cart[i].color,
          time: DateTime.now().millisecondsSinceEpoch,
          userId: AppFirebase.currentUser!.uid,
          userName: AppFirebase.currentUser!.displayName ?? "",
          sellerId: cart[i].sellerId,
          paymentMethod: AppLists.paymentTitles[selectedPaymentIndex.value],
          isPlaced: true,
          isConfirmed: false,
          isOnDelivery: false,
          isDelivered: false,
          address: addressModel,
        );
        await ref.set(orderModel.toMap());
        await AppFirebase.firestore
            .collection(AppFirebase.productsCollection)
            .doc(cart[i].product.id)
            .update(
                {"quantity": FieldValue.increment((cart[i].quantity * -1))});
        await deletefromcart(id: cart[i].id);
      } else {
        VxToast.show(context, msg: "No Internet Connection");
      }
    }
    isPlacingOrder(false);
    Get.back();
    Get.back();
    Get.back();
    Get.back();
    Get.to(() => const OrdersView());
  }
}
