import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onAddClick;
  final bool isNight;

  const AppBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAddClick,
    this.isNight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14, top: 4),
      color: Colors.transparent,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(
            color: const Color(0xFFF1F1ED),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Navigation Icons Group (Home, Tasks, AI Bot, Profile, Sandbox)
            Row(
              children: [
                _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                const SizedBox(width: 4),
                _buildNavItem(1, Icons.checklist_rounded, Icons.checklist_outlined, 'Tasks'),
                const SizedBox(width: 4),
                _buildNavItem(2, Icons.smart_toy_rounded, Icons.smart_toy_outlined, 'AI Bot'),
                const SizedBox(width: 4),
                _buildNavItem(3, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
                const SizedBox(width: 4),
                _buildNavItem(4, Icons.palette_rounded, Icons.palette_outlined, 'Sandbox'),
              ],
            ),

            // Right Bold Action Button: Neon Lime/Yellow Capsule with "New" + "+" in Black Circle
            GestureDetector(
              onTap: onAddClick,
              child: Container(
                height: 48,
                padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF1FF68), Color(0xFFE2FB3E)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4FA37).withOpacity(0.40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'New',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF161616),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Inner Black Circle with '+' Icon
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFF141414),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData selectedIcon, IconData unselectedIcon, String tooltip) {
    final isSelected = selectedIndex == index;
    const Color selectedBg = Color(0xFF191A20);
    const Color selectedIconCol = Colors.white;
    const Color unselectedIconCol = Color(0xFF9E9E9E);

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            isSelected ? selectedIcon : unselectedIcon,
            size: 20,
            color: isSelected ? selectedIconCol : unselectedIconCol,
          ),
        ),
      ),
    );
  }
}
