import '../../../exports.dart';

class MyCreatedMemories extends StatelessWidget {
  const MyCreatedMemories({super.key});

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
      body: FutureBuilder<List<Memory>>(
        future: getMemoriesByCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final memories = snapshot.data ?? [];

          if (memories.isEmpty) {
            return const Center(child: Text('No created memories found.'));
          }

          return ListView.builder(
            itemCount: memories.length,
            itemBuilder: (context, index) {
              final memory = memories[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Memory ID: ${memory.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Allowed Users: ${memory.allowedUsers.join(', ')}'),
                      const SizedBox(height: 8),
                      Text('Image Links: ${memory.imageLinks.join(', ')}'),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Memory>> getMemoriesByCurrentUser() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      print('No user is logged in.');
      return [];
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('memories').where('uid', isEqualTo: currentUserId).get();

      return querySnapshot.docs.map((doc) => Memory.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching memories: $e');
      return [];
    }
  }
}
