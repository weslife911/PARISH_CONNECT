import 'package:flutter/material.dart';

class NoDataFoundForSections extends StatelessWidget {
  final String sectionTitle;
  const NoDataFoundForSections({super.key, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.insert_drive_file_outlined,
                size: 80,
                color: Colors.blue.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No $sectionTitle Reports',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'It looks like there is nothing here yet. Once reports are added, they will appear in this section.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
