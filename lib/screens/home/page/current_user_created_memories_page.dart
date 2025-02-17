import 'dart:ui';

import '../../../exports.dart';

class MyCreatedMemories extends StatefulWidget {
  final bool isUserCreatedMemories;
  const MyCreatedMemories({super.key, required this.isUserCreatedMemories});

  @override
  State<MyCreatedMemories> createState() => _MyCreatedMemoriesState();
}

class _MyCreatedMemoriesState extends State<MyCreatedMemories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Created Memories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: BlocBuilder<CommonCubit, CommonState>(builder: (_, state) {
        return ListView.builder(
          cacheExtent: 1000000,
          itemCount: widget.isUserCreatedMemories ? state.userCreatedMemories.length : state.userSharedMemories.length,
          itemBuilder: (context, index) {
            final memory = widget.isUserCreatedMemories ? state.userCreatedMemories[index] : state.userSharedMemories[index];
            final memoryDate = _formatTimestamp(memory.timestamp);
            final bool isImageVisible = _isImageVisible(memory);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        memoryDate,
                        style: TextStyle(fontSize: 12.sp, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.isUserCreatedMemories) _buildDetailsTable(context, memory),
                    if (!widget.isUserCreatedMemories) _buildSharedMemoryTable(context, memory, isImageVisible),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  bool _isImageVisible(Memory memory) {
    final currentTime = DateTime.now();
    final viewStartTime = DateTime.parse(memory.viewStart);
    final viewEndTime = DateTime.parse(memory.viewEnd);

    return currentTime.isAfter(viewStartTime) && currentTime.isBefore(viewEndTime);
  }

  Widget _buildDetailsTable(BuildContext context, Memory memory) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [
        TableRow(
          children: [
            const TableCell(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Allowed Users', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(memory.allowedUsers.join(', '), style: const TextStyle(color: Colors.black)),
            )),
          ],
        ),
        if (memory.imageLinks.isNotEmpty) ...[
          TableRow(
            children: [
              const TableCell(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Image', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              )),
              TableCell(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: memory.imageLinks.first,
                  placeholder: (context, url) => Container(
                    width: 64.w,
                    height: 54.h,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Text("Something went wrong"),
                  fit: BoxFit.cover,
                  width: 100.w,
                  height: 100.w,
                ),
              )),
            ],
          ),
        ],
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Can Get Screenshot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(memory.canGetScreenshot ? 'Yes' : 'No', style: const TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Can Get Video Recording', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(memory.canGetVideoRecording ? 'Yes' : 'No', style: const TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Restricted', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(memory.restricted ? 'Yes' : 'No', style: const TextStyle(color: Colors.black)),
            )),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('View Start', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(memory.viewStart, style: const TextStyle(color: Colors.black)),
            )),
          ],
        ),
        TableRow(
          children: [
            const TableCell(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('View End', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(memory.viewEnd, style: const TextStyle(color: Colors.black)),
            )),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteDialog(context, memory);
                },
              ),
            ),
            TableCell(
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  context.navigateWithSlideBottomToTop(EditMemoryPage(
                    memory: memory,
                  ));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSharedMemoryTable(BuildContext context, Memory memory, bool isImageVisible) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: [
        TableRow(
          children: [
            const TableCell(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Restricted', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            )),
            TableCell(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(memory.restricted ? 'Yes' : 'No', style: const TextStyle(color: Colors.black)),
            )),
          ],
        ),
        if (memory.imageLinks.isNotEmpty) ...[
          TableRow(
            children: [
              const TableCell(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Image', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              )),
              TableCell(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 64.h,
                      width: 360.w,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: memory.imageLinks.first,
                            placeholder: (context, url) => Container(
                              width: 64.w,
                              height: 54.h,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Text("Something went wrong"),
                            fit: BoxFit.cover,
                            width: 100.w,
                            height: 100.w,
                          ),
                          ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.grey.withOpacity(0.1),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: IconButton(
                              icon: const Icon(
                                Icons.touch_app_sharp,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                context.navigateWithFade(ImageViewerScreen(memory: memory));
                              },
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
          TableRow(
            children: [
              const TableCell(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('View Start', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              )),
              TableCell(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(memory.viewStart, style: const TextStyle(color: Colors.black)),
              )),
            ],
          ),
          TableRow(
            children: [
              const TableCell(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('View End', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              )),
              TableCell(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(memory.viewEnd, style: const TextStyle(color: Colors.black)),
              )),
            ],
          ),
        ],
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, Memory memory) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            "Do you want to delete this memory?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _deleteMemory(context, memory);
                await context.read<CommonCubit>().fetchCreatedMemories();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool isDeleting = false;

  Future<void> _deleteMemory(BuildContext context, Memory memory) async {
    setState(() {
      isDeleting = true;
    });
    try {
      await FirebaseFirestore.instance.collection('memories').doc(memory.id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memory deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete memory: $e')),
      );
    }
    setState(() {
      isDeleting = false;
    });
  }
}
