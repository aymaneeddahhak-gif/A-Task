import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../state/task_provider.dart';
import '../theme/app_theme.dart';

class NotificationsDialog extends StatelessWidget {
  final TaskProvider provider;

  const NotificationsDialog({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = provider.notifications;
    
    // Group notifications by section (Today, This Week, Security) - ZERO Tomorrow
    final Map<String, List<AppNotificationItem>> grouped = {};
    for (final notif in notifications) {
      if (notif.section.toLowerCase().contains('tomorrow') ||
          notif.title.toLowerCase().contains('tomorrow')) {
        continue; // Strictly remove tomorrow from notification concept
      }
      grouped.putIfAbsent(notif.section, () => []).add(notif);
    }

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.22, 0.50, 1.0],
            colors: [
              Color(0xFFFBECE9),
              Color(0xFFFDF4F2),
              Color(0xFFFBFBFD),
              Color(0xFFF5F6F8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Status Bar Mock (9:41, Cellular, Wifi, Battery) matching reference design
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.signal_cellular_alt, size: 16, color: Color(0xFF0F172A)),
                        SizedBox(width: 6),
                        Icon(Icons.wifi, size: 16, color: Color(0xFF0F172A)),
                        SizedBox(width: 6),
                        Icon(Icons.battery_full, size: 18, color: Color(0xFF0F172A)),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Headline: "Notifications" + Subtle Dismiss Icon
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 20, top: 8, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => provider.closeNotifications(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.85),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Main Floating Notification Card (White Container with 28px rounded corners)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: notifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF1F5F9),
                                ),
                                child: const Icon(
                                  Icons.task_alt,
                                  size: 32,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'All Caught Up!',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'You have no unread notifications.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                          children: [
                            ...grouped.entries.map((entry) {
                              final sectionTitle = entry.key;
                              final items = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 14, top: 4),
                                    child: Text(
                                      sectionTitle,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  ...items.map((item) => Padding(
                                        padding: const EdgeInsets.only(bottom: 18),
                                        child: _buildNotificationRow(context, item),
                                      )),
                                  const Divider(color: Color(0xFFF1F5F9), thickness: 1),
                                  const SizedBox(height: 14),
                                ],
                              );
                            }).toList(),

                            // Bottom Controls: Mark All as Read / Clear All
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    provider.markAllNotificationsRead();
                                    provider.showToast('All marked as read');
                                  },
                                  icon: const Icon(Icons.done_all, size: 14, color: Color(0xFF475569)),
                                  label: const Text(
                                    'Mark all read',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF8FAFC),
                                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                                    shape: RoundedCornerShape(12),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    provider.clearAllNotifications();
                                    provider.showToast('All notifications cleared');
                                  },
                                  icon: const Icon(Icons.delete_outline, size: 14, color: Color(0xFFDC2626)),
                                  label: const Text(
                                    'Clear all',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFDC2626)),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFEF2F2),
                                    side: const BorderSide(color: Color(0xFFFEE2E2)),
                                    shape: RoundedCornerShape(12),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Row item: Clean Big Icon ONLY (NO little badge icon anywhere on top of it)
  Widget _buildNotificationRow(BuildContext context, AppNotificationItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // BIG ICON ONLY (Clean, centered, without little badge icon)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.type.iconBgColor,
          ),
          child: Center(
            child: Icon(
              item.type.icon,
              size: 22,
              color: item.type.iconColor,
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  RoundedCornerShape(int i) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(i.toDouble()));
}
