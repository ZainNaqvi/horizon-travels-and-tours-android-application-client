import '../../exports.dart';

class AppTheme {
  static _border([Color color = AppColor.warmBlue]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColor.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.redOrange,
    ),
    chipTheme: const ChipThemeData(
      color: MaterialStatePropertyAll(
        AppColor.darkGrey,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppColor.darkGrey),
      errorBorder: _border(AppColor.disable),
    ),
  );
}
