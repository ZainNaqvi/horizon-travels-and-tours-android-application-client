import 'package:horizon_travel_and_tours_android_application/screens/auth/presentation/widgets/back_button.dart';

import '../../../../exports.dart';

class FindTourPage extends StatelessWidget {
  FindTourPage({super.key});
  final List<String> list = [
    'Naran',
    'Murree',
    'Sawat',
    'Hunza',
    'Fairy Meadows',
    'Gawadar',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            CustomButton(
              text: 'Plan your trip',
              callback: () {},
              width: 200.w,
              color: AppColor.textColor,
              bgColor: AppColor.appGrey.withOpacity(0.2),
            ),
            SizedBox(height: 34.h),
            SizedBox(
              height: 440.h,
              child: GridView.builder(
                itemCount: 6,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.r,
                  mainAxisSpacing: 6.r,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(borderRadius: BorderRadius.circular(32.r), child: Image.asset('assets/images/tour_02.png')),
                      Text(
                        list[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.calistoga(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColor.textColor,
                            fontSize: 22.sp,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8.h),
              const Icon(Icons.home, color: Colors.blue),
              Container(
                width: 244.w,
                margin: EdgeInsets.only(left: 24.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.blue,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.home, color: Colors.white),
                    Icon(Icons.home, color: Colors.white),
                    Icon(Icons.home, color: Colors.white),
                    Icon(Icons.home, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(360.w, 200.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildBackButton(
              () {
                Navigator.pop(context);
              },
              color: AppColor.appGrey.withOpacity(0.2),
            ),
            Padding(
              padding: EdgeInsets.only(top: 44.0.h),
              child: Text(
                'Find a tour',
                textAlign: TextAlign.center,
                style: GoogleFonts.calistoga(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColor.textColor,
                    fontSize: 32.sp,
                  ),
                ),
              ),
            ),
            buildBackButton(
              () {},
              iconData: Icons.bookmark_outlined,
              iconColor: Colors.black,
              color: AppColor.appGrey.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
