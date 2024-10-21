import '../../exports.dart';

class SendMemoryPage extends StatefulWidget {
  final String memeoryAddress;
  const SendMemoryPage({super.key, required this.memeoryAddress});

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
                memeoryAddress: widget.memeoryAddress,
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
  final String memeoryAddress;
  final VoidCallback onActionChanged;
  const UserTile({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.memeoryAddress,
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
                            sendMemory(
                              widget.memeoryAddress,
                              widget.userId,
                              context,
                            );
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

    final docRef = FirebaseFirestore.instance.collection('user').doc(currentUserId);
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

  Future<void> sendMemory(String docID, String userId, BuildContext context) async {
    print('Sending memory to user: $docID');

    final memoryDocRef = FirebaseFirestore.instance.collection('memories').doc(docID);

    try {
      await memoryDocRef.update({
        'allowed_users': FieldValue.arrayUnion([userId]),
      });

      print('User $userId has been added to allowed_users for memory $docID.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User $userId has been added to allowed users!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding user to allowed_users: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding user to allowed users.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
