import 'dart:convert';
import 'dart:io';

import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/dish_list.dart';
import 'package:food_ordering_app/widgets/msg_toast.dart';
import 'package:http/http.dart' as http;

class RestServices {
  // Server Address
  // static const BASE_URL = 'http://192.168.0.102:3000';
  static const BASE_URL = 'http://192.168.1.2:3000';

  Future<ApiResponse> getDishes() async {
    ApiResponse _apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/dishes');
    try {
      final http.Response response = await http.get(url);

      switch (response.statusCode) {
        case 200:
          _apiResponse.data = DishList.fromJson(json.decode(response.body));
          break;
        case 401:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          msgToast('Server error. Please retry');
          break;
        default:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          msgToast('Server error. Please retry');
          break;
      }
    } on SocketException {
      _apiResponse.apiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }

  Future<ApiResponse> addDish(String dishName, int dishPrice, String dishType,
      String restaurantId) async {
    int isAvailable = 1;
    ApiResponse _apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/dishes');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          //'dish_id': dish_id,
          'dish_name': dishName,
          'dish_price': dishPrice.toString(),
          'isAvailable': isAvailable.toString(),
          'dish_type': dishType,
          'dish_rest_id': restaurantId
        }),
      );

      switch (response.statusCode) {
        case 200:
          _apiResponse.data = Dish.fromJson(json.decode(response.body));
          msgToast('Dish Add Successful');
          break;
        case 409:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          // showToastMsg('login failed');
          break;
        default:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          // showToastMsg('login failed');
          break;
      }
    } on SocketException {
      _apiResponse.apiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }

  Future<ApiResponse> editDish(
      String dishName,
      String dishPrice,
      String isAvailable,
      String dishType,
      String dishId,
      String dishRestId) async {
//    int isAvailable= 0;
    ApiResponse _apiResponse = new ApiResponse();

    Uri url = Uri.parse(BASE_URL + '/dishes/$dishId');
    try {
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'dish_name': dishName,
          'dish_price': dishPrice,
          'isAvailable': isAvailable,
          'dish_type': dishType,
          'dish_rest_id': dishRestId,
        }),
      );

      switch (response.statusCode) {
        case 200:
          // _apiResponse.Data = Dish.fromJson(json.decode(response.body));
          msgToast('Dish Edit Successful');
          break;
        case 409:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          //msgToast('login failed');
          break;
        default:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          // msgToast('login failed');
          break;
      }
    } on SocketException {
      _apiResponse.apiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }
}
