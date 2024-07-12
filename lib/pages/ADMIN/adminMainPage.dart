import 'package:e_alert/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    super.initState();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome, Admin!", style: TextStyle(color: Colors.white),),
        centerTitle: false,
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 200,
                  ),
                  child: Image.asset('assets/logo.png'),
                ),
                const Divider(indent: 8.0, endIndent: 8.0),
              ],
            ),
            items: [
              SideMenuItem(
                title: 'User Accounts',
                onTap: (index, _) => sideMenu.changePage(index),
                icon: const Icon(Icons.supervisor_account),
                tooltipContent: "User Accounts Management",
              ),
              SideMenuItem(
                title: 'Barangay',
                onTap: (index, _) => sideMenu.changePage(index),
                icon: const Icon(Icons.location_pin),
                tooltipContent: "Barangay Names",
              ),
              SideMenuItem(
                title: 'Risk Levels',
                onTap: (index, _) => sideMenu.changePage(index),
                icon: const Icon(Icons.warning),
                tooltipContent: "Flood Risk Levels",
              ),
              SideMenuItem(
                builder: (context, displayMode) => const Divider(indent: 8, endIndent: 8),
              ),
              SideMenuItem(
                title: 'Exit',
                onTap: (index, _) async {
                  await AuthService().signout();
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const LoginPage()),
                  // );
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          const VerticalDivider(width: 0),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                _buildPage('User Accounts'),
                _buildPage('Barangay'),
                _buildPage('Risk Levels'),
                const SizedBox.shrink(), // Placeholder for the divider
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 35),
        ),
      ),
    );
  }
}
