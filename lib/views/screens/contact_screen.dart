import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_manager/models/Contact.dart';
import 'package:contacts_manager/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/color_palette.dart';

class ContactScreen extends StatefulWidget {
  final Contact contact;

  const ContactScreen({super.key, required this.contact});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late TextEditingController _firstNameController,
      _surnameController,
      _emailController,
      _groupNameController,
      _phoneController,
      _secondaryPhoneController;

  bool _isLoading = false;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _firstNameController.text = widget.contact.firstName ?? "";
    _surnameController = TextEditingController();
    _surnameController.text = widget.contact.surname ?? "";
    _emailController = TextEditingController();
    _emailController.text = widget.contact.email ?? "";
    _groupNameController = TextEditingController();
    _groupNameController.text = widget.contact.groupName ?? "";
    _phoneController = TextEditingController();
    _phoneController.text = widget.contact.phone ?? "";
    _secondaryPhoneController = TextEditingController();
    _secondaryPhoneController.text = widget.contact.secondaryPhone ?? "";

    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditingEnabled = false;

  final ImagePicker picker = ImagePicker();
  XFile? _image;

  @override
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
                          maxRadius: 80,
                          minRadius: 40,
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl: widget.contact.imageUrl ??
                                AppConstants.AVATAR_URL,
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
                            final image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              _image = image;
                            });
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
                                      ProfileFormField(
                                        labelText: "Group Name",
                                        textEditingController:
                                            _groupNameController,
                                        formIcon: Icons.groups,
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
              !_isLoading
                  ? const SpinKitFadingCircle(
                      color: Palette.activeCardColor,
                    )
                  : FilledButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          widget.contact.id == 0 ? "ADD" : "UPDATE",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        debugPrint("Before upload contact");
                        widget.contact.id == 0
                            ? await _addContact(
                                _firstNameController.text,
                                _surnameController.text,
                                _phoneController.text,
                                _secondaryPhoneController.text,
                                _emailController.text,
                                _groupNameController.text,
                                _image,
                                context)
                            : await _updateContact(
                                widget.contact.id.toString(),
                                _firstNameController.text,
                                _surnameController.text,
                                _phoneController.text,
                                _secondaryPhoneController.text,
                                _emailController.text,
                                _groupNameController.text,
                                _image,
                                context);
                        debugPrint("After upload contact");
                      })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addContact(
      String firstName,
      String surname,
      String phone,
      String secondaryPhone,
      String email,
      String groupName,
      XFile? file,
      BuildContext context) async {
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
      "first_name": firstName,
      "surname": surname,
      "phone": phone,
      "secondary_phone": secondaryPhone,
      "email": email,
      "group_name": groupName,
    };

    request.fields.addAll(fields);
    request.headers.addAll(headers);

    //todo: check if file path is null,
    if (file != null) {
      var pic = await http.MultipartFile.fromPath("image", file.path);
      //add multipart to request
      request.files.add(pic);
    }

    //create multipart using filepath, string or bytes
    try {
      var response = await request.send();
      //Get the response from the server
      debugPrint("multipart response $response");
      var responseData = await response.stream.toBytes();

      var responseString = String.fromCharCodes(responseData);
      debugPrint("Response data: ${jsonDecode(responseString)}");
      ScaffoldMessenger.of(context)
          .showSnackBar(_showSuccessSnackBar(responseString));
      Navigator.pop(context);
    } on Exception catch (e) {
      debugPrint("multipart request error ${e.toString()}");
    }
  }

  Future<void> _updateContact(
      String contactId,
      String firstName,
      String surname,
      String phone,
      String secondaryPhone,
      String email,
      String groupName,
      XFile? file,
      BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.TOKEN);

    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest(
        "POST", Uri.parse("${AppConstants.BASE_URL}/update"));

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
      'Accept': 'application/json'
    };
    final Map<String, String> fields = {
      "id": contactId,
      "first_name": firstName,
      "surname": surname,
      "phone": phone,
      "secondary_phone": secondaryPhone,
      "email": email,
      "group_name": groupName,
    };

    request.fields.addAll(fields);
    request.headers.addAll(headers);

    //todo: check if file path is null,
    if (file != null) {
      var pic = await http.MultipartFile.fromPath("image", file.path);
      //add multipart to request
      request.files.add(pic);
    }

    //create multipart using filepath, string or bytes
    try {
      var response = await request.send();
      //Get the response from the server
      debugPrint("multipart response $response");
      var responseData = await response.stream.toBytes();

      var responseString = String.fromCharCodes(responseData);
      debugPrint("Response data: ${jsonDecode(responseString)}");
      ScaffoldMessenger.of(context)
          .showSnackBar(_showSuccessSnackBar(responseString));
      Navigator.pop(context);
    } on Exception catch (e) {
      debugPrint("multipart request error ${e.toString()}");
    }
  }

  Future<void> deleteContact(int contactId, BuildContext context) async {
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
          _showSuccessSnackBar(jsonMap['message']);
        } else {
          _showErrorSnackBar(jsonMap['message']);
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

  SnackBar _showSuccessSnackBar(String successMessage) {
    return SnackBar(
        backgroundColor: Palette.activeCardColor,
        elevation: 5.0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        content: Text(
          successMessage,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white),
        ));
  }
}

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
                          image: imageProvider, fit: BoxFit.fitHeight),
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
          labelStyle: Theme.of(context).textTheme.bodyMedium,
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
