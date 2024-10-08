import '../../exports.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String placeName;
  final String duration;
  final String placeId;

  const BookingConfirmationPage({
    super.key,
    required this.placeName,
    required this.duration,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: BlocBuilder<CommonCubit, CommonState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm Your Booking',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Place: $placeName',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Duration: $duration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.white,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () async {
                      if (!state.loading) {
                        String result = await context.read<CommonCubit>().createBooking(
                              placeId: placeId,
                              placeName: placeName,
                              duration: duration,
                            );
                        _showFinalMessage(context, result);
                      }
                    },
                    child: state.loading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Send Booking Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        NavigatorUtil.createRoute(const HomeScreen(), TransitionType.fade),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFinalMessage(BuildContext context, String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Booking Status',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
              color: AppColor.backgroundColor,
            ),
          ),
          content: Text(
            result,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColor.textColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  NavigatorUtil.createRoute(const HomeScreen(), TransitionType.fade),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: AppColor.backgroundColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
