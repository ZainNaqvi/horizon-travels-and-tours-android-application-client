import 'dart:developer';

import 'package:horizon_travel_and_tours_android_application/exports.dart';

class FindTourPage extends StatefulWidget {
  const FindTourPage({super.key});

  // Constants
  static const double buttonWidth = 200;
  static const double gridHeight = 440;

  @override
  State<FindTourPage> createState() => _FindTourPageState();
}

class _FindTourPageState extends State<FindTourPage> {
  int _selectedIndex = 0;
  int? _selectedPlan;

  final List<String> tourLocations = [
    'Naran',
    'Murree',
    'Sawat',
    'Hunza',
    'Fairy Meadows',
    'Gawadar',
  ];
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(systemOverlaySetting());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: ListView(
          children: [
            SizedBox(height: 8.h),
            _buildPlanTripButton(),
            SizedBox(height: 24.h),
            _selectedIndex == 0 ? _buildTourGrid() : gridTwo(context),
          ],
        ),
      ),
      floatingActionButton: _selectedPlan == null || _selectedIndex == 1
          ? null
          : SizedBox(
              width: 144.w,
              height: 44.h,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }

  Column gridTwo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        listTile('1 Day tour'),
        listTile('3 Day tour'),
        listTile('5 Day tour'),
        SizedBox(height: 24.h),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff4B6792),
          ),
          onPressed: () {
            context.navigateWithSlideBottomToTop(const BookingConfirmationPage());
          },
          child: const Text(
            'Book Now',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Container listTile(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 54.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      width: 360.w,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
        ),
      ),
    );
  }

  Widget _buildPlanTripButton() {
    return Text(
      'Plan Your Trip',
      textAlign: TextAlign.center,
      style: GoogleFonts.cedarvilleCursive(
        textStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColor.textColor,
          fontSize: 28.sp,
        ),
      ),
    );
  }

  Widget _buildTourGrid() {
    return SizedBox(
      height: FindTourPage.gridHeight.h,
      child: GridView.builder(
        itemCount: tourLocations.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 6.r,
          mainAxisSpacing: 6.r,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          return _buildTourCard(tourLocations[index], index);
        },
      ),
    );
  }

  Widget _buildTourCard(String location, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = index;

          log((index == _selectedPlan).toString());
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.topRight,
            width: 200.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              image: const DecorationImage(
                image: AssetImage('assets/images/tour_02.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: _selectedPlan == index
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                    child: IconButton(
                      onPressed: () {
                        showFairyMeadowsModal(context);
                      },
                      icon: const Icon(
                        Icons.info,
                        color: Colors.amber,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Text(
            location,
            textAlign: TextAlign.center,
            style: GoogleFonts.calistoga(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: _selectedPlan == index ? Colors.blue : AppColor.textColor,
                fontSize: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(360.w, 200.h),
      child: CustomAppBar(
        title: 'Find a tour',
        leadingIcon: Icons.arrow_back,
        leadingCallback: () {
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else {
            Navigator.pop(context);
          }
        },
        trailingIcon: Icons.bookmark_outlined,
        trailingCallback: () {},
      ),
    );
  }
}
