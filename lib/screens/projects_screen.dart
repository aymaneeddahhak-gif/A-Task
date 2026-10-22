import 'package:flutter/material.dart';
import '../state/task_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';

class ProjectsScreen extends StatelessWidget {
  final TaskProvider provider;

  const ProjectsScreen({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = provider.allTasks;
    final Map<String, List> projectGroups = {};
    for (final task in tasks) {
      projectGroups.putIfAbsent(task.project, () => []).add(task);
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => provider.setSelectedTab(0),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEFECE6)),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back, size: 18, color: Color(0xFF1E293B)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Projects & Documentation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Track pipelines and project initiatives',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Project category cards
          ...projectGroups.entries.map((entry) {
            final projectName = entry.key;
            final projectTasks = entry.value;
            final completedCount = projectTasks.where((t) => t.isCompleted).length;
            final progress = projectTasks.isNotEmpty ? completedCount / projectTasks.length : 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.chipBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.folder_open_rounded, size: 20, color: AppColors.charcoalDark),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            projectName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$completedCount/${projectTasks.length} Done',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mini Task items under project
                  ...projectTasks.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TaskCard(
                      task: t,
                      onTap: () => provider.openTaskDetail(t),
                      onToggleComplete: () => provider.toggleTaskComplete(t.id),
                      onToggleStarred: () => provider.toggleTaskStarred(t.id),
                    ),
                  )),
                ],
              ),
            );
          }),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
