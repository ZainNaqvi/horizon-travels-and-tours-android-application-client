import 'package:flutter/cupertino.dart';

import '../../../../exports.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: 266.w,
      elevation: 2.r,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Padding(
              padding: EdgeInsets.only(top: 18.h),
              child: Column(
                children: _buildDrawerItems(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24.w, top: 20.h),
      height: 120.h,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF007BFF),
            Color(0xFF009EFF),
          ],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppAsset.avatar,
            width: 44.w,
            height: 44.h,
          ),
          SizedBox(width: 16.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Horizon Trips And', style: TextStyle(fontSize: 16.sp)),
              Text('Tours', style: TextStyle(fontSize: 16.sp)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    final drawerItems = [
      // _DrawerItemData(
      //   title: "Dark Mode",
      //   leadingIcon: null,
      //   isTrailingIcon: true,
      //   callback: () async {
      //     Navigator.pop(context);
      //     await context.read<ColorThemeCubit>().updateTheme(context);
      //   },
      // ),
      _DrawerItemData(
        title: "Share App",
        // leadingIcon: AppAsset.shareIcon,
        callback: () async {
          // await ShareUtils.share(AppConstant.appurl);
        },
      ),
      _DrawerItemData(
        title: "More Apps",
        // leadingIcon: AppAsset.moreApps,
        callback: () async {
          // await CustomUrlLauncher.launchURL(AppConstant.moreApps);
        },
      ),
      _DrawerItemData(
        title: 'Feedback',
        // leadingIcon: AppAsset.feedBackIcon,
        callback: () async {
          // await CustomUrlLauncher.launchEmail(AppConstant.emailForFeedback);
        },
      ),
      _DrawerItemData(
        title: 'Rate Us',
        // leadingIcon: AppAsset.rateUsIcon,
        callback: () async {
          // showStarRatingDialog(context);
        },
      ),
      _DrawerItemData(
        title: 'Privacy Policy',
        // leadingIcon: AppAsset.privacyIcon,
        callback: () async {
          // await CustomUrlLauncher.launchURL(AppConstant.privacyPolicyLink);
        },
      ),
      _DrawerItemData(
        color: Colors.red,
        title: 'Logout',
        // leadingIcon: AppAsset.privacyIcon,
        callback: () async {
          await context.read<AuthCubit>().signOut(context);
        },
      ),
    ];

    return drawerItems
        .map((item) => CupertinoDrawerItem(
              callback: item.callback,
              leadingIconString: item.leadingIcon,
              titleText: item.title,
              isTrailingIcon: item.isTrailingIcon,
              color: item.color,
            ))
        .toList();
  }
}

class _DrawerItemData {
  final String title;
  final String? leadingIcon;
  final bool isTrailingIcon;
  final VoidCallback callback;
  final Color? color;
  _DrawerItemData({
    required this.title,
    this.leadingIcon,
    this.isTrailingIcon = false,
    required this.callback,
    this.color,
  });
}

class CupertinoDrawerItem extends StatelessWidget {
  final VoidCallback callback;
  final bool isLeadingIcon;
  final bool isTrailingIcon;
  final String? leadingIconString;
  final String titleText;
  final Color? color;

  const CupertinoDrawerItem({
    super.key,
    this.isLeadingIcon = true,
    this.isTrailingIcon = false,
    required this.callback,
    this.leadingIconString,
    required this.titleText,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: callback,
      title: Row(
        children: [
          if (isLeadingIcon && leadingIconString != null)
            SvgPicture.asset(
              leadingIconString!,
              width: 18.w,
              height: 24.h,
            ),
          if (ScreenUtil().screenWidth > 600) SizedBox(height: 45.h),
          if (isLeadingIcon) SizedBox(width: 8.w),
          Text(
            titleText,
            style: TextStyle(
              fontSize: 14.w,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
