import 'package:flutter/material.dart';
import 'package:zainusersapp/pages/contract_page.dart';
import '../models/complaint_model.dart';
import '../models/contract_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../utils.dart';
import '../widget/text_field_app.dart';


class NewContractPage extends StatefulWidget {
  const NewContractPage({Key? key}) : super(key: key);

  @override
  _NewContractPageState createState() => _NewContractPageState();
}

class _NewContractPageState extends State<NewContractPage> {

  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController buildCodeController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController commitmentDurationController = TextEditingController();
  TextEditingController customerSignatureController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();

  GlobalKey<FormState> newContractFormKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('انشاء عقد جديد'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: newContractFormKey,
          child: Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: Column(

              children: [
                TextFieldApp(
                  controller: customerNameController,
                  hintText: 'اسم العميل',
                  icon: const Icon(Icons.person),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) =>
                  str!.length < 10 ? 'الاسم من اربع مقاطع' : null,

                ),
                TextFieldApp(
                  controller: customerNumberController,
                  hintText: 'رقم العميل',
                  icon: const Icon(Icons.phone),
                  isRTL: true,
                  type: TextInputType.phone,
                  validator: (str) => str!.isEmpty ? 'رقم الموبايل غير صحيح' : null,
                ),
                TextFieldApp(
                  controller: buildCodeController,
                  hintText: 'رقم البناء',
                  icon: const Icon(Icons.home_filled),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال رقم البناء' : null,
                ),
                TextFieldApp(
                  controller: offerController,
                  hintText: 'العرض',
                  icon: const Icon(Icons.local_offer),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال العرض' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFieldApp(
                        controller: speedController,
                        hintText: 'السرعة',
                        icon: const Icon(Icons.speed),
                        isRTL: true,
                        type: TextInputType.phone,
                        validator: (str) => str!.isEmpty ? 'يرجى ادخال السرعة' : null,
                      ),
                    ),
                    Expanded(
                      child: TextFieldApp(
                        controller: commitmentDurationController,
                        hintText: 'مدة الالتزام',
                        icon: const Icon(Icons.access_time),
                        isRTL: true,
                        type: TextInputType.text,
                        validator: (str) => str!.isEmpty ? 'يرجى ادخال مدة الالتزام' : null,
                      ),
                    ),
                  ],
                ),
                TextFieldApp(
                  controller: customerSignatureController,
                  hintText: 'توقيع العميل',
                  icon: const Icon(Icons.drive_file_rename_outline),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال توقيع العميل' : null,
                ),
                TextFieldApp(
                  controller: employeeNameController,
                  hintText: 'اسم الموظف',
                  icon: const Icon(Icons.person_pin),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) =>
                  str!.length < 10 ? 'الاسم من اربع مقاطع' : null,
                ),
                Container(
                  width: getScreenWidth(context),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ElevatedButton(
                    child: const Text(
                      'انشاء عقد جديد',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: onCreateNewContract,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void onCreateNewContract()async{
    if (!newContractFormKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    String? customerName = customerNameController.text;
    String? customerNumber = customerNumberController.text;
    String? buildCode = buildCodeController.text;
    String? offer = offerController.text;
    String? speed = speedController.text;
    String? commitmentDuration = commitmentDurationController.text;
    String? customerSignature = customerSignatureController.text;
    String? employeeName = employeeNameController.text;

    ProgressCircleDialog.show(context);

    ContractModel contractModel = ContractModel();
    contractModel
      ..customerName = customerName
      ..customerNumber = customerNumber
      ..buildCode= buildCode
      ..offer = offer
      ..speed = speed
      ..commitmentDuration =commitmentDuration
      ..customerSignature = customerSignature
      ..employeeName = employeeName
      ..date = DateTime.now()
      ..userUid = Auth.currentUser!.uid
      ..user = Auth.currentUser;

    await Api.setContract(contractModel);
    onNewContract();


  }
  void onNewContract() {
    openNewPage(context, const ContractPage(),popPreviousPages: true);
  }


}
