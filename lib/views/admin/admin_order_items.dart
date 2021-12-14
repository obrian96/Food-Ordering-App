import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/order_item.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:food_ordering_app/widgets/order_item_card.dart';

class AdminOrderItems extends StatefulWidget {
  @override
  _AdminOrderItems createState() => _AdminOrderItems();
}

class _AdminOrderItems extends State<AdminOrderItems> {
  static const String TAG = 'admin_order_items.dart';

  final List<String> status = ['New', 'Processing', 'Delivered'];

  @override
  Widget build(context) {
    final List<Object> args = ModalRoute.of(context).settings.arguments;
    int orderId = args[0];
    int orderStatus = args[1];
    int orderTotalPrice = args[2];
    String orderStartDate = args[3];
    String orderEndDate = args[4];
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Items'),
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
      body: SafeArea(
        child: FutureBuilder(
          future: _getOrderItems(orderId),
          builder: (context, snapshot) {
            switch (SoftUtils().state(snapshot)) {
              case FutureState.COMPLETE:
                List<OrderItem> orderItems = snapshot.data[0];
                List<Dish> dishList = snapshot.data[1];
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order ID: ${orderId}',
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
                                      'Total Price: ${orderTotalPrice}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            // Set list items
                            OrderItem orderItem = orderItems[index];
                            Dish dish = dishList[index];
                            return OrderItemCard(
                              dishId: dish.dishId,
                              quantity: orderItem.quantity,
                              dishName: dish.dishName,
                              dishImage: dish.dishImage,
                              dishPrice: dish.dishPrice,
                              subtotalPrice: orderItem.price,
                            );
                          },
                          itemCount: snapshot.data[1] == null
                              ? 0
                              : snapshot.data[1].length,
                        ),
                      ),
                    ),
                  ],
                );

              case FutureState.UNKNOWN:
              case FutureState.ERROR:
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
      ),
    );
  }

  Future _getOrderItems(orderId) async {
    List<OrderItem> orderItems = [];
    List<Dish> dishes = [];
    List<Object> data = await SoftUtils().getOrderItems(orderId);
    orderItems = data[0];
    dishes = data[1];
    Log.i(TAG, '_getOrderItems(orderId): ${orderItems[0].price}');
    return [orderItems, dishes];
  }
}
