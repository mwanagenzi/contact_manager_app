import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';

class ContactGroupsScreen extends StatelessWidget {
  const ContactGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Groups'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Group Name',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Text(
                  'No. of contacts in group',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                onTap: () {
                  //todo: update contact details
                  Navigator.pushNamed(context, AppRoutes.group);
                },
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          elevation: 5,
          child: const Icon(
            Icons.add,
            color: Palette.primaryColor,
          )),
    );
  }
}
