import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/api_error.dart';
import 'package:food_ordering_app/models/api_response.dart';
import 'package:food_ordering_app/models/user.dart';
import 'package:food_ordering_app/models/user_details.dart';
import 'package:food_ordering_app/widgets/msg_toast.dart';
import 'package:http/http.dart' as http;

class UserServices {
  // Server Address
  static const BASE_URL = 'http://192.168.1.2:3000';

  Future<ApiResponse> details(String userId) async {
    ApiResponse _apiResponse = new ApiResponse();
    Uri url = Uri.parse(BASE_URL + '/userdetails');
    try {
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
          print((_apiResponse.ApiError as ApiError).error);
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          print((_apiResponse.ApiError as ApiError).error);
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }

  Future<ApiResponse> login(String userName, String userPass) async {
    ApiResponse _apiResponse = new ApiResponse();
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
          _apiResponse.data = User.fromJson(json.decode(response.body));
          msgToast('Login Successful');
          break;
        case 401:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } catch (e) {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
      debugPrint("Debug Log: " + e.toString());
    }
    return _apiResponse;
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
          msgToast('SignUp Successful');
          break;
        case 409:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } /* on SocketException */ catch (e) {
      // _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
      print(e);
    }
    return _apiResponse;
  }

  Future<ApiResponse> user_detail_form(String userId, String email,
      String phone, String address, String pincode) async {
//    int isAvailable= 0;
    ApiResponse _apiResponse = new ApiResponse();

    Uri url = Uri.parse(BASE_URL);
    try {
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'user_email': email,
          'user_phno': phone,
          'user_addline': address,
          'user_pincode': pincode
        }),
      );

      switch (response.statusCode) {
        case 200:
          _apiResponse.data = User.fromJson(json.decode(response.body));
          msgToast('Dish Edit Successful');
          break;
        case 409:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
        default:
          _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
          break;
      }
    } on SocketException {
      _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    }
    return _apiResponse;
  }
}
