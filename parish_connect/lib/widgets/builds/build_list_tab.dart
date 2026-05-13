import 'package:flutter/material.dart';
import 'package:parish_connect/components/section/list_tab.dart';

Widget buildListTab(String sectionTitle, List<String> items) {
  switch (sectionTitle.toLowerCase()) {
    case 'scc':
      return const ListTab(items: [], sectionTitle: 'SCC');
    case 'parish':
      return const ListTab(items: [], sectionTitle: 'Parish');
    case 'deanery':
      return const ListTab(items: [], sectionTitle: 'Deanery');
    default:
      return ListTab(items: items, sectionTitle: sectionTitle);
  }
}
