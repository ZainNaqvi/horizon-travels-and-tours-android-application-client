import '../../../exports.dart';

class FindTourPage extends StatefulWidget {
  const FindTourPage({super.key});

  @override
  State<FindTourPage> createState() => _FindTourPageState();
}

class _FindTourPageState extends State<FindTourPage> {
  late FindTourCubit findTourCubit;
  double buttonWidth = 200;
  double gridHeight = 440;

  @override
  void initState() {
    findTourCubit = context.read<FindTourCubit>();

    fetchPlaces();
    super.initState();
  }

  Future<void> fetchPlaces() async {
    await findTourCubit.fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindTourCubit, FindTourState>(
      builder: (_, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: ListView(
              children: [
                SizedBox(height: 8.h),
                _buildHeader(),
                SizedBox(height: 24.h),
                _buildTourContent(context, state),
              ],
            ),
          ),
          floatingActionButton: _buildNextButton(state),
        );
      },
    );
  }

  Widget _buildTourContent(BuildContext context, FindTourState state) {
    if (state.selectedIndex == 0) {
      return _buildTourGrid(state);
    } else {
      return _gridTwo(context, state.selectedPlan ?? 0);
    }
  }

  Widget _buildTourGrid(FindTourState state) {
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
        return _buildTourCard(state.places[index], index, state);
      },
    );
  }

  Widget _buildTourCard(Place place, int index, FindTourState state) {
    return GestureDetector(
      onTap: () => context.read<FindTourCubit>().selectPlan(index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTourImage(index, state),
          _buildTourTitle(place.title, index, state),
        ],
      ),
    );
  }

  Widget _buildTourImage(int index, FindTourState state) {
    return Container(
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
      child: state.selectedPlan == index
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: IconButton(
                onPressed: () {
                  showInfoModal(context);
                },
                icon: const Icon(
                  Icons.info,
                  color: Colors.amber,
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildTourTitle(String title, int index, FindTourState state) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.calistoga(
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: state.selectedPlan == index ? Colors.blue : AppColor.textColor,
          fontSize: 22.sp,
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 450.h,
          width: 350.w,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: context.read<FindTourCubit>().state.places[selectedPlan].duration.length,
            itemBuilder: (context, index) => _listTile('${context.read<FindTourCubit>().state.places[selectedPlan].duration[index]} Day tour', index),
          ),
        ),
        SizedBox(height: 24.h),
        _buildBookNowButton(selectedPlan),
      ],
    );
  }

  Widget _listTile(String text, int index) {
    return GestureDetector(
      onTap: () {
        context.read<FindTourCubit>().changeSelectedDuration(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: context.read<FindTourCubit>().state.selectedDurationIndex == index ? Colors.green : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        width: 360.w,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.read<FindTourCubit>().state.selectedDurationIndex == index ? Colors.white : Colors.black,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildBookNowButton(int selectedPlan) {
    return SizedBox(
      width: 350.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff4B6792),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        onPressed: () {
          context.navigateWithSlideBottomToTop(BookingConfirmationPage(
            duration: context.read<FindTourCubit>().state.places[selectedPlan].duration[context.read<FindTourCubit>().state.selectedDurationIndex],
            placeName: context.read<FindTourCubit>().state.places[selectedPlan].title,
            placeId: context.read<FindTourCubit>().state.places[selectedPlan].docId,
          ));
        },
        child: const Text(
          'Book Now',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildNextButton(FindTourState state) {
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
  }

  AppBar _buildAppBar(BuildContext context, FindTourState state) {
    return AppBar(
      backgroundColor: AppColor.backgroundColor,
      leading: IconButton(
        onPressed: () {
          if (state.selectedIndex != 0) {
            context.read<FindTourCubit>().changeSelectedIndex(0);
          } else {
            Navigator.pop(context);
          }
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      title: const Text(
        'Find a tour',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
