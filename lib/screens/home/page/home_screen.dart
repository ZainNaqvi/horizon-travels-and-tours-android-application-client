import 'dart:developer';

import 'package:horizon_travel_and_tours_android_application/core/components/drawer_component.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/search_field_component.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/text_component.dart';
import 'package:horizon_travel_and_tours_android_application/core/components/tour_card_component.dart';
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
    getPlaces();
  }

  Future<void> getPlaces() async {
    await commonCubit.fetchPlaces();
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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: CustomSearchField(),
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
                  children: [
                    CircleAvatar(),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [],
                ),
              ],
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
        SizedBox(width: 12.w),
      ],
    );
  }
}
