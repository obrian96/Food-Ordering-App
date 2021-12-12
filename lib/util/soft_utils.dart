import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoftUtils {
  static const int UNKNOWN = -1, LOADING = 0, COMPLETE = 1, ERROR = 2;

  static int state(snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return LOADING;
    } else if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasData) {
      return COMPLETE;
    } else if (snapshot.connectionState == ConnectionState.done &&
        snapshot.hasError) {
      return ERROR;
    }
  }

  static Image loadImage(String base64UriString) {
    Image image;
    if (base64UriString.isNotEmpty) {
      image = Image.memory(base64.decode(base64UriString.split(',').last));
    } else {
      image = Image.asset('assets/profile_placeholder.png');
    }
    return image;
  }

  static Uint8List loadUint8ListImage(String base64UriString) =>
      base64.decode(base64UriString.split(',').last);

  static String getUserImage(SharedPreferences prefs) =>
      prefs.getString('user_image');
}
