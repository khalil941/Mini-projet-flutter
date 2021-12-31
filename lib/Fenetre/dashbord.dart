import 'package:flutter/material.dart';
import 'package:jareb/Fenetre/crudComposant.dart';
import 'package:jareb/Fenetre/crudMembre.dart';
import 'Presentation.dart';
import 'crudFamille.dart';
import 'crudComposant.dart';
import 'my_drawer_header.dart';


enum DrawerSections {
  Presentation,
  contacts,
  composants,
  membres

}
class Dash extends StatefulWidget {
  const Dash({Key? key}) : super(key: key);

  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  var currentPage = DrawerSections.Presentation;

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Container(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.Presentation;
            } else if (id == 2) {
              currentPage = DrawerSections.contacts;
            }
                         else if (id == 3) {
              currentPage = DrawerSections.composants;
} else if (id == 4) {
         currentPage = DrawerSections.membres;
           } //else if (id == 5) {
//              currentPage = DrawerSections.settings;
//            } else if (id == 6) {
//              currentPage = DrawerSections.notifications;
//            } else if (id == 7) {
//              currentPage = DrawerSections.privacy_policy;
//            } else if (id == 8) {
//              currentPage = DrawerSections.send_feedback;
//            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.Presentation ? true : false),
          menuItem(2, "Contacts", Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts ? true : false),
         menuItem(3, "Events", Icons.event,
              currentPage == DrawerSections.composants ? true : false),
          menuItem(4, "Notes", Icons.notes,
             currentPage == DrawerSections.membres ? true : false),
//          Divider(),
//          menuItem(5, "Settings", Icons.settings_outlined,
//              currentPage == DrawerSections.settings ? true : false),
//          menuItem(6, "Notifications", Icons.notifications_outlined,
//              currentPage == DrawerSections.notifications ? true : false),
//          Divider(),
//          menuItem(7, "Privacy policy", Icons.privacy_tip_outlined,
//              currentPage == DrawerSections.privacy_policy ? true : false),
//          menuItem(8, "Send feedback", Icons.feedback_outlined,
//              currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.Presentation) {
      container = PresnetationPage();
    } else if (currentPage == DrawerSections.contacts) {
      container = Crud();}
else if (currentPage == DrawerSections.composants) {
    container = Crudcom();}
     else if (currentPage == DrawerSections.membres) {
      container = Crudmem();}
//    } else if (currentPage == DrawerSections.settings) {
//      container = SettingsPage();
//    } else if (currentPage == DrawerSections.notifications) {
//      container = NotificationsPage();
//    } else if (currentPage == DrawerSections.privacy_policy) {
//      container = PrivacyPolicyPage();
//    } else if (currentPage == DrawerSections.send_feedback) {
//      container = SendFeedbackPage();
//    }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: Text("Rapid Tech"),
        ),
        body: container,
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  MyHeaderDrawer(),
                  MyDrawerList(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }


