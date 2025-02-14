import 'package:horizon_travel_and_tours_android_application/core/components/text_component.dart';
import 'package:horizon_travel_and_tours_android_application/screens/customized_trip/customized_trip.dart';

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
            drawer: const Drawer(),
            backgroundColor: AppColor.white,
            appBar: _buildAppBar(state, context),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  _buildButtonsSection(context, state),
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
      backgroundColor: AppColor.white,
      elevation: 0,
      title: const TextComponent(
        text: "Horizon Trips!",
      ),
      systemOverlayStyle: systemOverlaySetting(),
      actions: [
        Image.asset(AppAsset.avatar),
        if (state.userInvites.isNotEmpty)
          _buildNotificationIcon(
            context,
            state.userInvites.length,
          ),
        SizedBox(width: 12.w),
      ],
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

  Widget _buildButtonsSection(BuildContext context, CommonState state) {
    return Column(
      children: [
        CustomButton(
          buttonText: 'Find a tour',
          onPressed: () => context.navigateWithSlideRightToLeft(const FindTourPage()),
        ),
        SizedBox(height: 12.h),
        CustomButton(
          buttonText: 'Customize tour',
          onPressed: () => context.navigateWithSlideRightToLeft(const CustomizedTripScreen()),
        ),
        SizedBox(height: 12.h),
        CustomButton(
          buttonText: 'Create a memory',
          onPressed: () => context.navigateWithSlideRightToLeft(const MemoryScreen()),
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
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: CustomButton(
              buttonText: 'Booked Trip Details',
              onPressed: () => context.navigateWithSlideBottomToTop(const BookedTripDetailsPage()),
            ),
          ),
        if (state.userSharedMemories.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: CustomButton(
              buttonText: 'Shared Memories',
              onPressed: () {
                context.navigateWithSlideBottomToTop(const MyCreatedMemories(
                  isUserCreatedMemories: false,
                ));
              },
            ),
          ),
        if (state.userCreatedMemories.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: CustomButton(
              buttonText: 'My Created Memories',
              onPressed: () {
                context.navigateWithSlideBottomToTop(const MyCreatedMemories(
                  isUserCreatedMemories: true,
                ));
              },
            ),
          ),
      ],
    );
  }

  bool hasContent(CommonState state) {
    return state.bookings.isNotEmpty || state.userSharedMemories.isNotEmpty || state.userCreatedMemories.isNotEmpty;
  }
}
