import 'package:horizon_travel_and_tours_android_application/exports.dart';

class CustomizedTripScreen extends StatefulWidget {
  const CustomizedTripScreen({super.key});

  @override
  _CustomizedTripScreenState createState() => _CustomizedTripScreenState();
}

class _CustomizedTripScreenState extends State<CustomizedTripScreen> {
  final TextEditingController _placeNameController = TextEditingController();

  String? selectedRoomType = "Standard";
  String? selectedDuration = "1";

  bool includeLunch = false;
  bool includeJeepCharges = false;
  String selectedTransportMode = "Van";
  List<String> additionalServices = [];
  bool privateTrip = false;

  final List<String> roomTypes = ["Standard", "Deluxe", "Executive", "Executive Plus"];
  final List<String> transportModes = ["Van", "Car", "Cabin", "Coaster"];
  final List<String> serviceOptions = ["Spa", "Guided Tour", "Photography", "Meals on Wheels"];
  final List<String> durationOptions = ["1", "2", "3", "5", "7", "8", "10"];
  bool isSubmitting = false;
  // Submit booking method
  Future<void> _submitBooking() async {
    setState(() {
      isSubmitting = true;
    });
    var commonCubit = context.read<CommonCubit>();

    final placeName = _placeNameController.text;

    if (placeName.isEmpty || selectedDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }
    await commonCubit.createBooking(
      placeId: '',
      placeName: placeName,
      duration: selectedDuration!,
      additionalServices: additionalServices,
      bookingType: '',
      includeJeepCharges: includeJeepCharges,
      includeLunch: includeLunch,
      privateTrip: privateTrip,
      roomType: selectedRoomType,
      transportMode: selectedTransportMode,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking submitted successfully.")),
    );
    setState(() {
      isSubmitting = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.backgroundColor,
        title: const Text(
          "Customize Your Trip",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place Name
            TextField(
              controller: _placeNameController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: "Place Name",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),

            // Duration Dropdown
            DropdownButtonFormField<String>(
              value: selectedDuration,
              hint: const Text("Select Duration (in days)"),
              decoration: const InputDecoration(
                labelText: "Duration",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              items: durationOptions.map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text(
                    "$duration days",
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDuration = value;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Room Type Dropdown
            DropdownButtonFormField<String>(
              value: selectedRoomType,
              hint: const Text("Select Room Type"),
              decoration: const InputDecoration(
                labelText: "Room Type",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              items: roomTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRoomType = value;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Include Lunch Toggle
            SwitchListTile(
              title: const Text("Include Lunch"),
              value: includeLunch,
              onChanged: (value) {
                setState(() {
                  includeLunch = value;
                });
              },
            ),

            // Include Jeep Charges Toggle
            SwitchListTile(
              title: const Text("Include Jeep Charges"),
              value: includeJeepCharges,
              onChanged: (value) {
                setState(() {
                  includeJeepCharges = value;
                });
              },
            ),

            // Transport Mode Dropdown
            DropdownButtonFormField<String>(
              value: selectedTransportMode,
              decoration: const InputDecoration(
                labelText: "Transport Mode",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              items: transportModes.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(
                    mode,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTransportMode = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),

            Wrap(
              spacing: 8.0,
              children: serviceOptions.map((service) {
                final isSelected = additionalServices.contains(service);
                return ChoiceChip(
                  label: Text(
                    service,
                    style: const TextStyle(color: Colors.black),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        additionalServices.add(service);
                      } else {
                        additionalServices.remove(service);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),

            SwitchListTile(
              title: const Text("Private Trip (No Outsiders)"),
              value: privateTrip,
              onChanged: (value) {
                setState(() {
                  privateTrip = value;
                });
              },
            ),

            const SizedBox(height: 16.0),
            SizedBox(
              width: 360.w,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateFields()) {
                    _submitBooking();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48.0),
                  padding: EdgeInsets.all(12.r),
                ),
                child: isSubmitting
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Submit Booking",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    if (_placeNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid place name.")),
      );
      return false;
    }

    if (selectedRoomType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a room type.")),
      );
      return false;
    }

    if (selectedTransportMode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a transport mode.")),
      );
      return false;
    }

    return true;
  }
}
