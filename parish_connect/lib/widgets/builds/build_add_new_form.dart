import 'package:flutter/material.dart';
import 'package:parish_connect/components/forms/scc_form.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/components/forms/add_new_form.dart';
import 'package:parish_connect/components/forms/deanery_form.dart';

Widget buildAddNewForm(String title) {
  switch (title) {
    case 'SCC':
      return SCCForm();
    case 'Parish':
      return ParishForm();
    case 'Deanery':
      return DeaneryForm();
    default:
      return AddNewForm(section: title);
  }
}
