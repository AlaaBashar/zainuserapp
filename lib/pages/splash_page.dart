import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../export_feature.dart';

import '../helper/image_helper.dart';
import '../models/user_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import 'home_page.dart';
import 'login_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(
        seconds: 1,
      ),
    ).then(
      (value) => checkLoginUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent,),);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageHelper.logo,
            width: 150.0,
            height: 150.0,
          ),
          const SizedBox(
            height: 16.0,
          ),
          getCenterCircularProgress(),
        ],
      ),
    );
  }

  void checkLoginUser() async {
    UserApp? user = await Auth.getUserFromPref();

    if (user == null) {
      openNewPage(context, const LoginPage(), popPreviousPages: true);
    }
    else {
      UserApp? userLogin = await Api.getUserFromUid(user.uid ?? '');

      if (userLogin == null) return;

      if (userLogin.isBlocked!) {
        showSnackBar(context , 'الرجاء التواصل مع الدعم الفني لتفعيل حسابك');
        await Auth.logout();
        openNewPage(context, const LoginPage(), popPreviousPages: true);
        return;
      }

      await Auth.updateUserInPref(userLogin);

      openNewPage(context, const HomePage(), popPreviousPages: true);
    }
  }
}
