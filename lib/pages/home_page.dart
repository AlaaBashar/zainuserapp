import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zainusersapp/pages/splash_page.dart';
import 'package:zainusersapp/pages/suggestions_page.dart';
import '../export_feature.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMinistries();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE8E8E8),
        endDrawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text('الصفحة الرئيسية'),
        ),
        body: ministriesList != null
            ? GridView.builder(

                itemCount: ministriesList!.length,
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.1),
                itemBuilder: (_, index) {
                  MinistriesModel model = ministriesList![index];
                  return Card(
                    elevation: 8,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child: ReusableCachedNetworkImage(
                            imageUrl: model.imageUrl!,
                            height: 70,
                            width: 70,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          '${model.title}',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.0,
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

  void loadMinistries() async {
    ministriesList = await Api.getMinistries();
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
    getUserData();
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Row(
                children: const [
                  Expanded(
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      "Write anything",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
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
  void getUserData() async{
    userAppList = (await Api.getUserFromUid(FirebaseAuth.instance.currentUser!.uid)) as List<UserApp>?;
    setState(() {});

  }

}
