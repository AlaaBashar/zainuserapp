import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zainusersapp/pages/splash_page.dart';
import 'package:zainusersapp/pages/suggestions_page.dart';
import 'package:zainusersapp/pages/user_details_page.dart';
import '../export_feature.dart';
import '../models/areas_model.dart';
import '../models/ministries_model.dart';
import '../models/user_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../widget/reusable_cached_network_image.dart';
import 'contract_page.dart';
import 'my_visits_page.dart';
import 'offers_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MinistriesModel>? ministriesList;
  List<AreasModel>? areasList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAreas();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE8E8E8),
        endDrawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text('الصفحة الرئيسية'),
        ),
        body: areasList != null
            ? GridView.builder(
                itemCount: areasList!.length,
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.1),
                itemBuilder: (_, index) {
                  AreasModel model = areasList![index];
                  return Card(
                    elevation: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${model.state}',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : getCenterCircularProgress());
  }

  void loadAreas() async {
    areasList = await Api.getAreas();
    setState(() {});
  }
}

class NavDrawer extends StatefulWidget {

  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  List<UserApp>? userAppList;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: ()=> openNewPage(context, const UserDetailsPage()),
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const Spacer(flex: 1,),

                      const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                      const Spacer(flex: 1,),
                      Text(
                        "${Auth.currentUser!.name}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(flex: 4,),

                    ],
                  ),
                  Text(
                    "${Auth.currentUser!.email}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),

                ],
              ),
            ),
          ),
          ListTile(
            title: const Text("العروض"),
            leading: IconButton(
              icon: const Icon(
                Icons.apps_outlined,
              ),
              onPressed: () {
                //Navigator.of(context).pop();
              },
            ),
            onTap: onOffer,
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("انشاء و عرض عقودي"),
            leading: IconButton(
              icon: const Icon(
                Icons.contact_mail,
              ),
              onPressed: () {
                //Navigator.of(context).pop();
              },
            ),
            onTap: getContract,
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("الاقتراحات"),
            leading: IconButton(
              icon: const Icon(Icons.book_outlined),
              onPressed: () {},
            ),
            onTap: onSuggestions,
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("انشاء زيارة جديدة"),
            leading: IconButton(
              icon: const Icon(Icons.drive_file_rename_outline),
              onPressed: () {},
            ),
            onTap: onVisit,
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("تسجيل الخروج"),
            leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {},
            ),
            onTap: onLogout,
          )
        ],
      ),
    );
  }

  void onLogout() async {
    ProgressCircleDialog.show(context);
    await Auth.logout();
    ProgressCircleDialog.dismiss(context);

    openNewPage(context, const SplashPage());
  }

  void onSuggestions() {
    openNewPage(context, const SuggestionsPage());
  }
  void onVisit() {
    openNewPage(context, const MyVisitPage());
  }

  void onOffer() {
    openNewPage(context, const OffersPage());
  }

  void getContract() {
    openNewPage(context, const ContractPage());
  }


}
