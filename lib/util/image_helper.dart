import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_ordering_app/models/dish.dart';
import 'package:food_ordering_app/util/soft_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

enum ImageSourceType { gallery, camera }
enum AppState { free, picked, cropped, uploading, complete }

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  Dish dish;
  String nextRoute;

  ImageFromGalleryEx(this.type, {this.dish, this.nextRoute});

  @override
  ImageFromGalleryExState createState() =>
      ImageFromGalleryExState(this.type, this.dish, this.nextRoute);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  static const String TAG = 'image_helper.dart';

  File _image;
  File imageFile;
  var imagePicker;
  var type;
  Dish dish;
  String nextRoute;
  bool _isUploading = false;

  AppState state;

  ImageFromGalleryExState(this.type, this.dish, this.nextRoute);

  @override
  void initState() {
    super.initState();
    state = AppState.free;
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: [
          SizedBox(
            height: 52,
          ),
          Text(
            'Tap to change',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                XFile image = await imagePicker.pickImage(
                    source: source,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.front);
                setState(() {
                  _image = File(image.path);
                  state = AppState.picked;
                  // Log.i(TAG, 'Image data: ${_image}');
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: _image != null
                    ? Image.file(
                        _image,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          type == ImageSourceType.gallery
                              ? Icons.image
                              : Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            child: state == AppState.free
                ? Text(
                    'Change Image',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )
                : Text(
                    state == AppState.cropped ? 'Done' : 'Crop Image',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
            onPressed: state == AppState.free
                ? null
                : () async {
                    if (state == AppState.picked) {
                      _cropImage();
                    } else if (state == AppState.cropped) {
                      setState(() {
                        _isUploading = true;
                      });
                      var args =
                          await SoftUtils().imageFileToBase64String(imageFile);
                      if (args[0]) {
                        if (dish != null) {
                          dish.dishImage = args[1];
                          Navigator.pop(context, [true, dish]);
                        }
                        if (nextRoute == '/userDetailForm') {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            nextRoute,
                            ModalRoute.withName('/profile'),
                            arguments: [null, args[1]],
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, nextRoute,
                              arguments: args[1]);
                        }
                      }
                    }
                  },
          ),
          SizedBox(
            height: 50,
          ),
          Visibility(
            visible: _isUploading,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Future _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                // CropAspectRatioPreset.original,
                // CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio16x9
              ]
            : [
                // CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                // CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio5x3,
                // CropAspectRatioPreset.ratio5x4,
                // CropAspectRatioPreset.ratio7x5,
                // CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
        _image = imageFile;
        state = AppState.cropped;
      });
    }
  }
}
