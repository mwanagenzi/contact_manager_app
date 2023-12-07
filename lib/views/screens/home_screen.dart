import 'package:contacts_manager/views/providers/navbar_tab_manager.dart';
import 'package:contacts_manager/views/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> appPages = [
    const ContactsScreen(),
    const FavouritesScreen(),
    const RecentsScreen(),
    ContactGroupsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavbarTabManager>(
      builder: ((context, navbarTabManager, child) {
        return Scaffold(
          body: IndexedStack(
            index: navbarTabManager.selectedTab,
            children: appPages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              navbarTabManager.goToTab(index);
            },
            currentIndex: navbarTabManager.selectedTab,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.contacts), label: 'Contacts'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star), label: 'Favorites'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.schedule), label: 'Recents'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.groups_outlined), label: 'Groups'),
            ],
          ),
        );
      }),
    );
  }
}
