import 'package:ennovation/models/product_model.dart';

class CartModel {
  final String id;
  final ProductModel product;
  final int quantity;
  final num productPrice;
  final num shippingPrice;
  final num totalPrice;
  final int color;
  final String userId;
  final String userName;
  final String sellerId;

  CartModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.productPrice,
    required this.shippingPrice,
    required this.totalPrice,
    required this.color,
    required this.userId,
    required this.userName,
    required this.sellerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
      'productPrice': productPrice,
      'shippingPrice': shippingPrice,
      'totalPrice': totalPrice,
      'color': color,
      'userId': userId,
      'userName': userName,
      'sellerId': sellerId,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as String,
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'] as int,
      productPrice: map['productPrice'] as num,
      shippingPrice: map['shippingPrice'] as num,
      totalPrice: map['totalPrice'] as num,
      color: map['color'] as int,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      sellerId: map['sellerId'] as String,
    );
  }
}
