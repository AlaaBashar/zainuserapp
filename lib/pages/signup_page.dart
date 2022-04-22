import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../export_feature.dart';
import '../helper/image_helper.dart';
import '../models/user_model.dart';
import '../network/auth.dart';
import '../widget/text_field_app.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> signUpFormKey = GlobalKey();

  Gender genderSelected = Gender.Male;

  bool showPassword = false, showConfirmPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('انشاء حساب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: signUpFormKey,
          child: Column(
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  ImageHelper.logo,
                  width: 150.0,
                  height: 150.0,
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              TextFieldApp(
                controller: nameController,
                hintText: 'الاسم كامل',
                icon: const Icon(Icons.person),
                type: TextInputType.name,
                validator: (str) =>
                    str!.length < 10 ? 'الاسم من اربع مقاطع' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFieldApp(
                      controller: idController,
                      hintText: 'الرقم الوطني',
                      icon: const Icon(Icons.code),
                      type: TextInputType.number,
                      isRTL: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))
                      ],
                      maxLength: 10,
                      validator: (str) =>
                          str!.length != 10 ? 'الرقم الوطني غير صحيح' : null,
                    ),
                  ),
                  Expanded(
                    child: TextFieldApp(
                      controller: phoneController,
                      hintText: 'رقم الموبايل',
                      icon: const Icon(Icons.phone),
                      isRTL: false,
                      type: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$'))
                      ],
                      maxLength: 10,
                      validator: (str) =>
                          str!.length != 10 ? 'رقم الموبايل غير صحيح' : null,
                    ),
                  ),
                ],
              ),
              TextFieldApp(
                controller: emailController,
                hintText: 'البريد الالكتروني',
                icon: const Icon(Icons.email),
                isRTL: false,
                type: TextInputType.emailAddress,
                validator: (str) => !isValidEmail(str!.trim())
                    ? 'البريد الالكتروني غير صحيح'
                    : null,
              ),
              TextFieldApp(
                controller: passwordController,
                hintText: 'الرمز السري',
                icon: const Icon(Icons.vpn_key),
                obscureText: !showPassword,
                isRTL: false,
                validator: (str) => str!.isEmpty
                    ? 'الرمز السري غير صحيح'
                    : str.length < 6
                        ? 'كلمة المرور ضعيفة ، يجب أن تكون كلمة المرور 6 أحرف على الأقل'
                        : null,
                type: TextInputType.visiblePassword,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  child: showPassword
                      ? const Icon(Icons.visibility_off_outlined)
                      : const Icon(Icons.visibility_outlined),
                ),
              ),
              TextFieldApp(
                controller: confirmPassController,
                hintText: 'اعادة الرمز السري',
                icon: const Icon(Icons.vpn_key),
                obscureText: !showConfirmPass,
                isRTL: false,
                validator: (str) => str != passwordController.text
                    ? 'لا يوجد تطابق في كلمة السر'
                    : null,
                type: TextInputType.visiblePassword,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      showConfirmPass = !showConfirmPass;
                    });
                  },
                  child: showConfirmPass
                      ? const Icon(Icons.visibility_off_outlined)
                      : const Icon(Icons.visibility_outlined),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: onPressedMale,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 45.0,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: genderSelected == Gender.Male
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset:
                                  const Offset(0, 2), // changes position of shadow
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.male,
                                color: genderSelected == Gender.Male
                                    ? Colors.blueAccent
                                    : Colors.grey),
                            const Spacer(),
                            Text(
                              'ذكر',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: genderSelected == Gender.Male
                                      ? Colors.blueAccent
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color),
                            ),
                            const Spacer(
                              flex: 4,
                            ),
                          ],
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: onPressedFemale,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 45.0,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: genderSelected == Gender.Female
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              width: 1),
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset:
                                  const Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.female,
                                color: genderSelected == Gender.Female
                                    ? Colors.blueAccent
                                    : Colors.grey),
                            const Spacer(),
                            Text(
                              'انثى',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: genderSelected == Gender.Female
                                      ? Colors.blueAccent
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color),
                            ),
                            const Spacer(
                              flex: 4,
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Container(
                width: getScreenWidth(context),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ElevatedButton(
                  child: const Text(
                    'انشاء حساب',
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: onCreateAccount,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressedMale() {
    genderSelected = Gender.Male;

    setState(() {});
  }

  void onPressedFemale() {
    genderSelected = Gender.Female;

    setState(() {});
  }

  void onCreateAccount() async{
    if (!signUpFormKey.currentState!.validate()) return;
    ProgressCircleDialog.show(context);
    String name = nameController.text;
    String id = idController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String password = passwordController.text;

    UserApp userApp = UserApp(
        id: id,
        uid: '',
        name: name,
        date: DateTime.now(),
        gender: genderSelected,
        email: email,
        password: password,
        phone: phone);

   UserApp? response =  await Auth.signUpByEmailAndPass(userApp: userApp ,
   email: email ,password: password)
       .catchError((onError){
      showSnackBar(context, onError.toString());
    });
    ProgressCircleDialog.dismiss(context);


    if(response == null) {
      return;
    }

    openNewPage(context , const HomePage() , popPreviousPages: true);
  }
}
