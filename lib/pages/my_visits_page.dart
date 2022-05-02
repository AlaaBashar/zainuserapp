import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zainusersapp/models/areas_model.dart';
import '../export_feature.dart';
import '../models/complaint_model.dart';
import '../models/visits_model.dart';
import '../network/api.dart';
import 'create_new_visit_page.dart';

class MyVisitPage extends StatefulWidget {
  AreasModel? areasModel;
    MyVisitPage({Key? key,required this.areasModel}) : super(key: key);

  @override
  _MyVisitPageState createState() => _MyVisitPageState();
}

class _MyVisitPageState extends State<MyVisitPage> {
  List<VisitsModel>? visitsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الزيارات'),
      ),
      floatingActionButton: !widget.areasModel!.isBlocked! ? FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'انشاء زيارة جديدة',
        onPressed: ()=>onNewVisit(areasModel: widget.areasModel),
      ):null,
      body: visitsList != null
          ? ListView.builder(
              itemCount: visitsList!.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (_, index) {
                VisitsModel model = visitsList![index];
                return Container(
                  child: model.areaId == widget.areasModel!.id? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: const <Widget>[
                                Expanded(child: Divider()),
                                Text(
                                  " الزيارة ",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            visitText(labels:'الاسم الاول' ,text:model.firstName),
                            const SizedBox(height: 8.0),
                            visitText(labels:'الاسم الثاني' ,text:model.secondName),
                            const SizedBox(height: 8.0),
                            visitText(labels:'الاسم الثالث' ,text:model.thirdName),
                            const SizedBox(height: 8.0),
                            visitText(labels:'ID' ,text:model.id),
                            const SizedBox(height: 8.0),
                            visitText(labels:'ID No' ,text:model.idType),
                            const SizedBox(height: 8.0),
                            visitText(labels:'تاريخ الميلاد' ,text:model.dateOfBirth),
                            const SizedBox(height: 8.0),
                            visitText(labels:'الجنس' ,text:model.gender),
                            const SizedBox(height: 8.0),
                            visitText(labels:'الجنسية' ,text:model.nationality),
                            const SizedBox(height: 8.0),
                            visitText(labels:'internet usage' ,text:model.internetUsage),
                            const SizedBox(height: 8.0),
                            visitText(labels:'مدة الألتزام' ,text:model.commitmentDuration),
                            const SizedBox(height: 8.0),
                            visitText(labels:'السعر لكل شهر' ,text:model.pricePerMonth),
                            const SizedBox(height: 8.0),
                            visitText(labels:'نهاية الزيارة' ,text:model.endVisit),

                          ],
                        ),
                      ),
                    ),
                  ):null,
                );
              })
          : getCenterCircularProgress(),
    );
  }

  Widget visitText({dynamic text, String? labels}) {
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

  void loadMyVisits() async {
    visitsList = await Api.getVisits();
    setState(() {});
  }

  Widget getStatus(ComplaintModel model) {
    if (model.complaintStatus == ComplaintStatus.Pending) {
      return const Text(
        'قيد الانتظار',
        style: TextStyle(
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (model.complaintStatus == ComplaintStatus.InProgress) {
      return const Text(
        'قيد المعالجة',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (model.complaintStatus == ComplaintStatus.Completed) {
      return const Text(
        'تمة المعالجة',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (model.complaintStatus == ComplaintStatus.Canceled) {
      return const Text(
        'ملغي',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return const SizedBox();
  }

  void onNewVisit({AreasModel? areasModel}) {
    openNewPage(context,  NewVisitPage(areasModel: areasModel,));
  }
}
