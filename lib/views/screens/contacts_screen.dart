import 'package:contacts_manager/utils/app_constants.dart';
import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';

enum MenuItem { logout, profile }

class ContactsScreen extends StatelessWidget {
  ContactsScreen({super.key});

  MenuItem? selectedValue;

  final logoutSnackBar = const SnackBar(
    content: Text('Logging out'),
    elevation: 5,
    margin: EdgeInsets.symmetric(horizontal: 20),
    backgroundColor: Palette.activeCardColor,
    behavior: SnackBarBehavior.floating,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Card(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                elevation: 5,
                child: ListTile(
                  leading: const CircleAvatar(
                    child: FlutterLogo(
                        size:
                            30), //todo replace with cachednetwork image or contact's icon
                  ),
                  title: Text(
                    'Profile Name',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'No. of contacts',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  trailing: PopupMenuButton<MenuItem>(
                    onSelected: (MenuItem item) => item == MenuItem.profile
                        ? Navigator.pushNamed(context, AppRoutes.profile)
                        : ScaffoldMessenger.of(context)
                            .showSnackBar(logoutSnackBar),
                    initialValue: selectedValue,
                    itemBuilder: (context) => <PopupMenuEntry<MenuItem>>[
                      const PopupMenuItem(
                        value: MenuItem.profile,
                        child: Text('Show profile'),
                      ),
                      const PopupMenuItem(
                        value: MenuItem.logout,
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          //todo: update contact details
                          Navigator.pushNamed(context, AppRoutes.profile);
                        },
                        leading: const CircleAvatar(
                          child: FlutterLogo(size: 20),
                        ),
                        title: Text(
                          'Jane Doe',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          '+254722000111',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            //todo: delete contact
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 25,
                        color: Palette.dashTileColor,
                      );
                    },
                    itemCount: 10),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.contact),
        child: const Icon(
          Icons.add,
          color: Palette.primaryColor,
        ),
      ),
    );
  }
}
