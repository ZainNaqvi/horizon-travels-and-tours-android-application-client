import 'package:firebase_core/firebase_core.dart';
import 'package:horizon_travel_and_tours_android_application/firebase_options.dart';

import 'exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
      BlocProvider<FindTourCubit>(create: (context) => FindTourCubit()),
      BlocProvider<CommonCubit>(create: (context) => CommonCubit(DbHelper())),
    ],
    child: const MainApp(),
  ));
}
