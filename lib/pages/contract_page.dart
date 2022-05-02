import 'package:flutter/material.dart';
import 'package:zainusersapp/models/contract_model.dart';

import '../export_feature.dart';
import '../models/complaint_model.dart';
import '../network/api.dart';
import 'edit_contract_page.dart';
import 'new_contract_page.dart';


class ContractPage extends StatefulWidget {
  const ContractPage({Key? key}) : super(key: key);

  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  List<ContractModel>? contractsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyContracts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العقود'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'انشاء عقد جديد',
        onPressed: onNewContract,
      ),
      body: contractsList != null
          ? ListView.builder(
          itemCount: contractsList!.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (_, index) {
            ContractModel model = contractsList![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: const <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            " العقد ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      contractsText(labels:'اسم العميل' ,text:model.customerName),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'رقم العميل' ,text:model.customerNumber),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'رقم البناء' ,text:model.buildCode),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'العرض' ,text:model.offer),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'مدة الالتزام' ,text:model.commitmentDuration),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'السرعة' ,text:model.speed),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'توقيع العميل' ,text:model.customerSignature),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'اسم الموظف' ,text:model.employeeName),
                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'التاريخ' ,text:dataFormat(date: model.date)),
                      const SizedBox(
                        height: 6.0,
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
                            onEditContract(model: model);
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
          : getCenterCircularProgress(),
    );
  }
  Widget contractsText({dynamic text, String? labels}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$text',
        ),
        Text(
          '$labels : ',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),

        ),
      ],
    );
  }
  void loadMyContracts() async {
    contractsList = await Api.getContracts();
    setState(() {});
  }

  Widget getStatus(ComplaintModel model) {

    if(model.complaintStatus == ComplaintStatus.Pending){
      return const Text('قيد الانتظار' ,
        style: TextStyle(
          color:  Colors.yellow,
          fontWeight: FontWeight.bold,
        ),);
    }

    else if(model.complaintStatus == ComplaintStatus.InProgress){
      return const Text('قيد المعالجة',
        style: TextStyle(
          color:  Colors.blue,
          fontWeight: FontWeight.bold,
        ),);
    }

    else if(model.complaintStatus == ComplaintStatus.Completed){
      return const Text('تمة المعالجة',
        style: TextStyle(
          color:  Colors.green,
          fontWeight: FontWeight.bold,
        ),);
    }

    else if(model.complaintStatus == ComplaintStatus.Canceled){
      return  const Text('ملغي',
        style: TextStyle(
          color:  Colors.red,
          fontWeight: FontWeight.bold,
        ),);
    }

    return const SizedBox() ;
  }

  void onNewContract() {
    openNewPage(context, const NewContractPage());
  }
   void onEditContract({ContractModel? model}) {
    openNewPage(context,EditContractPage(model: model,));
  }
}
