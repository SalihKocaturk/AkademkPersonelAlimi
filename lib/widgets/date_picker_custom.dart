import 'package:flutter/material.dart';

class DatePickerCustom extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const DatePickerCustom({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  State<DatePickerCustom> createState() => _DatePickerCustomState();
}

class _DatePickerCustomState extends State<DatePickerCustom> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          widget.controller.text =
              pickedDate.year.toString(); // YIL bilgisi yazılıyor
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
