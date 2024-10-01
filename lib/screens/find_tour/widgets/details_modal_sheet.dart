import '../../../exports.dart'; // Adjust the imports accordingly.

void showFairyMeadowsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0.r),
      ),
    ),
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 64.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(44.r),
                ),
              ),
              CustomAppBar(
                title: 'Detail Hotel',
                leadingIcon: Icons.arrow_back,
                leadingCallback: () {
                  Navigator.pop(context);
                },
                trailingIcon: Icons.bookmark_outlined,
                trailingCallback: () {},
              ),
              SizedBox(height: 8.h),
              Image.asset(AppAsset.details, height: 200.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    _buildTitleRow(),
                    SizedBox(height: 4.h),
                    _buildLocationRow(),
                    SizedBox(height: 16.h),
                    _buildDurationOptions(),
                    SizedBox(height: 16.h),
                    _buildBottomMenuOptions(),
                    SizedBox(height: 16.h),
                    _buildDescription(),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff4B6792),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }),
  );
}

Widget _buildTitleRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _textWithCustomStyle('Fairy Meadows', fontSize: 18.sp, fontWeight: FontWeight.w400),
      _infoTile(Icons.star, '4.9'),
    ],
  );
}

Widget _buildLocationRow() {
  return Row(
    children: [
      const Icon(Icons.my_location, color: Colors.grey),
      SizedBox(width: 8.w),
      _textWithCustomStyle('Gilgit Baltistan', fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey),
    ],
  );
}

Widget _buildDurationOptions() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _durationTile(),
      _durationTile(),
      _durationTile(),
    ],
  );
}

Widget _buildBottomMenuOptions() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _bottomMenuTile('Description'),
      _bottomMenuTile('Details'),
      _bottomMenuTile('Reviews'),
    ],
  );
}

Widget _buildDescription() {
  return _textWithCustomStyle(
    'Fairy Meadows are idyllic alpine pastures surrounded by pine forest on the Northern slopes of Nanga Parbat. With breathtaking views of snow-clad mountains.',
    fontSize: 14.sp,
    color: Colors.grey,
  );
}

Widget _infoTile(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 28.sp, color: Colors.amberAccent.shade100),
      SizedBox(width: 4.h),
      _textWithCustomStyle(text, fontWeight: FontWeight.w400, color: Colors.black, fontSize: 18.sp),
    ],
  );
}

Widget _durationTile() {
  return Container(
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(50.r),
    ),
    child: const Row(
      children: [
        Icon(Icons.watch, color: Colors.grey),
        SizedBox(width: 4),
        Text(
          '5 days',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ],
    ),
  );
}

Widget _bottomMenuTile(String label) {
  return Column(
    children: [
      _textWithCustomStyle(label, fontSize: 18.sp, isShowdow: true),
      label != 'Description'
          ? const SizedBox()
          : ClipOval(
              child: Container(
                width: 38.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor.withOpacity(0.6),
                ),
              ),
            ),
    ],
  );
}

Text _textWithCustomStyle(
  String text, {
  bool isShowdow = false,
  Color color = AppColor.textColor,
  double fontSize = 22,
  FontWeight fontWeight = FontWeight.w400,
}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.calistoga(
      textStyle: TextStyle(
        shadows: isShowdow
            ? [
                Shadow(
                  blurRadius: 6,
                  offset: Offset.fromDirection(12),
                  color: AppColor.backgroundColor.withOpacity(0.4),
                ),
              ]
            : null,
        fontWeight: fontWeight,
        color: color,
        fontSize: fontSize.sp,
      ),
    ),
  );
}
