import 'package:e_alert/auth/auth_service.dart';
import 'package:e_alert/pages/CDRRMO/CDRRMOmonitoring_page.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  String userType = '';
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    _fetchUserType();
  }

  Future<void> _fetchUserType() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? fetchedUserType = await _authService.getUserType(user.uid);
      setState(() {
        userType = fetchedUserType ?? 'UNKNOWN';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome, $userType!",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Colors.lightBlue,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              showTooltip: true,
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              selectedTitleTextStyleExpandable:
                  const TextStyle(color: Colors.lightBlue),
              selectedIconColorExpandable: Colors.lightBlue,
              arrowOpen: Colors.lightBlue,
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 200,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                title: 'Monitoring',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.home),
                tooltipContent: "Monitoring",
              ),
              SideMenuItem(
                title: 'Manage',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuExpansionItem(
                title: "Reports",
                icon: const Icon(Icons.assignment_late),
                children: [
                  SideMenuItem(
                    title: 'Today',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.announcement),
                    badgeContent: const Text(
                      '3',
                      style: TextStyle(color: Colors.white),
                    ),
                    tooltipContent: "Today",
                  ),
                  SideMenuItem(
                    title: 'Archived',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    icon: const Icon(Icons.inventory_2),
                    tooltipContent: "Archived",
                  )
                ],
              ),
              SideMenuItem(
                builder: (context, displayMode) {
                  return const Divider(
                    endIndent: 8,
                    indent: 8,
                  );
                },
              ),
              SideMenuItem(
                title: 'Exit',
                onTap: (index, _) async {
                  await _authService.signout();
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          const VerticalDivider(
            width: 0,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                _buildPage('Monitoring'),
                _buildPage('Manage'),
                _buildPage('Today'),
                _buildPage('Archived'),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title) {
    Object content = _getContentForPage(title);
    if (content is String) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Text(
            content,
            style: const TextStyle(fontSize: 35),
          ),
        ),
      );
    } else if (content is Widget) {
      return content;
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Object _getContentForPage(String page) {
    switch (userType) {
      case 'COMCEN':
        if (page == 'Monitoring') return 'COMCEN Monitoring Content';
        if (page == 'Manage') return 'COMCEN Manage Content';
        if (page == 'Today') return 'COMCEN Today Content';
        if (page == 'Archived') return 'COMCEN Archived Content';
        break;
      case 'CDRRMO':
        if (page == 'Monitoring') return const CDRRMOmonitoringPage();
        if (page == 'Manage') return 'CDRRMO Manage Content';
        if (page == 'Today') return 'CDRRMO Today Content';
        if (page == 'Archived') return 'CDRRMO Archived Content';
        break;
      // Add more user types if needed
      default:
        return 'Loading...';
    }
    return 'Default Content';
  }
}
