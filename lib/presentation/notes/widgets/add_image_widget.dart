import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasklyai/core/configs/extention.dart';

class AddImageWidget extends StatefulWidget {
  final ValueChanged<String?>? onImageUploaded;
  final String? initUrl;

  const AddImageWidget({super.key, this.onImageUploaded, this.initUrl});

  @override
  State<AddImageWidget> createState() => _AddImageWidgetState();
}

class _AddImageWidgetState extends State<AddImageWidget> {
  File? _image;
  bool _loading = false;
  String? _imageUrl;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _image = File(picked.path);
      _loading = true;
    });

    await _uploadToCloudinary();
  }

  /// ☁️ Upload to Cloudinary
  Future<void> _uploadToCloudinary() async {
    const cloudName = 'dgfmiwien';
    const apiKey = 'AVerPGwdL2EyOU1yPCWn3Xt1Ylg';
    const uploadPreset = 'pizza_store';

    final dio = Dio();

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_image!.path),
      'upload_preset': uploadPreset,
      "api_key": apiKey,
    });

    try {
      final res = await dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      setState(() {
        _imageUrl = res.data['secure_url'];
        _loading = false;
      });

      widget.onImageUploaded?.call(_imageUrl);
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('Upload error: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
      _imageUrl = null;
    });

    widget.onImageUploaded?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              const Icon(Icons.image_outlined),
              const SizedBox(width: 8),
              Text('Image', style: textTheme.bodyLarge),
              const Spacer(),
              if (_image != null)
                InkWell(
                  onTap: _removeImage,
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),

          const SizedBox(height: 12),

          /// Upload box
          GestureDetector(
            onTap: _image == null ? _pickImage : null,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(_imageUrl!, fit: BoxFit.cover),
      );
    }

    if (widget.initUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(widget.initUrl!, fit: BoxFit.cover),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.image_outlined, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text('Click to upload image', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
