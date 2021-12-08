import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/widgets/catalog_image.dart';
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
        Hero(
          tag: Key(dish.dishId.toString()),
          child: CatalogImage(
            image:
                "https://static.toiimg.com/thumb/53110049.cms?width=1200&height=900",
          ),
        ),
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
                EditButton(dish.dishId),
              ],
            ).pOnly(right: 16.0)
          ],
        ))
      ],
    )).color(Colors.white60).roundedLg.square(140).make().py8();
  }
}

class EditButton extends StatelessWidget {
  final int dish_id;

  EditButton(this.dish_id);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/dishEditForm',
          arguments: dish_id,
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
