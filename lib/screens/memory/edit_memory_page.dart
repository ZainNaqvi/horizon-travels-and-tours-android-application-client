import 'package:intl/intl.dart';
import '../../../../exports.dart';

class EditMemoryPage extends StatefulWidget {
  final Memory memory;

  const EditMemoryPage({super.key, required this.memory});

  @override
  _EditMemoryPageState createState() => _EditMemoryPageState();
}

class _EditMemoryPageState extends State<EditMemoryPage> {
  final TextEditingController _viewStartController = TextEditingController();
  final TextEditingController _viewEndController = TextEditingController();
  final TextEditingController _restrictedController = TextEditingController();
  final TextEditingController _newUserController = TextEditingController();
  final TextEditingController _imageLinkController = TextEditingController();

  List<String> allowedUsers = [];
  List<String> imageLinks = [];
  bool canGetScreenshot = false;
  bool canGetVideoRecording = false;
  List<String> userNames = []; // To store user names
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // To format timestamps

  @override
  void initState() {
    super.initState();
    _viewStartController.text = widget.memory.viewStart;
    _viewEndController.text = widget.memory.viewEnd;
    _restrictedController.text = widget.memory.restricted.toString();
    allowedUsers = List<String>.from(widget.memory.allowedUsers);
    imageLinks = List<String>.from(widget.memory.imageLinks);
    canGetScreenshot = widget.memory.canGetScreenshot;
    canGetVideoRecording = widget.memory.canGetVideoRecording;

    _fetchUserNames();
  }

  @override
  void dispose() {
    _viewStartController.dispose();
    _viewEndController.dispose();
    _restrictedController.dispose();
    _newUserController.dispose();
    _imageLinkController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserNames() async {
    List<String> names = [];
    for (String userId in allowedUsers) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists) {
          names.add(userDoc['name'] ?? 'Unknown');
        } else {
          names.add('Unknown');
        }
      } catch (e) {
        names.add('Unknown');
      }
    }
    setState(() {
      userNames = names;
    });
  }

  bool isUpdating = false;
  Future<void> _updateMemory() async {
    setState(() {
      isUpdating = true;
    });
    await FirebaseFirestore.instance.collection('memories').doc(widget.memory.id).update({
      'viewStart': _viewStartController.text,
      'viewEnd': _viewEndController.text,
      'restricted': _restrictedController.text.toLowerCase() == 'true',
      'allowed_user': allowedUsers,
      'imageLinks': imageLinks,
      'canGetScreenshot': canGetScreenshot,
      'canGetVideoRecording': canGetVideoRecording,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Memory updated successfully!')),
    );
    await context.read<CommonCubit>().fetchCreatedMemories();
    setState(() {
      isUpdating = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.backgroundColor,
        title: const Text(
          'Edit Memory',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _viewStartController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'View Start',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                ),
                enabled: false, // Disabled
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _viewEndController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'View End',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                ),
                enabled: false, // Disabled
              ),
              const SizedBox(height: 16),

              // Restricted Field
              TextField(
                controller: _restrictedController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Restricted (true/false)',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 16),

              // Allowed Users Table
              const Text(
                'Allowed Users:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text('User Name', style: TextStyle(color: Colors.black))),
                  DataColumn(label: Text('User ID', style: TextStyle(color: Colors.black))),
                ],
                rows: List.generate(
                  allowedUsers.length,
                  (index) {
                    return DataRow(
                      cells: [
                        DataCell(Text(userNames.isNotEmpty ? userNames[index] : 'Loading...', style: const TextStyle(color: Colors.black))),
                        DataCell(Text(allowedUsers[index], style: const TextStyle(color: Colors.black))),
                      ],
                    );
                  },
                ),
              ),
              // TextField(
              //   controller: _newUserController,
              //   style: const TextStyle(color: Colors.black),
              //   decoration: const InputDecoration(
              //     labelText: 'Add User ID',
              //     labelStyle: TextStyle(color: Colors.black),
              //     focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              //   ),
              // ),
              // MaterialButton(
              //   onPressed: () {
              //     setState(() {
              //       if (_newUserController.text.isNotEmpty) {
              //         allowedUsers.add(_newUserController.text);
              //         userNames.add('Loading...'); // Placeholder for new user
              //       }
              //     });
              //     _newUserController.clear();
              //     _fetchUserNames(); // Fetch names again
              //   },
              //   color: Colors.blue,
              //   textColor: Colors.white,
              //   child: const Text('Add User'),
              // ),
              const SizedBox(height: 16),

              const Text(
                'Image Links:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: 8.h,
              ),
              Column(
                children: imageLinks.map((link) {
                  return CachedNetworkImage(
                    imageUrl: link,
                    placeholder: (context, url) => Container(
                      width: 64.w,
                      height: 64.h,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Text("Something went wrong"),
                    fit: BoxFit.contain,
                    width: 100.w,
                    height: 100.w,
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Text('Can Get Screenshot', style: TextStyle(color: Colors.black)),
                  Switch(
                    value: canGetScreenshot,
                    onChanged: (value) {
                      setState(() {
                        canGetScreenshot = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text('Can Get Video Recording', style: TextStyle(color: Colors.black)),
                  Switch(
                    value: canGetVideoRecording,
                    onChanged: (value) {
                      setState(() {
                        canGetVideoRecording = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: 360.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(12.r),
                  ),
                  onPressed: _updateMemory,
                  child: isUpdating
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Update Memory",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
