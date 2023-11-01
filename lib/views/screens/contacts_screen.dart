import 'package:contacts_manager/utils/app_constants.dart';
import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

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
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                elevation: 5,
                child: ListTile(
                  leading: const CircleAvatar(
                    child: FlutterLogo(
                        size:
                            50), //todo replace with cachednetwork image or contact's icon
                  ),
                  title: Text(
                    'Profile Name',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'No. of contacts',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },

                  // RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(15)),
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
                        trailing: const Icon(
                          Icons.call,
                          color: Colors.white,
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
    );
  }
}
