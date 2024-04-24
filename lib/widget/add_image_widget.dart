import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:utility/utility.dart';
import 'package:image_picker/image_picker.dart';

class AddImageWidget extends StatefulWidget {
  late final String? image;
  late final ValueChanged<Image> onImageChanged;

  @override
  _AddImageWidgetState createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  String? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _pickImageFromGallery();
          },
          child: Icon(Icons.add_a_photo, color: Colors.white, size: 30.0),
        ),
        _selectedImage != null
            ? Container(
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Image.file(
            File(_selectedImage!),
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
        )
            : Container(),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    Uint8List? _bytes = await pickedImage?.readAsBytes();
    String _base64String = base64.encode(_bytes!);

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = _base64String as String?;
      // _selectedImage = pickedImage as PickedFile?;
      widget.onImageChanged(Image.file(File(pickedImage.path)));
    });
  }
}
