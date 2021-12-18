import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/cart.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:velocity_x/velocity_x.dart';

class CatalogItemUser extends StatelessWidget {
  static const String TAG = 'user_catalog_item.dart';

  final Dish dish;

  const CatalogItemUser({Key key, @required this.dish})
      : assert(dish != null),
        super(key: key);

  @override
  Widget build(context) {
    Log.d(TAG, 'Dish image: ${dish.dishImage}');
    return SafeArea(
      child: VxBox(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SoftUtils().loadImage(
                dish.dishImage,
                width: 100.0,
                height: 100.0,
                fit: BoxFit.fitHeight,
              ),
            ).p16(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dish.dishName.text.lg.color(Color(0xff403b58)).bold.make(),
                dish.dishType.text
                    .textStyle(context.captionStyle)
                    .color(Color(0xff403b58))
                    .make(),
                10.heightBox,
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  buttonPadding: EdgeInsets.zero,
                  children: [
                    "\K${dish.dishPrice}".text.xl.bold.make(),
                    AddToCart(dish: dish),
                  ],
                ).pOnly(right: 16.0)
              ],
            ))
          ],
        ),
      ).color(Colors.white).rounded.square(140).shadowSm.make().p8(),
    );
  }
}

class AddToCart extends StatelessWidget {
  final Dish dish;

  AddToCart({
    Key key,
    this.dish,
  }) : super(key: key);

  final CartModel _cart = CartModel();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_cart.cart.findItemIndexFromCart(dish.dishId) == null) {
          CartModel().addToCart(dish);
          toast('${dish.dishName} added in the cart', Colors.green);
        } else {
          CartModel()
              .addItemToCart(_cart.cart.findItemIndexFromCart(dish.dishId));
          toast('${dish.dishName} added in the cart', Colors.green);
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Vx.indigo500,
        ),
        shape: MaterialStateProperty.all(
          StadiumBorder(),
        ),
      ),
      child: "Add to Cart".text.make(),
    );
  }
}
