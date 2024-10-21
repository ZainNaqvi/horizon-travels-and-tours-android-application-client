import '../../../../exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getUserBookedDetails();
    super.initState();
  }

  getUserBookedDetails() async {
    await context.read<CommonCubit>().fetchUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocBuilder<CommonCubit, CommonState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                _buildAppLogo(),
                _buildCustomButton('Find a tour', callback: () {
                  context.navigateWithSlideRightToLeft(const FindTourPage());
                }),
                SizedBox(height: 42.h),
                _buildCustomButton('Customize tour', callback: () {}),
                SizedBox(height: 42.h),
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
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppLogo() {
    return Image.asset(AppAsset.icon);
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
