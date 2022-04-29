import 'package:flutter/material.dart';
import 'package:zainusersapp/models/user_model.dart';
import 'package:zainusersapp/network/auth.dart';

import '../utils.dart';
import '../widget/text_field_app.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController employeeEmailController = TextEditingController();
  TextEditingController employeePhoneController = TextEditingController();
  TextEditingController employeeGenderController = TextEditingController();
  TextEditingController employeeIDController = TextEditingController();
  UserApp? userApp = Auth.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      employeeNameController.text =userApp!.name!;
      employeeEmailController.text =userApp!.email!;
      employeePhoneController.text =userApp!.phone!;
      employeeGenderController.text =userApp!.gender!.toString();
      employeeIDController.text =userApp!.id!;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Column(

        children: [
          TextFieldApp(
            controller: employeeNameController,
            hintText: 'اسم المستخدم',
            icon: const Icon(Icons.person),
            isRTL: true,
            type: TextInputType.text,
            validator: (str) =>
            str!.length < 10 ? 'الاسم من اربع مقاطع' : null,

          ),
          TextFieldApp(
            controller: employeeEmailController,
            hintText: 'حساب المستخدم',
            icon: const Icon(Icons.email_outlined),
            isRTL: true,
            type: TextInputType.phone,
            validator: (str) => str!.isEmpty ? 'رقم الموبايل غير صحيح' : null,
          ),
          TextFieldApp(
            controller: employeePhoneController,
            hintText: 'رقم المستخدم',
            icon: const Icon(Icons.phone),
            isRTL: true,
            type: TextInputType.number,
            validator: (str) => str!.isEmpty ? 'يرجى ادخال رقم المستخدم' : null,
          ),
          TextFieldApp(
            controller: employeeGenderController,
            hintText: 'الجنس',
            icon: const Icon(Icons.wc),
            isRTL: true,
            type: TextInputType.text,
            validator: (str) => str!.isEmpty ? 'يرجى ادخال الجنس' : null,
          ),
          TextFieldApp(
            controller: employeeIDController,
            hintText: 'الرقم الوطني',
            icon: const Icon(Icons.person_pin),
            isRTL: true,
            type: TextInputType.text,
            validator: (str) =>
            str!.length < 10 ? 'الرقم غير صحيح' : null,
          ),

          // Container(
          //   width: getScreenWidth(context),
          //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          //   child: ElevatedButton(
          //     child: const Text(
          //       'تعديل بيانات المستخدم',
          //       style: TextStyle(
          //           fontSize: 18.0, fontWeight: FontWeight.bold),
          //     ),
          //     onPressed: (){
          //     } ,
          //   ),
          // ),
        ],
      ),
    );
  }
}
