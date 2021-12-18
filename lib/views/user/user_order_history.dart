import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/order.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/widgets/orders_card.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPage createState() => _OrderHistoryPage();
}

class _OrderHistoryPage extends State<OrderHistoryPage> {
  static const String TAG = 'user_order_history.dart';

  @override
  Widget build(context) {
    List args = ModalRoute.of(context).settings.arguments;
    String userId = args[0];
    String userName = args[1];
    Log.d(TAG, 'userId: $userId');
    return Scaffold(
      appBar: AppBar(
        title: Text('$userName'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: SoftUtils().getUserOrders(userId),
        builder: (context, snapshot) {
          switch (SoftUtils().state(snapshot)) {
            case FutureState.COMPLETE:
              return Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    Order order = snapshot.data[index];
                    Log.d(
                      TAG,
                      'Order ID: ${order.id}, '
                      'Order Statue: ${order.status}, '
                      'Order Total Price: ${order.totalPrice}, '
                      'Order Start Date: ${order.startDate}, '
                      'Order End Date: ${order.endDate}, ',
                    );
                    return OrdersCard(
                      orderId: order.id,
                      orderStatus: order.status,
                      orderTotalPrice: order.totalPrice,
                      orderStartDate: order.startDate,
                      orderEndDate: order.endDate,
                    );
                  },
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                ),
              );

            case FutureState.UNKNOWN:
            case FutureState.ERROR:
              Log.e(TAG, '${snapshot.error}');
              return Container(
                child: Center(
                  child: Text('Unable to load data!'),
                ),
              );

            case FutureState.LOADING:
            default:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
    );
  }
}
