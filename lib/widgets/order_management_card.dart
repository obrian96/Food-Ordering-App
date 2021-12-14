import 'package:flutter/material.dart';
import 'package:food_ordering_app/util/soft_utils.dart';

class OrderManagementCard extends StatelessWidget {
  static const String TAG = 'order_management_card.dart';

  final String userId, userName, userImage;

  const OrderManagementCard({this.userId, this.userName, this.userImage});

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
          onTap: () {
            Navigator.pushNamed(
              context,
              '/adminOrders',
              arguments: [userId, userName],
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
                  child: SoftUtils().loadImage(userImage),
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
                        '$userName',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
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
