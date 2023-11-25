// image_provider.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProvider extends ChangeNotifier {
  XFile? _image;

  XFile? get image => _image;

  void setImage(XFile? newImage) {
    _image = newImage;
    notifyListeners();
  }
}
