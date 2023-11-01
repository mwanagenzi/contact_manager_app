import 'package:flutter/material.dart';

class ProfileDropdownFormField extends StatefulWidget {
  final List<DropdownMenuItem<String>> dropdownItems;
  final String labelText;
  final IconData formFieldIcon;
  late String dropdownValue = dropdownItems.first.value!;
  bool? isEnabled;

  ProfileDropdownFormField({
    Key? key,
    required this.dropdownItems,
    required this.labelText,
    required this.formFieldIcon,
    this.isEnabled,
  }) : super(key: key);

  String get currentDropDownValue => dropdownValue;

  @override
  State<ProfileDropdownFormField> createState() =>
      _ProfileDropdownFormFieldState();
}

class _ProfileDropdownFormFieldState extends State<ProfileDropdownFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: DropdownButtonFormField(
        items: widget.dropdownItems,
        value: widget.dropdownValue,
        onChanged: (String? selectedValue) {
          setState(() {
            widget.dropdownValue = selectedValue!;
          });
        },
        decoration: InputDecoration(
          enabled: widget.isEnabled ?? true,
          labelText: widget.labelText,
          labelStyle: Theme.of(context).textTheme.bodyText2,
          prefixIcon: Icon(
            widget.formFieldIcon,
            color: Colors.black,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
