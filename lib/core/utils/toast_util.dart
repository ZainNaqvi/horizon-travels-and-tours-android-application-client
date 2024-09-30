import '../../exports.dart';

void showToast(String message, BuildContext context, {ToastGravity toastGravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: toastGravity,
    textColor: Colors.white,
    backgroundColor: Colors.blue,
    fontSize: 16.0,
  );
}
