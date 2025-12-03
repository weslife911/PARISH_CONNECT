import 'package:flutter/material.dart';

Widget buildStatCard(ColorScheme cs, String title, dynamic value, IconData icon, Color color) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      // FIX 1: Reduced overall padding from 12.0 to 8.0
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // The mainAxisAlignment is 'center', which contributes to height. We keep it for visual centering.
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 16),
          ),
          // FIX 2: Reduced spacing from 8 to 4
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          // FIX 3: Reduced spacing from 4 to 2
          const SizedBox(height: 2),
          // Keeping the FittedBox from the last step is optional but safe.
          FittedBox( 
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurfaceVariant,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}