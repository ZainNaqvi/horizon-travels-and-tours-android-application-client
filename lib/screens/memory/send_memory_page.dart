import '../../exports.dart';

class SendMemoryPage extends StatefulWidget {
  const SendMemoryPage({super.key});

  @override
  State<SendMemoryPage> createState() => _SendMemoryPageState();
}

class _SendMemoryPageState extends State<SendMemoryPage> {
  @override
  void initState() {
    context.read<CommonCubit>().isActionCompleted(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.backgroundColor,
        title: const Text(
          'Send Memory',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          BlocBuilder<CommonCubit, CommonState>(builder: (context, state) {
            return state.actionCompleted
                ? IconButton(
                    onPressed: () {
                      context.replaceWithSlideBottomToTop(const HomeScreen());
                    },
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox();
          })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              return UserTile(
                userId: user['uid'],
                userName: user['name'],
                userEmail: user['email'],
                userImage: user['imageUrl'],
                onActionChanged: () {
                  context.read<CommonCubit>().isActionCompleted(true);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserTile extends StatefulWidget {
  final String userId;
  final String userName;
  final String userEmail;
  final String userImage;
  final VoidCallback onActionChanged;
  const UserTile({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.onActionChanged,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool isLoading = false;
  bool isFriend = false;
  bool isFriendLoading = true;
  bool inviteSent = false;
  bool actionCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkIfFriend();
  }

  Future<void> _checkIfFriend() async {
    try {
      final friendStatus = await checkIfFriend(widget.userId);
      setState(() {
        isFriend = friendStatus;
      });
    } catch (error) {
      print('Error checking friend status: $error');
    } finally {
      setState(() {
        isFriendLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: widget.userImage.isNotEmpty ? NetworkImage(widget.userImage) : const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnDNmpgYnTP4ELmIob69uKE1O0Rbrotna00g&s') as ImageProvider,
            radius: 24.0,
          ),
          title: Text(widget.userName),
          trailing: isLoading
              ? const CircularProgressIndicator()
              : IconButton(
                  onPressed: inviteSent
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          if (isFriend) {
                            sendMemory(widget.userId);
                            setState(() {
                              actionCompleted = true;
                            });
                          } else {
                            await sendInvite(widget.userId);
                            setState(() {
                              inviteSent = true;
                            });
                          }
                          setState(() {
                            isLoading = false;
                            widget.onActionChanged();
                          });
                        },
                  icon: Icon(
                    inviteSent
                        ? Icons.check_circle_outline
                        : isFriend
                            ? Icons.memory
                            : Icons.person_add,
                    color: inviteSent
                        ? Colors.blue
                        : isFriend
                            ? Colors.green
                            : AppColor.backgroundColor,
                  ),
                ),
        ),
      ),
    );
  }

  Future<bool> checkIfFriend(String userId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
    final doc = await docRef.get();

    if (doc.exists) {
      List<dynamic> friends = doc.data()?['friends'] ?? [];

      if (friends.isEmpty) {
        await docRef.set({
          'friends': [],
        }, SetOptions(merge: true));
      }

      return friends.contains(userId);
    }

    return false;
  }

  void sendMemory(String userId) {
    print('Sending memory to user: $userId');
  }

  Future<void> sendInvite(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('No user is logged in.');
    }

    final currentUserId = currentUser.uid;
    final currentUserDocRef = FirebaseFirestore.instance.collection('user').doc(currentUserId);
    final recipientDocRef = FirebaseFirestore.instance.collection('user').doc(userId);

    try {
      await currentUserDocRef.update({
        'friends': FieldValue.arrayUnion([userId]),
      });

      await recipientDocRef.update({
        'invites': FieldValue.arrayUnion([currentUserId]),
      });

      print('Invite sent to user: $userId');
    } catch (e) {
      print('Error sending invite: $e');
    }
  }
}
