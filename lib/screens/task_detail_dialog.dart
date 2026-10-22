import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../state/task_provider.dart';
import '../theme/app_theme.dart';

class TaskDetailDialog extends StatefulWidget {
  final TaskModel task;
  final TaskProvider provider;

  const TaskDetailDialog({Key? key, required this.task, required this.provider}) : super(key: key);

  @override
  State<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends State<TaskDetailDialog> {
  late bool _isEditMode;
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _priority;
  late String _status;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.provider.isTaskDetailInEditMode;
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _priority = widget.task.priority;
    _status = widget.task.status;
  }

  void _saveChanges() {
    final updated = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      status: _status,
      isCompleted: _status.toLowerCase() == 'done',
    );
    widget.provider.updateTask(updated);
    setState(() {
      _isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressData = widget.task.dynamicProgress;
    final progressFraction = progressData.key;
    final progressLabel = progressData.value;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.all(22),
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.chipBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.task.project,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.task.isCompleted ? AppColors.accentGreen.withOpacity(0.15) : AppColors.chipBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.task.isCompleted ? 'Done' : widget.task.status,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: widget.task.isCompleted ? AppColors.accentGreen : AppColors.charcoalDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(_isEditMode ? Icons.check : Icons.edit_outlined, size: 20),
                        onPressed: () {
                          if (_isEditMode) {
                            _saveChanges();
                          } else {
                            setState(() => _isEditMode = true);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => widget.provider.closeTaskDetail(),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (!_isEditMode) ...[
                // Title
                Text(
                  widget.task.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: widget.task.isCompleted ? AppColors.subtitleGray : AppColors.textPrimary,
                    decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (widget.task.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.task.description,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],

                const SizedBox(height: 18),

                // DYNAMIC PROGRESS LINE IN TASK DETAIL
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'DYNAMIC PROGRESS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            progressLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accentBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progressFraction,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Info Rows
                _buildInfoRow(Icons.calendar_today_outlined, 'Dates', widget.task.dateString),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.access_time, 'Time', '${widget.task.startTime} - ${widget.task.endTime} (${widget.task.cleanDuration})'),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.flag_outlined, 'Priority', widget.task.priority),

                const SizedBox(height: 24),

                // Action Buttons: Toggle Complete & Delete
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.provider.toggleTaskComplete(widget.task.id);
                        },
                        icon: Icon(
                          widget.task.isCompleted ? Icons.replay : Icons.check_circle_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          widget.task.isCompleted ? 'Mark Incomplete' : 'Complete Task',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.task.isCompleted ? AppColors.charcoalDark : AppColors.accentGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        widget.provider.deleteTask(widget.task.id);
                        widget.provider.closeTaskDetail();
                      },
                      icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
                      tooltip: 'Delete Task',
                    ),
                  ],
                ),
              ] else ...[
                // Edit Mode Fields
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['To Do', 'In Progress', 'Done'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) => setState(() => _status = val ?? 'To Do'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (val) => setState(() => _priority = val ?? 'Medium'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.charcoalDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.subtitleGray),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
