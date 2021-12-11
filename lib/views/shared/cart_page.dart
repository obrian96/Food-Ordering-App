import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/cart.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/services/order_services.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/widgets/msg_toast.dart';
import 'package:velocity_x/velocity_x.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Color(0xff403b58),
        title: "Cart".text.make(),
      ),
      body: CartBody(),
    );
  }
}

class CartBody extends StatefulWidget {
  @override
  _CartBodyState createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CartList().p32().expand(),
        Divider(),
        _CartTotal(),
      ],
    );
  }
}

class _CartList extends StatefulWidget {
  // final Function update;
  // const _CartList({Key key, this.update}) : super(key: key);

  @override
  __CartListState createState() => __CartListState();
}

class __CartListState extends State<_CartList> {
  final CartModel _cart = CartModel();

  @override
  Widget build(BuildContext context) {
    return (_cart.cart == null)
        ? "Nothing to show".text.xl3.make().centered()
        : ListView.builder(
            itemCount: _cart.cart.cartItem.length,
            itemBuilder: (context, index) => ListTile(
              leading: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  _cart.cart.decrementItemFromCart(index);
                  setState(() {
                    //totalprice = _cart.cart.getTotalAmount();
                  });
                  //widget.update();
                  msgToast(
                      '${_cart.cart.cartItem[index].productDetails.dishName} removed from the cart');
                },
              ),
              trailing:
                  '${_cart.cart.cartItem[index].quantity} * \K${_cart.cart.cartItem[index].unitPrice}'
                      .text
                      .lg
                      .color(Color(0xff403b58))
                      .make(),
              title: '${_cart.cart.cartItem[index].productDetails.dishName}'
                  .text
                  .color(Color(0xff403b58))
                  .make(),
            ),
          );
  }
}

class _CartTotal extends StatefulWidget {
  // final totalprice;
  //
  // const _CartTotal({Key key, this.totalprice}) : super(key: key);

  @override
  __CartTotalState createState() => __CartTotalState();
}

class __CartTotalState extends State<_CartTotal> {
  final CartModel _cart = CartModel();

  var totalPrice = 0.0;

  static const String TAG = 'cart_page.dart';

  @override
  void initState() {
    super.initState();
    setState(() {
      totalPrice = _cart.cart.getTotalAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          "\K${totalPrice}".text.xl5.color(Color(0xff403b58)).make(),
          30.widthBox,
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                30.widthBox,
                // ElevatedButton(
                //   onPressed: () {
                //     // Scaffold.of(context).showSnackBar(SnackBar(content: "Buying not supported yet".text.make()));
                //     msgToast('Price Updated');
                //     setState(() {
                //       totalPrice = _cart.cart.getTotalAmount();
                //     });
                //   },
                //   style: ButtonStyle(
                //       backgroundColor:
                //           MaterialStateProperty.all(Color(0xff403b58))),
                //   child: "Update Price".text.white.make(),
                // ).w32(context),
                // 100.widthBox,
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Scaffold.of(context).showSnackBar(SnackBar(
                    //     content: "Buying not supported yet".text.make()));
                    buyItems(context);
                    setState(() {
                      totalPrice = _cart.cart.getTotalAmount();
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff403b58))),
                  child: "Buy".text.white.make(),
                ).w32(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void buyItems(context) async {
    List<CartItem> items = _cart.cart.cartItem;
    if (items.length < 1) {
      msgToast('No item in cart');
      return;
    }
    OrderServices orderServices = new OrderServices();
    ApiResponse apiResponse = await orderServices.placeNewOrder(items);
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      msgToast('${(apiResponse.data as ServerResponse).message}');
      Log.d(TAG, '${(apiResponse.data as ServerResponse).message}');
      _cart.cart.deleteAllCart();
      Navigator.pop(context);
    } else {
      msgToast('${(apiResponse.apiError as ApiError).error}');
      Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
    }
  }
}
