import 'package:horizon_travel_and_tours_android_application/core/components/text_component.dart';
import 'package:horizon_travel_and_tours_android_application/screens/customized_trip/customized_trip.dart';

import '../../../../exports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return BlocBuilder<CommonCubit, CommonState>(
      builder: (_, state) {
        return Scaffold(
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
    );
  }

  AppBar _buildAppBar(CommonState state, BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      elevation: 0,
      title: const TextComponent(
        text: "User Profile!",
      ),
      systemOverlayStyle: systemOverlaySetting(),
   
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
