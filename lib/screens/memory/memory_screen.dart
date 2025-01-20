import 'dart:io';
import '../../exports.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = [];
  String referenceId = '';
  int _currentIndex = 0;
  bool isUploadingMemory = false;
  bool isUploadedDone = false;
  Future<void> _captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imagePaths.add(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
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
                  ? listTile(isUploadedDone ? 'Next' : 'Upload Memory', () async {
                      isUploadedDone
                          ? context.navigateWithSlideRightToLeft(SendMemoryPage(
                              memeoryAddress: referenceId,
                            ))
                          : referenceId = await uploadMemory(_imagePaths);
                      // ignore: use_build_context_synchronously
                    }, color: Colors.green, isloading: isUploadingMemory)
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

  Future<String> uploadMemory(List<String> _imagePaths) async {
    setState(() {
      isUploadingMemory = true;
    });

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      setState(() {
        isUploadingMemory = false;
      });
      throw Exception('No user is logged in.');
    }

    final currentUserId = currentUser.uid;

    try {
      List<String> imageLinks = [];

      for (String path in _imagePaths) {
        File file = File(path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child('memories/$currentUserId/$fileName.jpg');

        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageLinks.add(downloadUrl);
      }

      final memoryData = {
        'uid': currentUserId,
        'imageLinks': imageLinks,
        'restricted': true,
        'allowed_user': [],
        'timestamp': FieldValue.serverTimestamp(),
        'viewStart': DateTime.now().toIso8601String(),
        'viewEnd': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        'canGetScreenshot': false,
        'canGetVideoRecording': false,
      };

      DocumentReference documentReference = await FirebaseFirestore.instance.collection('memories').add(memoryData);

      await documentReference.update({'docId': documentReference.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Memory uploaded successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      print("Memory uploaded successfully!");

      return documentReference.id;
    } catch (e) {
      print('Error uploading memory: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload memory: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
      throw Exception('Failed to upload memory.');
    } finally {
      setState(() {
        isUploadingMemory = false;
      });
    }
  }

  Widget listTile(String text, VoidCallback callback, {Color color = AppColor.backgroundColor, bool isloading = false}) {
    return isloading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColor.backgroundColor,
            ),
          )
        : GestureDetector(
            onTap: isloading
                ? null
                : () {
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
