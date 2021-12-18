import 'dart:convert';

import 'package:flutter_cart/model/cart_model.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/order.dart';
import 'package:food_ordering_app/models/order_item.dart';
import 'package:food_ordering_app/models/order_list.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/models/user.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderServices {
  static const String TAG = 'order_services.dart';

  // Server Address
  static const BASE_URL = 'http://192.168.1.2:3000';
  static const IMG_BASE_URL = 'https://static.toiimg.com';

  Future<ApiResponse> placeNewOrder(List<CartItem> items, totalPrice) async {
    ApiResponse apiResponse = ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/new_order');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    List<Dish> dishes = [];
    for (int i = 0; i < items.length; i++) {
      Dish dish = items[i].productDetails;
      dish.dishQuantity = items[i].quantity;
      dish.dishPrice = items[i].subTotal.round();
      dish.dishImage = '';
      dishes.add(dish);
      // Log.d(TAG, '${dish.toJson()}');
    }
    Log.i(TAG, '${jsonEncode(dishes)}');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'total_price': totalPrice,
          'order_items': '${jsonEncode(dishes)}',
        }),
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data =
              ServerResponse.fromJson(json.decode(response.body));
          Log.i(TAG, '${(apiResponse.data as ServerResponse).message}');
          break;
        case 401:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
          break;
        case 403:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
          break;
        default:
          Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } catch (e, s) {
      Log.e(TAG, '$e', stackTrace: s);
      apiResponse.apiError = ApiError(error: '$e');
    }
    return apiResponse;
  }

  Future<ApiResponse> getOrderedUserList(String user_id) async {
    ApiResponse apiResponse = ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/order_management/ordered_user_list');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user_id': user_id,
        }),
      );
      switch (response.statusCode) {
        case 200:
          Log.i(TAG, 'User list: ${response.body}');
          Iterable i = json.decode(response.body);
          List<User> users = List<User>.from(
            i.map((model) {
              return User.fromJson(model);
            }),
          );
          apiResponse.data = users;
          break;

        default:
          Log.e(TAG, '${response.body}');
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
      }
    } catch (e, s) {
      Log.e(TAG, 'Exception: $e', stackTrace: s);
    }
    return apiResponse;
  }

  Future<ApiResponse> getOrderList(userId) async {
    ApiResponse apiResponse = ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/order_management/order_list');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'user_id': userId,
        }),
      );
      switch (response.statusCode) {
        case 200:
          Log.i(TAG, '${response.body}');
          try {
            List<Order> orders = List<Order>.from(
              json.decode(response.body).map(
                    (model) => Order.fromJson(model),
                  ),
            );
            apiResponse.data = orders;
          } catch (e, stackTrace) {
            Log.e(TAG, '$e', stackTrace: stackTrace);
          }
          break;

        default:
          Log.e(TAG, '${response.body}');
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
      }
    } catch (e, stackTrace) {
      Log.e(
        TAG,
        'Future<ApiResponse> getOrderList(adminId, userId) async {...}'
        ' Exception: $e',
        stackTrace: stackTrace,
      );
    }
    return apiResponse;
  }

  Future<ApiResponse> getOrderItems(int orderId) async {
    ApiResponse apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/order_management/order_items');
    OrderList orderList = new OrderList();
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'order_id': orderId,
        }),
      );
      switch (response.statusCode) {
        case 200:
          // orderList = OrderList.fromJson(json.decode(response.body));

          List<OrderItem> orderItems =
              (json.decode(response.body)['order_items'] as List)
                  .map((orderItem) => OrderItem.fromJson(orderItem))
                  .toList();
          List<Dish> dishList =
              (json.decode(response.body)['dish_list'] as List)
                  .map((dish) => Dish.fromJson(dish))
                  .toList();
          orderList.orderItems = orderItems;
          orderList.dishList = dishList;
          apiResponse.data = orderList;
          break;

        default:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
      }
    } catch (e, stackTrace) {
      Log.e(
        TAG,
        'Future getOrderItems(adminId, orderId) async {...} Exception: $e',
        stackTrace: stackTrace,
      );
    }
    return apiResponse;
  }
}
