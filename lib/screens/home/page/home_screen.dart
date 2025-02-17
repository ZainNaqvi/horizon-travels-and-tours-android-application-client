import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/drawer_component.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/floating_action_button_component.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/search_field_component.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/text_component.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/tour_card_component.dart';
import 'package:horizon_travel_and_tours_android_application/screens/customized_trip/customized_trip.dart';
import 'package:horizon_travel_and_tours_android_application/screens/profile/profile_screen.dart';

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
    super.initState();
    commonCubit = context.read<CommonCubit>();
    getPlaces();
  }

  Future<void> getPlaces() async {
    await commonCubit.fetchPlaces();
    log(commonCubit.state.places.toString());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<CommonCubit, CommonState>(
        builder: (_, state) {
          return Scaffold(
            drawer: const MyDrawer(),
            appBar: _buildAppBar(state, context),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await getPlaces();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: const CustomSearchField(
                        enabled: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300.h,
                    width: 360.w,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 16.w, top: 12.h),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.places.length,
                      itemBuilder: (_, index) {
                        Place place = state.places[index];

                        return TourCard(
                          imageHeight: 224.h,
                          imageUrl: place.imageUrl,
                          title: place.title,
                          location: place.subLocation[0],
                          rating: place.rating,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sliderItem(Colors.grey),
                      SizedBox(width: 4.w),
                      sliderItem(Colors.blue),
                      SizedBox(width: 4.w),
                      sliderItem(Colors.grey),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Popular Places",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 24.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "View all",
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.places.length,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18.0.h,
                      mainAxisSpacing: 18.0.w,
                      childAspectRatio: 0.75.r,
                    ),
                    itemBuilder: (context, index) {
                      Place place = state.places[0];

                      return TourCard(
                        imageHeight: 100.h,
                        imageUrl: place.imageUrl,
                        title: place.title,
                        location: place.subLocation[0],
                        rating: place.rating,
                      );
                    },
                  )
                ],
              ),
            ),
            floatingActionButton: _buildFloatingActionButton(context),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  Container sliderItem(
    Color color,
  ) {
    return Container(
      height: 8.h,
      width: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
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
        IconButton(
          onPressed: () {
            context.navigateWithSlideRightToLeft(const ProfileScreen());
          },
          icon: Image.asset(AppAsset.avatar),
        )
      ],
    );
  }

  FloatingActionButtonComponent _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButtonComponent(
      btnText: "Customize Trip",
      callback: () {
        context.navigateWithSlideBottomToTop(const CustomizedTripScreen());
      },
    );
  }
}
