import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_info/common/helpers/snackbar_helper.dart';
import 'package:user_info/common/styles/form_styles.dart';
import 'package:user_info/common/utils/form_validation.dart';
import 'package:user_info/models/user_model.dart';
import 'package:user_info/providers/user_provider.dart';
import 'package:user_info/widgets/round_text_field.dart';
import 'package:user_info/widgets/rounded_date_picker_field.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? existingUser;

  const UserFormScreen({super.key, this.existingUser});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingUser != null) {
      _firstNameController.text = widget.existingUser?.firstName ?? "";
      _lastNameController.text = widget.existingUser?.lastName ?? "";
      _dobController.text = widget.existingUser?.dob ?? "";
      _phoneController.text = widget.existingUser?.mobile ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.existingUser != null ? "Edit" : "Add New"} Contact", style: FormStyles.black20TextStyles())),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundTextField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required *';
                    }
                    if (!value.isValidName()) {
                      return 'Please enter a valid first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                RoundTextField(
                  controller: _lastNameController,
                  labelText: 'Last Name',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required *';
                    }
                    if (!value.isValidName()) {
                      return 'Please enter a valid last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                RoundTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile number is required *';
                    }
                    if (!value.isValidMobile()) {
                      return 'Please enter a mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                RoundedDatePickerField(controller: _dobController, labelText: 'Date of Birth'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(widget.existingUser != null ? "Update" : "Save"),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final firstName = _firstNameController.text.trim();
                      final lastName = _lastNameController.text.trim();
                      final phoneNumber = _phoneController.text.trim();
                      final dateOfBirth = _dobController.text.trim();

                      final newUser = UserModel(firstName, lastName, dateOfBirth, phoneNumber);
                      final userProvider = Provider.of<UserProvider>(context, listen: false);
                      if (widget.existingUser != null) {
                        newUser.id = widget.existingUser?.id;
                        userProvider.updateUser(newUser);
                        SnackBarHelper.showSuccessSnackBar(context, "${newUser.firstName} ${newUser.lastName} Updated Successfully");
                      } else {
                        userProvider.addUser(newUser);
                        SnackBarHelper.showSuccessSnackBar(context, "${newUser.firstName} ${newUser.lastName} Added Successfully");
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
