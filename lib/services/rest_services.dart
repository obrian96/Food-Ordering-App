import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/dish_list.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:http/http.dart' as http;

class RestServices {
  // Server Address
  // static const BASE_URL = 'http://192.168.0.102:3000';
  static const BASE_URL = 'http://192.168.1.2:3000';
  static const String TAG = 'rest_services.dart';
  static final RestServices _instance = RestServices._init();

  factory RestServices() {
    return _instance;
  }

  RestServices._init() {}

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
          toast('Server error. Please retry');
          break;
        default:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          toast('Server error. Please retry');
          break;
      }
    } on SocketException {
      _apiResponse.apiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }

  Future<ApiResponse> addDish(String dishImage, String dishName, int dishPrice,
      String dishType, String adminId) async {
    int isAvailable = 1;
    ApiResponse _apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/dishes');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          //'dish_id': dish_id,
          'dish_image': dishImage,
          'dish_name': dishName,
          'dish_price': dishPrice,
          'isAvailable': isAvailable,
          'dish_type': dishType,
        }),
      );

      switch (response.statusCode) {
        case 200:
          _apiResponse.data = Dish.fromJson(json.decode(response.body));
          toast('Dish Add Successful', Colors.green);
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

  Future editDish(String dishImage, String dishName, int dishPrice,
      int isAvailable, String dishType, int dishId, String adminId) async {
//    int isAvailable= 0;
    Log.i(TAG, '${dishImage}');
    ApiResponse _apiResponse = new ApiResponse();

    Uri url = Uri.parse(BASE_URL + '/dishes/$dishId');
    try {
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'dish_image': dishImage,
          'dish_name': dishName,
          'dish_price': dishPrice,
          'isAvailable': isAvailable,
          'dish_type': dishType,
          'dish_rest_id': adminId,
        }),
      );

      switch (response.statusCode) {
        case 200:
          // _apiResponse.Data = Dish.fromJson(json.decode(response.body));
          toast('Dish Edit Successful', Colors.green);
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

  Future deleteDish(dishId) async {
    ApiResponse apiResponse = new ApiResponse();

    Uri url = Uri.parse(BASE_URL + '/dishes/$dishId');
    try {
      final http.Response response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{}),
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data =
              ServerResponse.fromJson(json.decode(response.body));
          break;
        case 409:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          //msgToast('login failed');
          break;
        default:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          // msgToast('login failed');
          break;
      }
    } on SocketException {
      apiResponse.apiError = ApiError(error: "Server error. Please retry");
    }
    return apiResponse;
  }
}
