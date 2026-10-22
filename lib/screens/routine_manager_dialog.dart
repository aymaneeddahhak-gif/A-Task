import 'package:flutter/material.dart';
import '../state/task_provider.dart';
import '../theme/app_theme.dart';

class RoutineManagerDialog extends StatelessWidget {
  final TaskProvider provider;

  const RoutineManagerDialog({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routines = provider.routines;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(22),
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Manage This Week Routine',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: AppColors.subtitleGray),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Routines automate recurring focus blocks across Monday to Friday.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            ...routines.map((r) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          Text(
                            '${r.timeRange} · ${r.category}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.subtitleGray),
                          ),
                        ],
                      ),
                      Switch(
                        value: r.isEnabled,
                        activeColor: AppColors.accentBlue,
                        onChanged: (val) {
                          // Toggle routine in provider
                        },
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  provider.resetToThisWeekRoutine();
                  Navigator.of(context).pop();
                  provider.showToast('Weekly routine reset and applied!');
                },
                icon: const Icon(Icons.restore, size: 16, color: AppColors.charcoalDark),
                label: const Text(
                  'Reset Schedule to This Week',
                  style: TextStyle(color: AppColors.charcoalDark, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
