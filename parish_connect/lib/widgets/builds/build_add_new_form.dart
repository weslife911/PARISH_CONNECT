import 'package:flutter/material.dart';
import 'package:parish_connect/components/forms/scc_form.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/components/forms/add_new_form.dart';
import 'package:parish_connect/components/forms/deanery_form.dart';

Widget buildAddNewForm(String title) {
  switch (title) {
    case 'SCC':
      return SCCForm(); // New dedicated widget
    case 'Parish':
      return ParishForm(); // New dedicated widget
    case 'Deanery':
      return DeaneryForm(); // New dedicated widget
    default:
      // Use a generic form for all others or keep AddNewForm as the default
      return AddNewForm(section: title);
  }
}
