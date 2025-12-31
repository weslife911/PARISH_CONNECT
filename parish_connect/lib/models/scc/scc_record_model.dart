import 'dart:convert';

class SccReportModel {
  // --- Metadata & Top Table Fields (All must be non-nullable if required by the form) ---
  final String sccName;
  final DateTime periodStart;
  final DateTime periodEnd; // Derived from "Period Covered" 

  // Statistics & Meetings 
  final int totalFamilies;
  final int gospelSharingGroups;
  final int councilMeetings;
  final int generalMeetings;
  final int noOfCommissions;
  final int activeCommissions;
  final int totalMembership;
  final int gospelSharingExpected;
  final int gospelSharingDone;
  final int noChristiansAttendingGS;
  final double gsAttendancePercentage; // % Attendance of Gospel sharing 

  // Membership Breakdown 
  final int children;
  final int youth;
  final int adults;

  // Sacramental/Pastoral Records 
  final int baptism;
  final int lapsedChristians;
  final int irregularMarriages;
  final int burials;

  // --- Activities carried out by Commissions (All modeled as List<String>) ---
  final List<String> biblicalApostolateActivities;
  final List<String> liturgyActivities;
  final List<String> financeActivities;
  final List<String> familyLifeActivities;
  final List<String> justiceAndPeaceActivities;
  final List<String> youthApostolateActivities;
  final List<String> catecheticalActivities;
  final List<String> healthCareActivities;
  final List<String> socialCommunicationActivities;
  final List<String> socialWelfareActivities;
  final List<String> educationActivities;
  final List<String> vocationActivities;
  final List<String> dialogueActivities;
  final List<String> womensAffairsActivities;
  final List<String> mensAffairsActivities;
  final List<String> prayerAndActionActivities;

  // --- General Report Sections ---
  final List<String> problemsEncountered; // From "Problems Encountered and Proposed Solutions" 
  final List<String> proposedSolutions; // Extracted from "Problems Encountered and Proposed Solutions"
  final List<String> issuesForCouncil; // From "Issues to be discussed in the Council" 
  final List<String> nextMonthPlans; // From "Plan for the next Month" 

  SccReportModel({
    required this.sccName,
    required this.periodStart,
    required this.periodEnd,
    required this.totalFamilies,
    required this.gospelSharingGroups,
    required this.councilMeetings,
    required this.generalMeetings,
    required this.noOfCommissions,
    required this.activeCommissions,
    required this.totalMembership,
    required this.gospelSharingExpected,
    required this.gospelSharingDone,
    required this.noChristiansAttendingGS,
    required this.gsAttendancePercentage,
    required this.children,
    required this.youth,
    required this.adults,
    required this.baptism,
    required this.lapsedChristians,
    required this.irregularMarriages,
    required this.burials,
    required this.biblicalApostolateActivities,
    required this.liturgyActivities,
    required this.financeActivities,
    required this.familyLifeActivities,
    required this.justiceAndPeaceActivities,
    required this.youthApostolateActivities,
    required this.catecheticalActivities,
    required this.healthCareActivities,
    required this.socialCommunicationActivities,
    required this.socialWelfareActivities,
    required this.educationActivities,
    required this.vocationActivities,
    required this.dialogueActivities,
    required this.womensAffairsActivities,
    required this.mensAffairsActivities,
    required this.prayerAndActionActivities,
    required this.problemsEncountered,
    required this.proposedSolutions,
    required this.issuesForCouncil,
    required this.nextMonthPlans,
  });

  // --- JSON Serialization ---

