import '../../../../exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CommonCubit commonCubit;
  @override
  void initState() {
    commonCubit = context.read<CommonCubit>();
    getUserDetails();
    super.initState();
  }

  Future<void> getUserDetails() async {
    await Future.wait([
      commonCubit.fetchUserBookings(),
      commonCubit.fetchUserInvites(),
      commonCubit.fetchSharedMemories(),
      commonCubit.fetchCreatedMemories(),
      commonCubit.fetchUserInvites(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<CommonCubit, CommonState>(
        builder: (_, state) {
          return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            appBar: _buildAppBar(state, context),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppLogo(),
                  SizedBox(height: 24.h),
                  _buildButtonsSection(context, state),
                  if (hasContent(state)) const Divider(),
                  _buildDynamicSections(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(CommonState state, BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      actions: state.userInvites.isNotEmpty
          ? [
              _buildNotificationIcon(
                context,
                state.userInvites.length,
              ),
              SizedBox(width: 12.w),
            ]
          : null,
    );
  }

  Widget _buildNotificationIcon(BuildContext context, int count) {
    return GestureDetector(
      onTap: () => context.navigateWithSlideBottomToTop(const InvitesScreen()),
      child: SizedBox(
        width: 30.w,
        height: 30.h,
        child: Stack(
          children: [
            Icon(Icons.notifications, color: Colors.white, size: 30.r),
            Positioned(
              right: 0,
              top: 5,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffc32c37),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
    return Center(
      child: Image.asset(
        AppAsset.icon,
        height: 180.h,
        width: 180.w,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCustomButton(String text, {required VoidCallback callback, Color? color}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomButton(
        fontWeight: FontWeight.w500,
        color: AppColor.textColor,
        bgColor: color ?? Colors.white,
        text: text,
        callback: callback,
      ),
    );
  }

  Widget _buildButtonsSection(BuildContext context, CommonState state) {
    return Column(
      children: [
        _buildCustomButton(
          'Find a tour',
          callback: () => context.navigateWithSlideRightToLeft(const FindTourPage()),
        ),
        _buildCustomButton(
          'Customize tour',
          callback: () {},
        ),
        _buildCustomButton(
          'Create a memory',
          callback: () => context.navigateWithSlideRightToLeft(const MemoryScreen()),
        ),
      ],
    );
  }

  Widget _buildDynamicSections(BuildContext context, CommonState state) {
    return Column(
      children: [
        if (state.loading)
          const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
        else if (state.bookings.isNotEmpty)
          _buildCustomButton(
            'Booked Trip Details',
            color: Colors.teal,
            callback: () => context.navigateWithSlideBottomToTop(const BookedTripDetailsPage()),
          ),
        if (state.userSharedMemories.isNotEmpty)
          _buildCustomButton(
            'Shared Memories',
            callback: () {
              // context.navigateWithSlideBottomToTop(const SharedMemoriesPage());
            },
          ),
        if (state.userCreatedMemories.isNotEmpty)
          _buildCustomButton(
            'My Created Memories',
            callback: () {
              // context.navigateWithSlideBottomToTop(const MyCreatedMemoriesPage());
            },
          ),
      ],
    );
  }

  bool hasContent(CommonState state) {
    return state.bookings.isNotEmpty || state.userSharedMemories.isNotEmpty || state.userCreatedMemories.isNotEmpty;
  }
}
