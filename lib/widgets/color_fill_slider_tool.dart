import 'package:flutter/material.dart';
import '../state/task_provider.dart';

/// TEMPORARY DESIGN TOOL:
/// Floating slide button on top to let the designer/recruiter interactively
/// test and choose the exact color fill percentage (0% Clean to 100% Full)
/// across Morning, Afternoon, and Night modes.
///
/// NOTE: This widget can be completely removed once the desired fill percentage is confirmed.
class ColorFillSliderTool extends StatefulWidget {
  final TaskProvider provider;

  const ColorFillSliderTool({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<ColorFillSliderTool> createState() => _ColorFillSliderToolState();
}

class _ColorFillSliderToolState extends State<ColorFillSliderTool> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final mode = provider.activeAtmosphereIndex;
    final isNight = mode == 2;
    final isAfternoon = mode == 1;
    final currentPercent = (provider.atmosphereFillPercentage * 100).round();

    final Color accentColor = isNight
        ? const Color(0xFF38BDF8)
        : (isAfternoon ? const Color(0xFFEA580C) : const Color(0xFF0284C7));

    final Color cardBg = isNight
        ? const Color(0xFF1E293B).withOpacity(0.96)
        : Colors.white.withOpacity(0.96);

    final Color textColor = isNight ? Colors.white : const Color(0xFF0F172A);
    final Color subTextColor = isNight ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color borderColor = isNight ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

    return Container(
      margin: const EdgeInsets.only(top: 6, left: 16, right: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(_isExpanded ? 18 : 20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isNight ? 0.35 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        child: _isExpanded
            ? _buildExpandedPanel(provider, textColor, subTextColor, accentColor, isNight)
            : _buildCollapsedPill(currentPercent, textColor, accentColor),
      ),
    );
  }

  Widget _buildCollapsedPill(int currentPercent, Color textColor, Color accentColor) {
    return InkWell(
      onTap: () => setState(() => _isExpanded = true),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, size: 15, color: accentColor),
            const SizedBox(width: 6),
            Text(
              'Color Fill: $currentPercent%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedPanel(
    TaskProvider provider,
    Color textColor,
    Color subTextColor,
    Color accentColor,
    bool isNight,
  ) {
    final currentPercent = (provider.atmosphereFillPercentage * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Title + Percent Badge + Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.tune_rounded, size: 15, color: accentColor),
                  const SizedBox(width: 6),
                  Text(
                    'Screen Color Fill Style',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$currentPercent%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => setState(() => _isExpanded = false),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Icon(Icons.keyboard_arrow_up_rounded, size: 18, color: subTextColor),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Real-time Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: accentColor,
              inactiveTrackColor: isNight ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              thumbColor: accentColor,
              overlayColor: accentColor.withOpacity(0.2),
            ),
            child: Slider(
              value: provider.atmosphereFillPercentage,
              min: 0.0,
              max: 1.0,
              onChanged: (val) {
                provider.setAtmosphereFillPercentage(val);
              },
            ),
          ),

          // Preset Chips Row: 0% Clean, 25%, 50%, 75%, 100% Full
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPresetChip('0% Clean', 0.0, provider, accentColor, isNight),
              _buildPresetChip('25%', 0.25, provider, accentColor, isNight),
              _buildPresetChip('50%', 0.50, provider, accentColor, isNight),
              _buildPresetChip('75%', 0.75, provider, accentColor, isNight),
              _buildPresetChip('100% Full', 1.0, provider, accentColor, isNight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(
    String label,
    double targetVal,
    TaskProvider provider,
    Color accentColor,
    bool isNight,
  ) {
    final isSelected = (provider.atmosphereFillPercentage - targetVal).abs() < 0.03;

    return GestureDetector(
      onTap: () => provider.setAtmosphereFillPercentage(targetVal),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor
              : (isNight ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isNight ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }
}
