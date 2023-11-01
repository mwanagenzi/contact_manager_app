import 'package:contacts_manager/utils/app_constants.dart';
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: FlutterLogo(
                        size: 50), //todo replace with cachednetwork image
                  ),
                  title: Text(
                    'Profile Name',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  subtitle: Text(
                    'No. of contacts',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              flex: 6,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: FlutterLogo(size: 20),
                      ),
                      title: Text(
                        'Jane Doe',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        '+254722000111',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      trailing: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 15);
                  },
                  itemCount: 10),
            ),
          ],
        ),
      ),
    );
  }
}