  factory SccReportModel.fromRawJson(String str) => SccReportModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory SccReportModel.fromJson(Map<String, dynamic> json) => SccReportModel(
        sccName: json["sccName"],
        periodStart: DateTime.parse(json["periodStart"]),
        periodEnd: DateTime.parse(json["periodEnd"]),
        totalFamilies: json["totalFamilies"],
        gospelSharingGroups: json["gospelSharingGroups"],
        councilMeetings: json["councilMeetings"],
        generalMeetings: json["generalMeetings"],
        noOfCommissions: json["noOfCommissions"],
        activeCommissions: json["activeCommissions"],
        totalMembership: json["totalMembership"],
        gospelSharingExpected: json["gospelSharingExpected"],
        gospelSharingDone: json["gospelSharingDone"],
        noChristiansAttendingGS: json["noChristiansAttendingGS"],
        gsAttendancePercentage: json["gsAttendancePercentage"]?.toDouble(),
        children: json["children"],
        youth: json["youth"],
        adults: json["adults"],
        baptism: json["baptism"],
        lapsedChristians: json["lapsedChristians"],
        irregularMarriages: json["irregularMarriages"],
        burials: json["burials"],

        // Commission Activities (Map<String, dynamic> is cast to List<String>)
        biblicalApostolateActivities: List<String>.from(json["biblicalApostolateActivities"].map((x) => x)),
        liturgyActivities: List<String>.from(json["liturgyActivities"].map((x) => x)),
        financeActivities: List<String>.from(json["financeActivities"].map((x) => x)),
        familyLifeActivities: List<String>.from(json["familyLifeActivities"].map((x) => x)),
        justiceAndPeaceActivities: List<String>.from(json["justiceAndPeaceActivities"].map((x) => x)),
        youthApostolateActivities: List<String>.from(json["youthApostolateActivities"].map((x) => x)),
        catecheticalActivities: List<String>.from(json["catecheticalActivities"].map((x) => x)),
        healthCareActivities: List<String>.from(json["healthCareActivities"].map((x) => x)),
        socialCommunicationActivities: List<String>.from(json["socialCommunicationActivities"].map((x) => x)),
        socialWelfareActivities: List<String>.from(json["socialWelfareActivities"].map((x) => x)),
        educationActivities: List<String>.from(json["educationActivities"].map((x) => x)),
        vocationActivities: List<String>.from(json["vocationActivities"].map((x) => x)),
        dialogueActivities: List<String>.from(json["dialogueActivities"].map((x) => x)),
        womensAffairsActivities: List<String>.from(json["womensAffairsActivities"].map((x) => x)),
        mensAffairsActivities: List<String>.from(json["mensAffairsActivities"].map((x) => x)),
        prayerAndActionActivities: List<String>.from(json["prayerAndActionActivities"].map((x) => x)),
        
        // General Report Sections
        problemsEncountered: List<String>.from(json["problemsEncountered"].map((x) => x)),
        proposedSolutions: List<String>.from(json["proposedSolutions"].map((x) => x)),
        issuesForCouncil: List<String>.from(json["issuesForCouncil"].map((x) => x)),
        nextMonthPlans: List<String>.from(json["nextMonthPlans"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "sccName": sccName,
        "periodStart": periodStart.toIso8601String(),
        "periodEnd": periodEnd.toIso8601String(),
        "totalFamilies": totalFamilies,
        "gospelSharingGroups": gospelSharingGroups,
        "councilMeetings": councilMeetings,
        "generalMeetings": generalMeetings,
        "noOfCommissions": noOfCommissions,
        "activeCommissions": activeCommissions,
        "totalMembership": totalMembership,
        "gospelSharingExpected": gospelSharingExpected,
        "gospelSharingDone": gospelSharingDone,
        "noChristiansAttendingGS": noChristiansAttendingGS,
        "gsAttendancePercentage": gsAttendancePercentage,
        "children": children,
        "youth": youth,
        "adults": adults,
        "baptism": baptism,
        "lapsedChristians": lapsedChristians,
        "irregularMarriages": irregularMarriages,
        "burials": burials,
        
        // Commission Activities
        "biblicalApostolateActivities": List<dynamic>.from(biblicalApostolateActivities.map((x) => x)),
        "liturgyActivities": List<dynamic>.from(liturgyActivities.map((x) => x)),
        "financeActivities": List<dynamic>.from(financeActivities.map((x) => x)),
        "familyLifeActivities": List<dynamic>.from(familyLifeActivities.map((x) => x)),
        "justiceAndPeaceActivities": List<dynamic>.from(justiceAndPeaceActivities.map((x) => x)),
        "youthApostolateActivities": List<dynamic>.from(youthApostolateActivities.map((x) => x)),
        "catecheticalActivities": List<dynamic>.from(catecheticalActivities.map((x) => x)),
        "healthCareActivities": List<dynamic>.from(healthCareActivities.map((x) => x)),
        "socialCommunicationActivities": List<dynamic>.from(socialCommunicationActivities.map((x) => x)),
        "socialWelfareActivities": List<dynamic>.from(socialWelfareActivities.map((x) => x)),
        "educationActivities": List<dynamic>.from(educationActivities.map((x) => x)),
        "vocationActivities": List<dynamic>.from(vocationActivities.map((x) => x)),
        "dialogueActivities": List<dynamic>.from(dialogueActivities.map((x) => x)),
        "womensAffairsActivities": List<dynamic>.from(womensAffairsActivities.map((x) => x)),
        "mensAffairsActivities": List<dynamic>.from(mensAffairsActivities.map((x) => x)),
        "prayerAndActionActivities": List<dynamic>.from(prayerAndActionActivities.map((x) => x)),

        // General Report Sections
        "problemsEncountered": List<dynamic>.from(problemsEncountered.map((x) => x)),
        "proposedSolutions": List<dynamic>.from(proposedSolutions.map((x) => x)),
        "issuesForCouncil": List<dynamic>.from(issuesForCouncil.map((x) => x)),
        "nextMonthPlans": List<dynamic>.from(nextMonthPlans.map((x) => x)),
      };
}