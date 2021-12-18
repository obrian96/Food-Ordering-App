import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class CatalogItemAdmin extends StatelessWidget {
  final Dish dish;

  const CatalogItemAdmin({Key key, @required this.dish})
      : assert(dish != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox(
        child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SoftUtils().loadImage(
            dish.dishImage,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.fitHeight,
            placeholder: 'assets/food.png',
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
                "\₹${dish.dishPrice}".text.xl.bold.make(),
                EditButton(dish),
              ],
            ).pOnly(right: 16.0)
          ],
        ))
      ],
    )).color(Colors.white60).roundedLg.square(140).make().py8();
  }
}

class EditButton extends StatelessWidget {
  final Dish dish;

  EditButton(this.dish);

  @override
  Widget build(context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/dishEditForm',
          arguments: dish,
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Vx.indigo500,
        ),
        shape: MaterialStateProperty.all(
          StadiumBorder(),
        ),
      ),
      child: Icon(Icons.edit),
    );
  }
}
