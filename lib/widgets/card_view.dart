import 'package:flutter/material.dart';
import 'package:food_ordering_app/util/soft_utils.dart';

class CardView extends StatelessWidget {
  final String userId, name, description, price, image;

  const CardView(
      {key, this.userId, this.name, this.description, this.price, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 120,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          splashColor: Colors.lightGreenAccent[200],
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/adminOrderItems',
              arguments: userId,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SoftUtils.loadImage(image),
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
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      // Text(description),
                      // Text("Price: " + price.toString()),
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
