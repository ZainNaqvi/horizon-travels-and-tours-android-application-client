import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Ensure you have this if using ScreenUtil
import '../../exports.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = [];
  int _currentIndex = 0;

  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePaths.add(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _imagePaths.addAll(images.map((image) => image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _imagePaths.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _imagePaths.clear();
                    });
                  },
                  icon: const Icon(Icons.clear))
              : const SizedBox(),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.backgroundColor,
        title: const Text(
          'Create Memory',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: _imagePaths.isNotEmpty ? 8.h : 34.h),
              Text(
                'Create Multiple Memories',
                style: TextStyle(color: Colors.black, fontSize: 24.sp),
              ),
              if (_imagePaths.isNotEmpty)
                Column(
                  children: [
                    Text(
                      '${_imagePaths.length} images selected',
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 450.h,
                      child: PageView.builder(
                        itemCount: _imagePaths.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              File(_imagePaths[index]),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _imagePaths.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: _currentIndex == index ? Colors.blue : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: _imagePaths.isNotEmpty ? 8.h : 64.h),
              _imagePaths.isNotEmpty
                  ? listTile('Next', () {}, color: Colors.green)
                  : Column(
                      children: [
                        listTile('Capture from Camera', () => _captureImage()),
                        SizedBox(height: 12.h),
                        listTile('Upload from Gallery', () => _uploadImage()),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget listTile(String text, VoidCallback callback, {Color color = AppColor.backgroundColor}) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        alignment: Alignment.center,
        width: 360.w,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
      ),
    );
  }
}
