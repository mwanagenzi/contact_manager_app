import 'package:flutter/material.dart';

import '../theme/color_palette.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                onLongPress: () {
                  //highlight the contact
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
                    //todo: delete contact from group
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
    );
  }
}
