import 'package:flutter/material.dart';
import 'package:kchat/Providers/ChatsProvider.dart';
import 'package:kchat/Providers/CurrentUserProvider.dart';
import 'package:kchat/Providers/GroupsProvider.dart';
import 'package:kchat/Providers/KSpyProvider.dart';
import 'package:kchat/Providers/UsersProvider.dart';
import 'package:kchat/custom_themes/theme_constants.dart';
import 'package:kchat/screens/AuthScreens/login_screen.dart';
import 'package:kchat/Providers/UserStatusProvider.dart';
import 'package:kchat/screens/ChatsAndProfiles/PersonalScreens/KChats.dart';
import 'package:kchat/screens/DrawerScreens/EditUserProfile/EditUserProfile.dart';
import 'package:kchat/services/k_jwt.dart';
import 'package:provider/provider.dart';
import 'services/ws_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await getToken();
  runApp(MyApp(isAuthTokenExist: token == null ? false : true));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isAuthTokenExist});

  final bool isAuthTokenExist;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WS_Manager()),
          ChangeNotifierProvider(create: (_) => UserStatusProvider()),
          ChangeNotifierProvider(create: (_) => ChatsProvider()),
          ChangeNotifierProvider(create: (_) => CurrentUserProvider()),
          ChangeNotifierProvider(create: (_) => GroupsProvider()),
          ChangeNotifierProvider(create: (_) => UsersProvider()),
          ChangeNotifierProvider(create: (_) => KSpyProvider())
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          // TODO: refactor
          home: isAuthTokenExist ? KChats() : LoginScreen(),
          darkTheme: kDarkTheme,
          themeMode: ThemeMode.dark,
          routes: {
            '/edit_user_profile': (context) => EditUserProfile()
          },
        ),
      ),
    );
  }
}
