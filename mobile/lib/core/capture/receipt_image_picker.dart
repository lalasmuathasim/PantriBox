import 'package:image_picker/image_picker.dart';

abstract interface class ReceiptImagePicker {
  Future<XFile?> pickFromCamera();
  Future<XFile?> pickFromGallery();
}

class ImagePickerReceiptImagePicker implements ReceiptImagePicker {
  ImagePickerReceiptImagePicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<XFile?> pickFromCamera() {
    return _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
  }

  @override
  Future<XFile?> pickFromGallery() {
    return _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
  }
}
