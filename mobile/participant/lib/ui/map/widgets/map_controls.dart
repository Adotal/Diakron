import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final bool isMapSelected;
  final bool showSegregadores;
  final VoidCallback onToggleViewMode;
  final VoidCallback onToggleLocationType;

  const MapControls({
    super.key,
    required this.isMapSelected,
    required this.showSegregadores,
    required this.onToggleViewMode,
    required this.onToggleLocationType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSegmentedSwitch(
              isSelected: showSegregadores,
              onToggle: onToggleLocationType,
              label1: 'Segregadores',
              // label2: 'CCent',
            ),

            _buildSegmentedSwitch(
              isSelected: isMapSelected,
              onToggle: onToggleViewMode,
              label1: 'Mapa',
              label2: 'Lista',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentedSwitch({
    required bool isSelected,
    required VoidCallback onToggle,
    required String label1,
    String? label2,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildTabButton(label1, isSelected, onToggle),
          if (label2 != null) _buildTabButton(label2, !isSelected, onToggle),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
