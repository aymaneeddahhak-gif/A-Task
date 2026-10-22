import 'package:flutter/material.dart';
import '../state/task_provider.dart';
import '../widgets/task_card.dart';

class RandomTaskDialog extends StatelessWidget {
  final TaskProvider provider;

  const RandomTaskDialog({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final candidate = provider.candidateRandomTask;
    if (candidate == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: [
          // Semi-transparent backdrop
          GestureDetector(
            onTap: () => provider.closeRandomTask(),
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),

          // Dialog Card centered strictly inside the mobile frame
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with Mascot and Title
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 18, 16, 14),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFAF8F5),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/mascot.png',
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Text('⚡', style: TextStyle(fontSize: 24)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Random Task Suggested',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF191A20),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Review before adding to your day',
                                      style: TextStyle(fontSize: 11.5, color: Color(0xFF8E8E93)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20, color: Color(0xFF8E8E93)),
                              onPressed: () => provider.closeRandomTask(),
                            ),
                          ],
                        ),
                      ),

                      // Routine Selector Option: Task | Day | Week | Month
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              {'label': 'Task', 'type': 'None'},
                              {'label': 'Day', 'type': 'Day'},
                              {'label': 'Week', 'type': 'Week'},
                              {'label': 'Month', 'type': 'Month'},
                            ].map((opt) {
                              final isSel = candidate.routineType == opt['type'];
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => provider.rerollRandomTask(opt['type']!),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSel ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isSel
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.06),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      opt['label']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                        color: isSel ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // Task Card Preview
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                        child: TaskCard(
                          task: candidate,
                          onTap: () {},
                          onToggleComplete: () {
                            provider.updateRandomTaskCandidate(
                              candidate.copyWith(isCompleted: !candidate.isCompleted),
                            );
                          },
                          onToggleStarred: () {
                            provider.updateRandomTaskCandidate(
                              candidate.copyWith(isStarred: !candidate.isStarred),
                            );
                          },
                        ),
                      ),

                      // Actions: Reroll, Cancel, Confirm & Apply
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Reroll button
                                Expanded(
                                  flex: 1,
                                  child: OutlinedButton.icon(
                                    onPressed: () => provider.rerollRandomTask(),
                                    icon: const Icon(Icons.shuffle, size: 16),
                                    label: const Text('Reroll'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF475569),
                                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Cancel button
                                Expanded(
                                  flex: 1,
                                  child: OutlinedButton(
                                    onPressed: () => provider.closeRandomTask(),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF64748B),
                                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Confirm & Apply Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  provider.confirmRandomTask();
                                },
                                icon: const Icon(Icons.check, size: 18, color: Colors.white),
                                label: const Text(
                                  'Confirm & Apply Task',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.5,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFA5A00),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
