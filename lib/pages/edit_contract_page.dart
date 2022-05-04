import 'package:flutter/material.dart';
import 'package:zainusersapp/pages/contract_page.dart';
import '../models/contract_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../utils.dart';
import '../widget/text_field_app.dart';


class EditContractPage extends StatefulWidget {
  final ContractModel? model;

  const EditContractPage({
    Key? key,
     this.model,
  }) : super(key: key);

  @override
  _EditContractPageState createState() => _EditContractPageState();
}

class _EditContractPageState extends State<EditContractPage> {
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController buildCodeController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController commitmentDurationController = TextEditingController();
  TextEditingController customerSignatureController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  String? modelId;

  GlobalKey<FormState> newContractFormKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      customerNameController.text = widget.model!.customerName!;
      customerNumberController.text = widget.model!.customerNumber!;
      buildCodeController.text = widget.model!.buildCode!;
      offerController.text = widget.model!.offer!;
      speedController.text = widget.model!.speed!;
      commitmentDurationController.text = widget.model!.commitmentDuration!;
      customerSignatureController.text = widget.model!.customerSignature!;
      employeeNameController.text = widget.model!.employeeName!;
      modelId =widget.model!.id;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل العقد'),
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
                  str!.isEmpty ? 'يرجى ادخال الاسم' : null,

                ),
                TextFieldApp(
                  controller: customerNumberController,
                  hintText: 'رقم العميل',
                  icon: const Icon(Icons.phone),
                  isRTL: true,
                  type: TextInputType.phone,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال رقم الموبايل' : null,
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
                        type: TextInputType.number,
                        validator: (str) => str!.isEmpty ? 'يرجى ادخال السرعة' : null,
                      ),
                    ),
                    Expanded(
                      child: TextFieldApp(
                        controller: commitmentDurationController,
                        hintText: 'مدة الالتزام',
                        icon: const Icon(Icons.access_time),
                        isRTL: true,
                        type: TextInputType.number,
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
                  str!.isEmpty ? 'يرجى ادخال اسم الموظف' : null,
                ),
                Container(
                  width: getScreenWidth(context),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ElevatedButton(
                    child: const Text(
                      'تعديل العقد',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: (){
                      onEditContract();
                    } ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void onEditContract()async{
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
    await Api.editContract(contractModel,modelId);
    ProgressCircleDialog.dismiss(context);
    Navigator.pop(context , true) ;




  }
  void onNewContract() {
    openNewPage(context, const ContractPage(),popPreviousPages: true);
  }


}
