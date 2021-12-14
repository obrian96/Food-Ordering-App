import 'package:flutter/material.dart';

class OrdersCard extends StatelessWidget {
  static const String TAG = 'order_management_card.dart';

  final int orderId, orderStatus, orderTotalPrice;
  final String orderStartDate, orderEndDate;
  final List<String> status = ['New', 'Processing', 'Delivered'];

  OrdersCard(
      {this.orderId,
      this.orderStatus,
      this.orderTotalPrice,
      this.orderStartDate,
      this.orderEndDate});

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 150,
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
              '/adminOrderItems',
              arguments: [
                orderId,
                orderStatus,
                orderTotalPrice,
                orderStartDate,
                orderEndDate
              ],
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Order ID: $orderId',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Status: ${status[orderStatus]}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Start Date: ${orderStartDate.split('T')[0]}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Visibility(
                        visible: orderEndDate != null,
                        child: Text(
                          'End Date: ${orderEndDate != null ? orderEndDate.split('T')[0] : 0}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
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
