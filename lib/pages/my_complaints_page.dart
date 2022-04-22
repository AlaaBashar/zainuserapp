import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../export_feature.dart';

import '../models/complaint_model.dart';
import '../network/api.dart';
import '../widget/reusable_cached_network_image.dart';


class MyComplaintsPage extends StatefulWidget {
  const MyComplaintsPage({Key? key}) : super(key: key);

  @override
  _MyComplaintsPageState createState() => _MyComplaintsPageState();
}

class _MyComplaintsPageState extends State<MyComplaintsPage> {
  List<ComplaintModel>? complaintList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' جديد'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'انشاء عقد جديد',
        onPressed: () {},
      ),
      body: complaintList != null
          ? ListView.builder(
              itemCount: complaintList!.length,
              padding: const EdgeInsets.all(8.0),

              itemBuilder: (_, index) {
                ComplaintModel model = complaintList![index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const <Widget>[
                              Expanded(child: Divider()),
                              Text(
                                " الشكوى ",
                                style: TextStyle(
                                    color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          Text('عنوان الشكوى : ${model.title}'),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text('تفاصيل الشكوى : ${model.des}'),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text('التاريخ : ${DateFormat('yyyy/MM/hh  hh:mm a').format(model.date!)}'),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: const <Widget>[
                              Expanded(child: Divider()),
                              Text(
                                " تفاصيل الوزارة ",
                                style: TextStyle(
                                    color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_sharp,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text('اسم الوزارة : ${model.ministriesTitle}')
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: const <Widget>[
                              Expanded(child: Divider()),
                              Text(
                                " حالة الشكوى ",
                                style: TextStyle(
                                    color: Colors.orange, fontWeight: FontWeight.bold),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('حالة الشكوى : '),
                              getStatus(model),
                            ],
                          ),
                          const Divider(),
                          ReusableCachedNetworkImage(
                            imageUrl: model.imageUrl!,
                            width: double.infinity,
                            height: 100,
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

  void loadMyComplaints() async {
    complaintList = await Api.getComplaints();
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
}
