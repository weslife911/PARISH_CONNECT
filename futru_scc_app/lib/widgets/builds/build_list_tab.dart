import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/section/list_tab.dart';

/// Returns the appropriate List widget based on the section title.
Widget buildListTab(String sectionTitle, List<String> items) {
  // For 'SCC', 'Parish', and 'Deanery', we pass an empty list because the data
  // is fetched internally by ListTab using Riverpod FutureProviders.
  
  switch (sectionTitle.toLowerCase()) {
    case 'scc':
      return const ListTab(
        items: [], 
        sectionTitle: 'SCC',
      );
    case 'parish':
      return const ListTab(
        items: [], // Data fetched via provider
        sectionTitle: 'Parish',
      );
    case 'deanery':
      return const ListTab(
        items: [], // Data fetched via provider
        sectionTitle: 'Deanery',
      );
    // Default case: handles Mission Stations or any other generic title
    default:
      return ListTab(
        items: items,
        sectionTitle: sectionTitle,
      );
  }
}