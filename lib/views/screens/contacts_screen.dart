import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_manager/utils/app_constants.dart';
import 'package:contacts_manager/views/theme/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Contact.dart';

enum MenuItem { logout, profile }

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String? _username, _email;
  MenuItem? selectedValue;

  Future<void> _syncContacts() async {
    await getAllContacts();
  }

  Future<void> deleteContact(int? contactId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    try {
      http.Response response = await http.get(
          Uri.parse('${AppConstants.BASE_URL}/delete/$contactId'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        if (jsonMap['success']) {
          ScaffoldMessenger.of(context)
              .showSnackBar(_showSuccessSnackBar(jsonMap['message']));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(_showErrorSnackBar(jsonMap['message']));
        }
      } else {
        var errorResponse = response.body;
        debugPrint("response error code : ${response.statusCode} \n"
            "response body : $errorResponse");
        ScaffoldMessenger.of(context).showSnackBar(
            //todo: sort lint context rule later
            _showErrorSnackBar('Server error. Try again later'));
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar('Check your internet connection then try again'));
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    getUserCredentials();
    super.initState();
  }

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
                      child: Icon(
                    Icons.person,
                    size: 30,
                  )),
                  title: Text(
                    _username ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    _email ?? 'Unknown email address',
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
                child: FutureBuilder(
                  future: getAllContacts(),
                  builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: Text(
                            'At none',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      case ConnectionState.waiting:
                        return const Center(
                          child: SpinKitFadingCircle(
                            color: Palette.activeCardColor,
                          ),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final contacts = snapshot.data;
                        return RefreshIndicator(
                          onRefresh: () {
                            setState(() {});
                            return _syncContacts();
                          },
                          child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    maxRadius: 20,
                                    minRadius: 10,
                                    backgroundColor: Colors.transparent,
                                    child: CachedNetworkImage(
                                      imageUrl: contacts?[index].imageUrl ??
                                          AppConstants.AVATAR_URL,
                                      //todo: solve problem in fetching image url
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, _) =>
                                          SpinKitFadingCircle(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return const DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Palette.activeCardColor,
                                            ),
                                          );
                                        },
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    contacts?[index].firstName ?? 'First name',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  subtitle: Text(
                                    contacts?[index].phone ?? 'Phone number',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text(
                                                    "Confirm Delete"),
                                                content: const Text(
                                                    "Are you sure you want to delete this contact?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      await deleteContact(
                                                          contacts?[index].id,
                                                          context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "YES",
                                                      style: TextStyle(
                                                          color: Palette
                                                              .activeCardColor),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text(
                                                      "NO",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  )
                                                ],
                                              ));
                                    },
                                  ),
                                  onTap: () {
                                    //todo: update contact details
                                    Navigator.pushNamed(
                                        context, AppRoutes.contact,
                                        arguments: Contact(
                                            id: contacts?[index].id,
                                            firstName:
                                                contacts?[index].firstName,
                                            phone: contacts?[index].phone,
                                            email: contacts?[index].email,
                                            secondaryPhone:
                                                contacts?[index].secondaryPhone,
                                            groupName:
                                                contacts?[index].groupName,
                                            imageUrl:
                                                contacts?[index].imageUrl));
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 25,
                                  color: Palette.dashTileColor,
                                );
                              },
                              itemCount: snapshot.data?.length ?? 0),
                        );
                    }

                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(
                    //     child: SpinKitFadingCircle(
                    //       color: Palette.activeCardColor,
                    //     ),
                    //   );
                    // } else if (snapshot.hasError) {
                    //   debugPrint(snapshot.error.toString());
                    //   debugPrint(snapshot.toString());
                    //   return Center(
                    //       child: Text(
                    //         snapshot.error.toString(),
                    //         style: Theme.of(context).textTheme.bodyMedium,
                    //       ));
                    // } else if (snapshot.connectionState ==
                    //     ConnectionState.done) {
                    //   final contacts = snapshot.data;
                    //   return RefreshIndicator(
                    //     onRefresh: () {
                    //       return _syncedContacts = getAllContacts();
                    //     },
                    //     child: ListView.separated(
                    //         itemBuilder: (context, index) {
                    //           return ListTile(
                    //             leading: CircleAvatar(
                    //               maxRadius: 20,
                    //               minRadius: 10,
                    //               backgroundColor: Colors.transparent,
                    //               child: CachedNetworkImage(
                    //                 imageUrl: contacts?[index].imageUrl ??
                    //                     AppConstants.AVATAR_URL,
                    //                 //todo: solve problem in fetching image url
                    //                 imageBuilder: (context, imageProvider) =>
                    //                     Container(
                    //                   decoration: BoxDecoration(
                    //                     image: DecorationImage(
                    //                       image: imageProvider,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 placeholder: (context, _) =>
                    //                     SpinKitFadingCircle(
                    //                   itemBuilder:
                    //                       (BuildContext context, int index) {
                    //                     return const DecoratedBox(
                    //                       decoration: BoxDecoration(
                    //                         color: Palette.activeCardColor,
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //                 errorWidget: (context, url, error) =>
                    //                     const Icon(
                    //                   Icons.error,
                    //                   size: 30,
                    //                 ),
                    //               ),
                    //             ),
                    //             title: Text(
                    //               contacts?[index].firstName ?? 'First name',
                    //               style: Theme.of(context).textTheme.bodyMedium,
                    //             ),
                    //             subtitle: Text(
                    //               contacts?[index].phone ?? 'Phone number',
                    //               style:
                    //                   Theme.of(context).textTheme.labelMedium,
                    //             ),
                    //             trailing: IconButton(
                    //               icon: const Icon(Icons.delete),
                    //               onPressed: () async {
                    //                 await showDialog(
                    //                     barrierDismissible: true,
                    //                     context: context,
                    //                     builder: (context) => AlertDialog(
                    //                           title:
                    //                               const Text("Confirm Delete"),
                    //                           content: const Text(
                    //                               "Are you sure you want to delete this contact?"),
                    //                           actions: [
                    //                             TextButton(
                    //                               onPressed: () async {
                    //                                 await deleteContact(
                    //                                     contacts?[index].id,
                    //                                     context);
                    //                                 Navigator.pop(context);
                    //                               },
                    //                               child: const Text(
                    //                                 "YES",
                    //                                 style: TextStyle(
                    //                                     color: Palette
                    //                                         .activeCardColor),
                    //                               ),
                    //                             ),
                    //                             TextButton(
                    //                               onPressed: () =>
                    //                                   Navigator.pop(context),
                    //                               child: const Text(
                    //                                 "NO",
                    //                                 style: TextStyle(
                    //                                     color: Colors.red),
                    //                               ),
                    //                             )
                    //                           ],
                    //                         ));
                    //               },
                    //             ),
                    //             onTap: () {
                    //               //todo: update contact details
                    //               Navigator.pushNamed(
                    //                   context, AppRoutes.contact,
                    //                   arguments: Contact(
                    //                       id: contacts?[index].id,
                    //                       firstName: contacts?[index].firstName,
                    //                       phone: contacts?[index].phone,
                    //                       email: contacts?[index].email,
                    //                       secondaryPhone:
                    //                           contacts?[index].secondaryPhone,
                    //                       groupName: contacts?[index].groupName,
                    //                       imageUrl: contacts?[index].imageUrl));
                    //             },
                    //           );
                    //         },
                    //         separatorBuilder: (context, index) {
                    //           return const Divider(
                    //             height: 25,
                    //             color: Palette.dashTileColor,
                    //           );
                    //         },
                    //         itemCount: snapshot.data?.length ?? 0),
                    //   );
                    // } else {
                    //   return Center(
                    //     child: Text(
                    //       'Still loading',
                    //       style: Theme.of(context).textTheme.bodyLarge,
                    //     ),
                    //   );
                    // }
                  },
                ),
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

  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(AppConstants.USER_NAME);
      _email = prefs.getString(AppConstants.EMAIL);
    });
  }

  final logoutSnackBar = const SnackBar(
    content: Text('Logging out'),
    elevation: 5,
    margin: EdgeInsets.symmetric(horizontal: 20),
    backgroundColor: Palette.activeCardColor,
    behavior: SnackBarBehavior.floating,
  );

  SnackBar _showErrorSnackBar(String errorMessage) {
    return SnackBar(
        backgroundColor: Palette.tileDividerColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }

  SnackBar _showSuccessSnackBar(String errorMessage) {
    return SnackBar(
        backgroundColor: Palette.activeCardColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }

  Future<List<Contact>> getAllContacts() async {
    debugPrint("I've been hit");
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.TOKEN);
      http.Response response = await http
          .get(Uri.parse('${AppConstants.BASE_URL}/contacts'), headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        'Accept': 'application/json'
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);

        if (jsonMap['success']) {
          final contacts = <Contact>[];
          for (var contact in jsonMap['data']) {
            contacts.add(Contact.fromJson(contact));
          }
          return contacts;
        } else {
          return [];
        }
      } else {
        var errorResponse = response.body;
        debugPrint("response error code : ${response.statusCode} \n"
            "response body : $errorResponse");
        ScaffoldMessenger.of(context)
            .showSnackBar(//todo: sort lint context rule later
                _showErrorSnackBar('Server error. Try again later'));
        return [];
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
          //todo: sort lint context rule later
          _showErrorSnackBar('Check your internet connection then try again'));
      return [];
    } on Exception catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
