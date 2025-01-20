import 'dart:ui';
import '../../../exports.dart';

class ImageViewerScreen extends StatefulWidget {
  final Memory memory;

  const ImageViewerScreen({super.key, required this.memory});

  @override
  // ignore: library_private_types_in_public_api
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late bool isImageVisible;

  @override
  void initState() {
    super.initState();
    _checkVisibility();
    if (!widget.memory.canGetScreenshot) {
      _secureScreen();
    }
  }

  void _checkVisibility() {
    final currentTime = DateTime.now();
    final viewStartTime = DateTime.parse(widget.memory.viewStart);
    final viewEndTime = DateTime.parse(widget.memory.viewEnd);

    setState(() {
      isImageVisible = currentTime.isAfter(viewStartTime) && currentTime.isBefore(viewEndTime);
    });
  }

  // Secures the screen by preventing screenshots or screen recording
  Future<void> _secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  // Removes screen security
  Future<void> _unsecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    _unsecureScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.backgroundColor,
        title: const Text(
          'Image Viewer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        itemCount: widget.memory.imageLinks.length,
        itemBuilder: (context, index) {
          if (isImageVisible) {
            return _buildVisibleImage(widget.memory.imageLinks[index]);
          } else {
            return _buildBlurredImage(widget.memory.imageLinks[index]);
          }
        },
      ),
    );
  }

  Widget _buildVisibleImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Text('Image failed to load'),
        ),
      ),
    );
  }

  Widget _buildBlurredImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
            errorWidget: (context, url, error) => const Text("Something went wrong"),
            fit: BoxFit.cover,
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
