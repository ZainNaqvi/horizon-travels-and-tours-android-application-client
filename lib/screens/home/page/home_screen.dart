import '../../../../exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> userInvites = [];
  List<Memory> userSharedMemories = [];
  List<Memory> userCreatedMemories = [];
  @override
  void initState() {
    super.initState();
    getUserBookedDetails();
    fetchUserInvites();
    fetchMemories();
    fetchMemoriesCreatedByCurrentUser();
  }

  Future<List<Memory>> getMemoriesForCurrentUser() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      print('No user is logged in.');
      return [];
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('memories').where('allowed_users', arrayContains: currentUserId).get();

      return querySnapshot.docs.map((doc) => Memory.fromDocument(doc)).toList();
    } catch (e) {
      print('Error fetching memories: $e');
      return [];
    }
  }

  Future<void> fetchMemories() async {
    final memories = await getMemoriesForCurrentUser();
    setState(() {
      userSharedMemories = memories;
    });
  }

  Future<void> fetchMemoriesCreatedByCurrentUser() async {
    final memories = await getMemoriesForCurrentUser();
    setState(() {
      userCreatedMemories = memories;
    });
  }

  getUserBookedDetails() async {
    await context.read<CommonCubit>().fetchUserBookings();
  }

  fetchUserInvites() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('user').doc(currentUser.uid).get();
      setState(() {
        userInvites = List<String>.from(userDoc.data()?['invites'] ?? []);
      });
    }
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

  @override
  void didChangeDependencies() {
    fetchUserInvites();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocBuilder<CommonCubit, CommonState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.backgroundColor,
            actions: [
              userInvites.isEmpty ? const SizedBox() : myAppBarIcon(userInvites.length),
              SizedBox(width: 12.w),
            ],
          ),
          backgroundColor: AppColor.backgroundColor,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppLogo(),
                _buildCustomButton('Find a tour', callback: () {
                  context.navigateWithSlideRightToLeft(const FindTourPage());
                }),
                SizedBox(height: 12.h),
                _buildCustomButton('Customize tour', callback: () {}),
                SizedBox(height: 12.h),
                _buildCustomButton('Create a memory', callback: () {
                  context.navigateWithSlideRightToLeft(const MemoryScreen());
                }),
                SizedBox(height: state.bookings.isNotEmpty ? 42.h : 0.h),
                state.loading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    : state.bookings.isNotEmpty
                        ? _buildCustomButton('Booked Trip Details', color: Colors.teal, callback: () {
                            context.navigateWithSlideBottomToTop(const BookedTripDetailsPage());
                          })
                        : const SizedBox(),
                SizedBox(height: 12.h),
                userSharedMemories.isNotEmpty
                    ? _buildCustomButton('Shared Memories', color: Colors.white, callback: () {
                        context.navigateWithSlideBottomToTop(const BookedTripDetailsPage());
                      })
                    : const SizedBox(),
                SizedBox(height: 12.h),
                userCreatedMemories.isNotEmpty
                    ? _buildCustomButton('My Created Memories', color: Colors.white, callback: () {
                        context.navigateWithSlideBottomToTop(const MyCreatedMemories());
                      })
                    : const SizedBox(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget myAppBarIcon(_counter) {
    return GestureDetector(
      onTap: () {
        context.navigateWithSlideBottomToTop(const InvitesScreen());
      },
      child: SizedBox(
        width: 30.w,
        height: 30.h,
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30.r,
            ),
            Container(
              width: 30.w,
              height: 30.h,
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 5),
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xffc32c37), border: Border.all(color: Colors.white, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Center(
                    child: Text(
                      _counter.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Image.asset(
      AppAsset.icon,
      height: 200.h,
      width: 360.w,
    );
  }

  Widget _buildCustomButton(String text, {required VoidCallback callback, Color? color}) {
    return CustomButton(
      fontWeight: FontWeight.w500,
      color: AppColor.textColor,
      bgColor: color ?? Colors.white,
      text: text,
      callback: callback,
    );
  }
}
