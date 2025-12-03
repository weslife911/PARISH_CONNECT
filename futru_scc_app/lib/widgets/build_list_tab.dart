import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/section/list_tab.dart';

/// Returns the appropriate List widget based on the section title.
/// 
/// For now, all sections use the same ListTab which handles filtering
/// but this structure allows for future specialization (e.g., using 
/// SCCListTab, ParishListTab, etc., for unique layouts).
Widget buildListTab(String sectionTitle, List<String> items) {
  // Use a switch statement for clear selection logic
  switch (sectionTitle.toLowerCase()) {
    case 'scc':
      return ListTab(
        items: items,
        sectionTitle: 'SCC',
      );
    case 'parish':
      return ListTab(
        items: items,
        sectionTitle: 'Parish',
      );
    case 'deanery':
      return ListTab(
        items: items,
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