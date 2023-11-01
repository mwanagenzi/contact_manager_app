import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_manager/views/widgets/profile_dropdown_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/app_constants.dart';
import '../theme/color_palette.dart';

const String avatarUrl =
    'https://cdn-icons-png.flaticon.com/128/560/560277.png';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              const ProfileHeader(
                profileImageUrl: avatarUrl,
                title: "Moses Ngure",
                subtitle: "Student",
              ),
              const SizedBox(height: 10.0),
              const UserInfo(),
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

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              labelText: "Email",
                              initialValue: "njorogemosesngure@gmail.com",
                              formIcon: Icons.email_outlined,
                              isEnabled: isEditingEnabled,
                              textInputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            ProfileFormField(
                              labelText: "Username",
                              initialValue: "Mwanagenzi",
                              formIcon: Icons.person,
                              isEnabled: isEditingEnabled,
                            ),
                            const SizedBox(height: 10),
                            ProfileFormField(
                              labelText: "Phone Number",
                              initialValue: "0741047445",
                              formIcon: Icons.call,
                              isEnabled: isEditingEnabled,
                              textInputType: TextInputType.phone,
                            ),
                            const SizedBox(height: 10),
                            ProfileFormField(
                              labelText: "About Me",
                              initialValue: "I am a friend of God.",
                              formIcon: Icons.person,
                              isEnabled: isEditingEnabled,
                            ),
                            const SizedBox(height: 10),

                            buildAdditionalUserInfo(isEditingEnabled),
                            //todo: dependent on designation
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
    );
  }
}

final _designationDropdownField = ProfileDropdownFormField(
  dropdownItems: AppConstants.designationItems,
  labelText: 'Register as a ...',
  formFieldIcon: Icons.app_registration_rounded,
);
final _genderDropdown = ProfileDropdownFormField(
  dropdownItems: AppConstants.genderItems,
  labelText: 'Gender',
  formFieldIcon: Icons.person_outlined,
);
final _cohortDropdown = ProfileDropdownFormField(
    dropdownItems: AppConstants.cohortItems,
    labelText: 'Year Of Study',
    formFieldIcon: Icons.school);
final _ministryDropdown = ProfileDropdownFormField(
  dropdownItems: AppConstants.ministryItems,
  labelText: 'Ministry',
  formFieldIcon: Icons.engineering,
);
final _eTeamDropdown = ProfileDropdownFormField(
  dropdownItems: AppConstants.evangelisticTeamItems,
  labelText: 'Evangelistic Team',
  formFieldIcon: Icons.group,
);

Widget buildAdditionalUserInfo(bool isFormFieldEnabled) => Column(
      children: <Widget>[
        const SizedBox(height: 10),
        ...ListTile.divideTiles(
          color: Colors.grey,
          tiles: [
            ProfileFormField(
              labelText: "Residence",
              initialValue: "Argentina 6/1",
              formIcon: Icons.home,
              isEnabled: isFormFieldEnabled,
            ),
          ],
        ),
        const SizedBox(height: 10),
        _designationDropdownField,
        const SizedBox(height: 10),
        //todo: dropdown value get method
        _genderDropdown,
        const SizedBox(height: 20),
        //todo: dropdown value get method
        _cohortDropdown,
        const SizedBox(height: 20),
        //todo: dropdown value get method
        _ministryDropdown,
        const SizedBox(height: 20),
        //todo: dropdown value get method
        _eTeamDropdown,
      ],
    );

class ProfileHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String profileImageUrl;

  const ProfileHeader({
    Key? key,
    required this.title,
    required this.profileImageUrl,
    this.subtitle,
  }) : super(key: key);

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
                onPressed: () {}, //todo: launch image picker
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
  final String labelText;
  String initialValue;
  final IconData formIcon;
  bool isEnabled;

  ProfileFormField({
    Key? key,
    required this.labelText,
    required this.initialValue,
    required this.formIcon,
    this.textInputType,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
        keyboardType: textInputType ?? TextInputType.text,
        cursorColor: Colors.black,
        onChanged: (newValue) {
          initialValue = newValue;
        },
        initialValue: initialValue,
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
