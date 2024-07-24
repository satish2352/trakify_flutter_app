import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/screens/contact_us.dart';
import 'package:trakify/screens/sign_in.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/theme_provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key,});
  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  late String? userName='';
  late String initials='';

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      initials = getInitials(userName!);
    });
  }

  String getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      String initials = parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
      return initials;
    } else {
      return '';
    }
  }

  String getEmailInitials(String email) {
    List<String> parts = email.split('@');
    if (parts.length == 2) {
      String initials = parts[0][0].toUpperCase();
      if (parts[1].contains('.')) {
        List<String> domainParts = parts[1].split('.');
        if (domainParts.length >= 2) {
          initials += domainParts[0][0].toUpperCase();
        }
      }
      return initials;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width*0.9,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(initials, style: const TextStyle(fontFamily: 'OpenSans', fontSize: 25, color: Colors.black),),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName!,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  /* kept this empty for user
                  Text(
                    userName!,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  */
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Themes', style: TextStyle(fontFamily: 'OpenSans', fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.only(right:  15.0, left:  15.0, bottom: 15.0,),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        Provider.of<ThemeProvider>(context, listen: false).setThemeMode(ThemeModeType.light);
                      }, icon: Icon(Icons.light_mode_outlined,
                        color: Provider.of<ThemeProvider>(context).themeMode == ThemeModeType.light ? Colors.blue : null,
                      )),
                      Text('Light', style: TextStyle(fontFamily: 'OpenSans',color: Theme.of(context).primaryColorDark)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        Provider.of<ThemeProvider>(context, listen: false).setThemeMode(ThemeModeType.dark);
                      }, icon: Icon(Icons.dark_mode_outlined,
                        color: Provider.of<ThemeProvider>(context).themeMode == ThemeModeType.dark ? Colors.blue : null,
                      )),
                      Text('Dark', style: TextStyle(fontFamily: 'OpenSans', color: Theme.of(context).primaryColorDark)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        Provider.of<ThemeProvider>(context, listen: false).setThemeMode(ThemeModeType.system);
                      }, icon: Icon(Icons.settings,
                        color: Provider.of<ThemeProvider>(context).themeMode == ThemeModeType.system ? Colors.blue : null,
                      )),
                      Text('System', style: TextStyle(fontFamily: 'OpenSans', color: Theme.of(context).primaryColorDark)),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              trailing: const Icon(Icons.contact_support),
              title: const Text('Contact Us', style: TextStyle(fontFamily: 'OpenSans',),),
              onTap: () {
                Navigator.push(context, CustomPageRoute(nextPage: const ContactUs(), direction: -1));
              },
            ),
            ListTile(
              trailing: const Icon(Icons.logout_outlined),
              title: const Text('Logout', style: TextStyle(fontFamily: 'OpenSans',),),
              onTap: () {
                NetworkUtil.checkConnectionAndProceed(context, () {
                  DialogManager.showQuestionDialog(context, 'Sign Out', () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushAndRemoveUntil(context, CustomPageRoute(nextPage: const SignInPage(), direction: -1), (route)=>false);
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showBottomDrawer(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return const NavBar();
    },
  );
}