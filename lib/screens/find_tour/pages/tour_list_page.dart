import '../../../exports.dart';

class FindTourPage extends StatelessWidget {
  const FindTourPage({super.key});

  static const double buttonWidth = 200;
  static const double gridHeight = 440;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FindTourCubit()..fetchPlaces(),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: ListView(
            children: [
              SizedBox(height: 8.h),
              _buildPlanTripButton(),
              SizedBox(height: 24.h),
              BlocBuilder<FindTourCubit, FindTourState>(
                builder: (context, state) {
                  if (state.selectedIndex == 0) {
                    return _buildTourGrid(context);
                  } else {
                    return _gridTwo(context, state.selectedPlan ?? 0);
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<FindTourCubit, FindTourState>(
          builder: (context, state) {
            return state.selectedPlan == null || state.selectedIndex == 1
                ? const SizedBox()
                : SizedBox(
                    width: 144.w,
                    height: 44.h,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        context.read<FindTourCubit>().changeSelectedIndex(1);
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildTourGrid(BuildContext context) {
    return SizedBox(
      height: FindTourPage.gridHeight.h,
      child: BlocBuilder<FindTourCubit, FindTourState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state.places.isEmpty) {
            return const Center(child: Text('No places found.'));
          }

          return GridView.builder(
            itemCount: state.places.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6.r,
              mainAxisSpacing: 6.r,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              return _buildTourCard(context, state.places[index], index);
            },
          );
        },
      ),
    );
  }

  Widget _buildTourCard(BuildContext context, Place place, int index) {
    return GestureDetector(
      onTap: () {
        context.read<FindTourCubit>().selectPlan(index);
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
                image: AssetImage('assets/images/tour_02.png'), // Update image path
                fit: BoxFit.fitHeight,
              ),
            ),
            child: BlocBuilder<FindTourCubit, FindTourState>(
              builder: (context, state) {
                return state.selectedPlan == index
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
                    : const SizedBox();
              },
            ),
          ),
          Text(
            place.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.calistoga(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: context.watch<FindTourCubit>().state.selectedPlan == index ? Colors.blue : AppColor.textColor,
                fontSize: 22.sp,
              ),
            ),
          ),
        ],
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

  Widget _gridTwo(BuildContext context, int selectedPlan) {
    return BlocBuilder<FindTourCubit, FindTourState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.places[selectedPlan].title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 24.h),
          ...List.generate(
            state.places[selectedPlan].duration.length,
            (index) => _listTile('${state.places[selectedPlan].duration[index]} Day tour', index),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff4B6792),
            ),
            onPressed: () {
              context.navigateWithSlideBottomToTop(BookingConfirmationPage(
                duration: state.places[selectedPlan].duration[state.selectedDurationIndex],
                placeName: state.places[selectedPlan].title,
                placeId: state.places[selectedPlan].docId,
              ));
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
    });
  }

  Widget _listTile(String text, int index) {
    return BlocBuilder<FindTourCubit, FindTourState>(builder: (context, state) {
      return GestureDetector(
        onTap: () {
          context.read<FindTourCubit>().changeSelectedDuration(index);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 54.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: state.selectedDurationIndex == index ? Colors.green : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          width: 360.w,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: state.selectedDurationIndex == index ? Colors.white : Colors.black,
              fontSize: 18.sp,
            ),
          ),
        ),
      );
    });
  }

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(360.w, 200.h),
      child: BlocBuilder<FindTourCubit, FindTourState>(builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 12.0.h),
          child: CustomAppBar(
            title: 'Find a tour',
            leadingIcon: Icons.arrow_back,
            leadingCallback: () {
              if (state.selectedIndex != 0) {
                context.read<FindTourCubit>().changeSelectedIndex(0);
              } else {
                Navigator.pop(context);
              }
            },
            trailingIcon: Icons.bookmark_outlined,
            trailingCallback: () {},
          ),
        );
      }),
    );
  }
}
