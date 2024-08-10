import 'package:flutter/material.dart';
import 'package:user_info/common/styles/form_styles.dart';

class RoundedDatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const RoundedDatePickerField({
    Key? key,
    required this.controller,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FormStyles.defaultRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FormStyles.defaultRadius),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (selectedDate != null) {
                controller.text = '${selectedDate.toLocal()}'.split(' ')[0];
              }
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date of birth';
          }
          return null;
        },
      ),
    );
  }
}
