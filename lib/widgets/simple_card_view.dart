import 'package:flutter/material.dart';
import 'package:food_ordering_app/util/logcat.dart';

class SimpleCardView extends StatelessWidget {
  final int index;
  final String name;

  static const String TAG = 'simple_card_view.dart';

  SimpleCardView({this.index, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(2),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          splashColor: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Log.i(TAG, 'You clicked on SimpleCardView item: ${index}');
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/adminOrderManagement');
                break;

              case 1:
                Navigator.pushNamed(context, '/adminRestaurantManagement');
                break;

              case 2:
                Navigator.pushNamed(context, '/adminUserManagement');
                break;

              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Page not found!"),
                  ),
                );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
