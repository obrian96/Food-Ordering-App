import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/order.dart';
import 'package:food_ordering_app/models/order_item.dart';
import 'package:food_ordering_app/models/order_list.dart';
import 'package:food_ordering_app/models/user.dart';
import 'package:food_ordering_app/services/order_services.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FutureState { COMPLETE, ERROR, LOADING, UNKNOWN }

class SoftUtils {
  static const String TAG = 'soft_utils.dart';
  static final SoftUtils _instance = SoftUtils._init();

  factory SoftUtils() {
    return _instance;
  }

  SoftUtils._init() {}

  dynamic state(snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return FutureState.LOADING;
    } else if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasData) {
      return FutureState.COMPLETE;
    } else if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasError) {
      return FutureState.ERROR;
    } else {
      return FutureState.UNKNOWN;
    }
  }

  Image loadImage(String base64UriString, {width, height, fit}) {
    Image image;
    if (base64UriString != null && base64UriString.isNotEmpty) {
      image = Image.memory(
        base64.decode(base64UriString.split(',').last),
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      image = Image.asset('assets/profile_placeholder.png');
    }
    return image;
  }

  Uint8List loadUint8ListImage(String base64UriString) =>
      base64.decode(base64UriString.split(',').last);

  Future getUserId() async =>
      await (await SharedPreferences.getInstance())?.getString('user_id');

  Future getUserName() async =>
      await (await SharedPreferences.getInstance()).getString('user_name');

  Future getUserEmail() async =>
      await (await SharedPreferences.getInstance()).getString('user_email');

  Future getUserImage() async =>
      await (await SharedPreferences.getInstance()).getString('user_image');

  Future getOrderedUserList() async {
    String userId = await getUserId();
    ApiResponse apiResponse = await OrderServices().getOrderedUserList(userId);
    List<User> userList = [];
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      userList = apiResponse.data;
    } else {
      Log.e(TAG, '${(apiResponse.data as ApiError).error}');
    }
    return userList;
  }

  Future getUserOrders(userId) async {
    String adminId = await SoftUtils().getUserId();
    Log.d(TAG, 'User id: $userId');
    ApiResponse apiResponse =
        await OrderServices().getOrderList(adminId, userId);
    List<Order> orderList = [];
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      orderList = apiResponse.data as List<Order>;
      Log.i(TAG, 'getUserOrders(userId): ${apiResponse.data}');
    } else {
      Log.e(
          TAG,
          'Future getUserOrders(userId) async {...} Exception: '
          '${(apiResponse.apiError as ApiError).error}');
    }
    return orderList;
  }

  Future getOrderItems(orderId) async {
    String adminId = await SoftUtils().getUserId();
    ApiResponse apiResponse =
        await OrderServices().getOrderItems(adminId, orderId);
    List<OrderItem> orderItems = [];
    List<Dish> dishList = [];
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      OrderList data = apiResponse.data as OrderList;
      orderItems = data.orderItems;
      dishList = data.dishList;
      Log.i(TAG, 'orderItems: $orderItems');
      Log.i(TAG, 'dishList: $dishList');
    } else {
      Log.e(
          TAG,
          'Future getOrderItems(orderId) async {...} Exception: '
          '${(apiResponse.apiError as ApiError).error}');
    }
    return [orderItems, dishList];
  }
}
