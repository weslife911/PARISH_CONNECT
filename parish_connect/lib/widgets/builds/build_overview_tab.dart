import 'package:flutter/material.dart';
import 'package:parish_connect/components/overviews/deanery_overview.dart';
import 'package:parish_connect/components/overviews/generic_overview_tab.dart';
import 'package:parish_connect/components/overviews/mission_station_overview_tab.dart';
import 'package:parish_connect/components/overviews/parish_overview_tab.dart';
import 'package:parish_connect/components/overviews/scc_overview_tab.dart';

Widget buildOverviewTab(String title) {
    switch (title) {
      case 'SCC':
        return SCCOverviewTab(title: title,); // Dedicated SCC Overview
      case 'Parish':
        return ParishOverviewTab(title: title);
      case 'Deanery':
        return DeaneryOverviewTab(title: title);
      case 'Mission Station':
        return MissionStationOverviewTab(title: title);
      default:
        return GenericOverviewTab(title: title);
    }
  }
