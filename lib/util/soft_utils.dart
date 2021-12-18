import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/models/order.dart';
import 'package:food_ordering_app/models/order_item.dart';
import 'package:food_ordering_app/models/order_list.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/models/user.dart';
import 'package:food_ordering_app/services/order_services.dart';
import 'package:food_ordering_app/services/rest_services.dart';
import 'package:food_ordering_app/services/user_services.dart';
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

  Image loadImage(String base64UriString, {width, height, fit, placeholder}) {
    Image image;
    if (base64UriString != null && base64UriString.isNotEmpty) {
      image = Image.memory(
        base64.decode(base64UriString.split(',').last),
        width: width,
        height: height,
        fit: BoxFit.fitHeight,
        gaplessPlayback: true,
      );
    } else {
      image = Image.asset(
        placeholder ?? 'assets/profile_placeholder.png',
        width: 100.0,
        height: 100.0,
        fit: BoxFit.fitHeight,
        gaplessPlayback: true,
      );
    }
    return image;
  }

  Image loadProfileImage(String profileImage) {
    return loadImage(profileImage);
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

  Future getIsAdmin() async =>
      await (await SharedPreferences.getInstance()).getInt('isAdmin');

  Future getOrderedUserList() async {
    String userId = await getUserId();
    ApiResponse apiResponse = await OrderServices().getOrderedUserList(userId);
    List<User> userList = [];
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      userList = apiResponse.data;
    } else {
      Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
    }
    return userList;
  }

  Future getUserList() async {
    String userId = await getUserId();
    ApiResponse apiResponse = await UserServices().getAllUser(userId);
    List<User> userList = [];
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      userList = apiResponse.data;
    } else {
      Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
    }
    return userList;
  }

  Future getUserOrders(userId) async {
    Log.d(TAG, 'User id: $userId');
    ApiResponse apiResponse = await OrderServices().getOrderList(userId);
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
    int isAdmin = await getIsAdmin();
    ApiResponse apiResponse = await OrderServices().getOrderItems(orderId);
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
    return [orderItems, dishList, isAdmin];
  }

  Future imageFileToBase64String(File image) async {
    // Log.i(TAG, '$image');
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image =
        ('data:image/jpeg;base64,' + base64Encode(imageBytes)).trim();
    // Log.i(TAG, '$base64Image');
    // await new Future.delayed(const Duration(seconds: 5));
    return [true, base64Image];
  }

  Future changeUserRole(String userId, int isAdmin) async {
    ApiResponse apiResponse = await UserServices().changeRole(userId, isAdmin);
    if (apiResponse != null && (apiResponse.apiError as ApiError) == null) {
      Log.i(TAG, '${(apiResponse.data as ServerResponse).message}');
    } else {
      Log.e(TAG, '${(apiResponse.apiError as ApiError).error}');
      return false;
    }
    return true;
  }

  Future changeOrderStatus(orderId, orderStatus) async {
    ApiResponse apiResponse =
        await UserServices().changeOrderStatus(orderId, orderStatus);
    return apiResponse;
  }

  Future deleteDish(dishId) async {
    ApiResponse apiResponse = await RestServices().deleteDish(dishId);
    return apiResponse;
  }
}
