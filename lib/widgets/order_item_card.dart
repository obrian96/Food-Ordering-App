import 'package:flutter/material.dart';
import 'package:food_ordering_app/util/soft_utils.dart';

class OrderItemCard extends StatelessWidget {
  static const String TAG = 'order_management_card.dart';

  final int dishId, quantity, dishPrice, subtotalPrice;
  final String dishName, dishImage, isAvailable, dishType;

  OrderItemCard(
      {this.dishId,
      this.quantity,
      this.dishName,
      this.dishPrice,
      this.subtotalPrice,
      this.dishImage,
      this.isAvailable,
      this.dishType});

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 120,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          splashColor: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SoftUtils().loadImage(
                    dishImage,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$dishName',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text('Quantity: x$quantity'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Price: $dishPrice'),
                          Text('Subtotal: ${subtotalPrice}  '),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
