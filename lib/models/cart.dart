import 'package:flutter_cart/flutter_cart.dart';

class CartModel {
  var cart = FlutterCart();

  addToCart(dynamic _product) => cart.addToCart(
      productId: _product.dishId,
      unitPrice: _product.dishPrice,
      quantity: 1,
      productDetailsObject: _product);

  addItemToCart(int index) => cart.incrementItemToCart(index);

  getTotalPrice() => cart.getTotalAmount();

  removeItemFromCart(int index) => cart.decrementItemFromCart(index);

  getSize() => cart.getCartItemCount();

  get(int index) => cart.findItemIndexFromCart(index);
}
