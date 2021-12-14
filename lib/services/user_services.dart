import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/server_response.dart';
import 'package:food_ordering_app/models/user.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/util/logcat.dart';
import 'package:food_ordering_app/util/toast.dart';
import 'package:http/http.dart' as http;

class UserServices {
  static const TAG = 'user_services.dart';

  // Server Address
  // static const BASE_URL = 'http://192.168.0.102:3000';
  static const BASE_URL = 'http://192.168.1.2:3000';
  static int detailsTryCount = 0;

  Future<ApiResponse> details(String userId) async {
    ApiResponse _apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/userdetails');
    try {
      detailsTryCount++;
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
        }),
      );

      switch (response.statusCode) {
        case 200:
          _apiResponse.data = UserDetails.fromJson(json.decode(response.body));
          break;
        case 401:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
        case 403:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          Log.e(TAG, '${response}');
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } catch (e, s) {
      Log.e(TAG, '$e', stackTrace: s);
      _apiResponse.apiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }

  Future<ApiResponse> login(String userName, String userPass) async {
    ApiResponse apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/login');

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_email': userName,
          'user_pass': userPass,
        }),
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = User.fromJson(json.decode(response.body));
          break;
        case 401:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } catch (e) {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
      Log.e(TAG, 'Exception: $e');
    }
    return apiResponse;
  }

  Future<ApiResponse> signup(
      String userId, String username, String userEmail, String userPass) async {
    int isAdmin = 0;
    ApiResponse _apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/login/newuser');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'user_name': username,
          'user_email': userEmail,
          'user_pass': userPass,
          'isAdmin': isAdmin.toString()
        }),
      );

      switch (response.statusCode) {
        case 200:
          _apiResponse.data = User.fromJson(json.decode(response.body));
          toast('SignUp Successful', Colors.green);
          break;
        case 409:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          _apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } /* on SocketException */ catch (e) {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
      Log.e(TAG, e);
    }
    return _apiResponse;
  }

  Future<ApiResponse> user_detail_form(String userId, String email,
      String phone, String address, String pincode) async {
//    int isAvailable= 0;
    Log.d(TAG, 'Pincode: $pincode');
    ApiResponse apiResponse = new ApiResponse();

    Uri url = Uri.parse(BASE_URL + '/userdetails');
    try {
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'user_email': email,
          'user_phno': phone,
          'user_addline': address,
          'user_pincode': pincode,
        }),
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data =
              ServerResponse.fromJson(json.decode(response.body));
          break;
        case 401:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } catch (e) {
      Log.e(TAG, 'Line 167: Exception: $e');
      apiResponse.apiError = ApiError(error: '$e');
    }
    return apiResponse;
  }
}
