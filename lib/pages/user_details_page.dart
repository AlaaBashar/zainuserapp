import 'package:flutter/material.dart';
import 'package:zainusersapp/models/user_model.dart';
import 'package:zainusersapp/network/auth.dart';
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
      appBar: AppBar(
        title: const Text('بيانات المستخدم'),
      ),
      body: Column(
        children: [
          TextFieldApp(
            controller: employeeNameController,
            hintText: 'اسم المستخدم',
            icon: const Icon(Icons.person),
            isRTL: true,
            enableInput: false,
            type: TextInputType.text,
            validator: (str) =>
            str!.length < 10 ? 'الاسم من اربع مقاطع' : null,
          ),
          TextFieldApp(
            enableInput: false,
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
            enableInput: false,
            isRTL: true,
            type: TextInputType.number,
            validator: (str) => str!.isEmpty ? 'يرجى ادخال رقم المستخدم' : null,
          ),
          TextFieldApp(
            enableInput: false,
            controller: employeeIDController,
            hintText: 'الرقم الوطني',
            icon: const Icon(Icons.person_pin),
            isRTL: true,
            type: TextInputType.text,
            validator: (str) =>
            str!.length < 10 ? 'الرقم غير صحيح' : null,
          ),
          const SizedBox(height: 10.0,),
          employeeGenderController.text == 'Gender.Male' ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 45.0,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
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
              children: const [
                Icon(Icons.male,),
                SizedBox(width: 15.0,),
                Text(
                  'ذكر',
                  style: TextStyle(
                      fontSize: 15,
                  ),
                ),
                Spacer(
                  flex: 4,
                ),
              ],
            ),
          ) :Container(
            height: 45.0,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
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
              children: const [
                Icon(Icons.female,),
                SizedBox(width: 15.0,),
                Text(
                  'انثى',
                  style: TextStyle(fontSize: 15,),
                ),
                Spacer(
                  flex: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
