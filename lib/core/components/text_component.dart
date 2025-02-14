import 'package:horizon_travel_and_tours_android_application/exports.dart';

class TextComponent extends StatelessWidget {
  final String text;

  const TextComponent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final words = text.split(" ");

    if (words.isEmpty) {
      return const Text('');
    } else if (words.length == 1) {
      return Text(
        words[0],
        style: TextStyle(
          color: AppColor.appbarTitleColor,
          fontWeight: FontWeight.bold,
          fontSize: 32.sp,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 32),
        children: [
          TextSpan(
            text: '${words[0]} ',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: words.sublist(1).join(' '),
            style: const TextStyle(
              color: AppColor.appbarTitleColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
