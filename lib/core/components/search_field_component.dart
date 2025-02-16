import '../../exports.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const CustomSearchField({
    Key? key,
    this.hintText = "Find a tour",
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: TextField(
        onChanged: onChanged,style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.grey),
          hintText: hintText,
          border: InputBorder.none, 
        ),
      ),
    );
  }
}
