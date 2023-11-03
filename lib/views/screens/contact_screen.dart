import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_manager/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/color_palette.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late TextEditingController _firstNameController,
      _surnameController,
      _emailController,
      _phoneController,
      _secondaryPhoneController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _secondaryPhoneController = TextEditingController();
    super.initState();
  }

  void asyncFileUpload(String firstName, String surname, String phone,
      String secondaryPhone, String email, XFile? file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest(
        "POST", Uri.parse("${AppConstants.BASE_URL}/add"));

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
      'Accept': 'application/json'
    };
    final Map<String, String> fields = {
      "label": "work",
      "first_name": firstName,
      "surname": surname,
      "phone": phone,
      "secondary_phone": secondaryPhone,
      "email": email,
    };

    request.fields.addAll(fields);
    request.headers.addAll(headers);

    //create multipart using filepath, string or bytes
    try {
      var pic = await http.MultipartFile.fromPath("image", file!.path);
      //add multipart to request
      request.files.add(pic);

      var response = await request.send();
      //Get the response from the server
      debugPrint("multipart response $response");
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      debugPrint(responseString);
    } on Exception catch (e) {
      debugPrint("multipart request error ${e.toString()}");
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditingEnabled = false;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Palette.primaryColor, width: 2.0),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl: AppConstants.AVATAR_URL,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                ),
                              ),
                            ),
                            placeholder: (context, _) => SpinKitFadingCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return const DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Palette.primaryColor,
                                  ),
                                );
                              },
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 100,
                        child: MaterialButton(
                          color: Colors.white,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          elevation: 0,
                          child: const Icon(
                            Icons.camera_alt_outlined,
                          ),
                          onPressed: () async {
                            image = await picker.pickImage(
                                source: ImageSource.gallery);
                            asyncFileUpload(
                                _firstNameController.text,
                                _surnameController.text,
                                _phoneController.text,
                                _secondaryPhoneController.text,
                                _emailController.text,
                                image);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "User Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          MaterialButton(
                            color: Colors.white,
                            shape: const CircleBorder(
                              side: BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                            elevation: 0,
                            child: const Icon(Icons.edit),
                            onPressed: () => setState(() {
                              isEditingEnabled = !isEditingEnabled;
                            }),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 5,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  ...ListTile.divideTiles(
                                    color: Colors.grey,
                                    tiles: [
                                      ProfileFormField(
                                        labelText: "First Name",
                                        textEditingController:
                                            _firstNameController,
                                        formIcon: Icons.person,
                                        isEnabled: isEditingEnabled,
                                        textInputType:
                                            TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 10),
                                      ProfileFormField(
                                        labelText: "Surname",
                                        textEditingController:
                                            _surnameController,
                                        formIcon: Icons.person,
                                        isEnabled: isEditingEnabled,
                                      ),
                                      const SizedBox(height: 10),
                                      ProfileFormField(
                                        labelText: "Email",
                                        textEditingController: _emailController,
                                        formIcon: Icons.mail,
                                        isEnabled: isEditingEnabled,
                                      ),
                                      const SizedBox(height: 10),
                                      ProfileFormField(
                                        labelText: "Phone Number",
                                        textEditingController: _phoneController,
                                        formIcon: Icons.call,
                                        isEnabled: isEditingEnabled,
                                      ),
                                      const SizedBox(height: 10),
                                      ProfileFormField(
                                        labelText: "Other phone number",
                                        textEditingController:
                                            _secondaryPhoneController,
                                        formIcon: Icons.call,
                                        isEnabled: isEditingEnabled,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              FilledButton(
                  child: const Text("UPDATE"),
                  onPressed: () {
                    //todo: update db details accordingly
                  })
            ],
          ),
        ),
      ),
    );
  }
}

// class UserInfo extends StatefulWidget {
//   const UserInfo({Key? key}) : super(key: key);
//
//   @override
//   State<UserInfo> createState() => _UserInfoState();
// }
//
// class _UserInfoState extends State<UserInfo> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isEditingEnabled = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "User Information",
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//                 MaterialButton(
//                   color: Colors.white,
//                   shape: const CircleBorder(
//                     side: BorderSide(
//                       color: Colors.green,
//                       width: 2.0,
//                     ),
//                   ),
//                   elevation: 0,
//                   child: const Icon(Icons.edit),
//                   onPressed: () => setState(() {
//                     isEditingEnabled = !isEditingEnabled;
//                   }),
//                 ),
//               ],
//             ),
//           ),
//           Card(
//             child: Container(
//               alignment: Alignment.topLeft,
//               padding: const EdgeInsets.symmetric(
//                 vertical: 15,
//                 horizontal: 5,
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: <Widget>[
//                     Column(
//                       children: <Widget>[
//                         ...ListTile.divideTiles(
//                           color: Colors.grey,
//                           tiles: [
//                             ProfileFormField(
//                               labelText: "First Name",
//
//                               formIcon: Icons.person,
//                               isEnabled: isEditingEnabled,
//                               textInputType: TextInputType.emailAddress,
//                             ),
//                             const SizedBox(height: 10),
//                             ProfileFormField(
//                               labelText: "Surname",
//                               initialValue: "Doe",
//                               formIcon: Icons.person,
//                               isEnabled: isEditingEnabled,
//                             ),
//                             const SizedBox(height: 10),
//                             ProfileFormField(
//                               labelText: "Email",
//                               initialValue: "johndoe@mail.com",
//                               formIcon: Icons.mail,
//                               isEnabled: isEditingEnabled,
//                             ),
//                             const SizedBox(height: 10),
//                             ProfileFormField(
//                               labelText: "Phone Number",
//                               initialValue: "+254711304059",
//                               formIcon: Icons.call,
//                               isEnabled: isEditingEnabled,
//                             ),
//                             const SizedBox(height: 10),
//                             ProfileFormField(
//                               labelText: "Phone Number",
//                               initialValue: "+254711304059",
//                               formIcon: Icons.call,
//                               isEnabled: isEditingEnabled,
//                             ),
//                             const SizedBox(height: 10),
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class ProfileHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String profileImageUrl;

  ProfileHeader({
    Key? key,
    required this.title,
    required this.profileImageUrl,
    this.subtitle,
  }) : super(key: key);

  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Palette.primaryColor, width: 2.0),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.transparent,
                child: CachedNetworkImage(
                  imageUrl: profileImageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, _) => SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Palette.primaryColor,
                        ),
                      );
                    },
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 100,
              child: MaterialButton(
                color: Colors.white,
                shape: const CircleBorder(
                  side: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                elevation: 0,
                child: const Icon(
                  Icons.camera_alt_outlined,
                ),
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.gallery);
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}

class ProfileFormField extends StatelessWidget {
  final TextInputType? textInputType;
  final bool? obscureText;
  final String labelText;
  final IconData formIcon;
  bool isEnabled;
  final TextEditingController textEditingController;

  ProfileFormField({
    Key? key,
    required this.labelText,
    required this.formIcon,
    this.textInputType,
    this.obscureText,
    required this.isEnabled,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        cursorColor: Colors.black,
        controller: textEditingController,
        obscureText: obscureText ?? false,
        // validator: _emailValidator, //TODO: set individual validators
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.bodyText2,
          prefixIcon: Icon(
            formIcon,
            color: Colors.black,
          ),
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
          enabled: isEnabled,
          filled: true,
          fillColor: Colors.white,
        ),
      );
}
