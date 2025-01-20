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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Confirm Your Booking',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildBookingDetailsTable(),
                  SizedBox(height: 40.h),
                  _buildBookingButton(context, state),
                  SizedBox(height: 16.h),
                  _buildCancelButton(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingDetailsTable() {
    return Table(
      border: TableBorder.all(
        color: AppColor.white,
        width: 1,
        borderRadius: BorderRadius.circular(8.r),
      ),
      children: [
        _buildTableRow('Place:', placeName),
        _buildTableRow('Duration:', duration),
      ],
    );
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColor.white,
              fontSize: 18.sp,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
              color: AppColor.white,
              fontSize: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingButton(BuildContext context, CommonState state) {
    return SizedBox(
      width: 360.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: 360.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            fontWeight: FontWeight.bold,
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
