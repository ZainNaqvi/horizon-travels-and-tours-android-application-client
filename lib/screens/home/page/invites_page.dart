import '../../../exports.dart';

class InvitesScreen extends StatelessWidget {
  const InvitesScreen({super.key});

  Stream<DocumentSnapshot> _fetchUserDocument() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance.collection('user').doc(currentUserId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Invites',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.backgroundColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _fetchUserDocument(), // Use the user document stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userDoc = snapshot.data;
          if (userDoc == null || !userDoc.exists) {
            return const Center(child: Text('User not found.'));
          }

          final invites = List<String>.from(userDoc['invites'] ?? []); // Assuming invites is a List<String>

          if (invites.isEmpty) {
            return const Center(child: Text('No invites found.'));
          }

          return ListView.builder(
            itemCount: invites.length,
            itemBuilder: (context, index) {
              final inviteId = invites[index];
              return FutureBuilder<DocumentSnapshot>(
                future: _fetchUserDetails(inviteId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${userSnapshot.error}'),
                    );
                  }

                  final user = userSnapshot.data?.data() as Map<String, dynamic>?;

                  if (user == null) {
                    return const ListTile(
                      title: Text('User not found'),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['imageUrl'].toString().isNotEmpty ? NetworkImage(user['imageUrl']) : const NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnDNmpgYnTP4ELmIob69uKE1O0Rbrotna00g&s') as ImageProvider,
                          radius: 24.0,
                        ),
                        title: Text(user['name'] ?? 'Unknown'),
                        trailing: IconButton(
                          icon: const Icon(Icons.thumb_up_alt),
                          onPressed: () {
                            _acceptInvite(inviteId);
                          },
                          color: Colors.green,
                          tooltip: 'Accept Invite',
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _fetchUserDetails(String userId) async {
    return await FirebaseFirestore.instance.collection('user').doc(userId).get();
  }

  Future<void> _acceptInvite(String senderId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      print('No user is logged in.');
      return;
    }

    final currentUserDocRef = FirebaseFirestore.instance.collection('user').doc(currentUserId);
    final senderDocRef = FirebaseFirestore.instance.collection('user').doc(senderId);

    try {
      await currentUserDocRef.update({
        'friends': FieldValue.arrayUnion([senderId]),
      });

      await senderDocRef.update({
        'friends': FieldValue.arrayUnion([currentUserId]),
      });

      await currentUserDocRef.update({
        'invites': FieldValue.arrayRemove([senderId]),
      });

      print('Invite accepted from user: $senderId');
    } catch (e) {
      print('Error accepting invite: $e');
    }
  }
}
