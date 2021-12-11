import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  final String name, description, price, image;

  const CardView({key, this.name, this.description, this.price, this.image})
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pizza")),
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
                  child:
                      Image.asset("assets/" + image, fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(description),
                      Text("Price: " + price.toString()),
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
