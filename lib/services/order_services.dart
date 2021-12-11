import 'dart:convert';

import 'package:flutter_cart/model/cart_model.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/order_item.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderServices {
  // Server Address
  static const BASE_URL = 'http://192.168.1.2:3000';
  static const IMG_BASE_URL = 'https://static.toiimg.com';

  static const String TAG = 'order_services.dart';

  static List<OrderItem> getOrderList() {
    return [
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 3,
      ),
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 1,
      ),
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 4,
      ),
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 1,
      ),
      new OrderItem(
        id: 1,
        title: "Mix veg Pizza",
        price: 209,
        image: IMG_BASE_URL + "/thumb/53110049.cms?width=1200&height=900",
        quantity: 2,
      ),
    ];
  }

  Future<ApiResponse> placeNewOrder(List<CartItem> items) async {
    ApiResponse apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/new_order');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id');
    List<Dish> dishes = [];
    for (int i = 0; i < items.length; i++) {
      Dish dish = items[i].productDetails;
      dish.dishQuantity = items[i].quantity;
      dish.dishPrice = items[i].subTotal.round();
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
        body: jsonEncode(<String, String>{
          'user_id': userId,
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
    } catch (e) {
      Log.e(TAG, '$e');
      apiResponse.apiError = ApiError(error: '$e');
    }
    return apiResponse;
  }
}
