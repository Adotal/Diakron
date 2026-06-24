import 'package:diakron_admin/models/bin_model/bin_model.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String description;
  final List<BinModel> bin;
  final bool isConnected;
  final String? avatarUrl;
  final VoidCallback onTap;

  const LocationCard({
    super.key,
    required this.description,
    required this.bin,
    required this.isConnected,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isConnected ? AppColors.greenDiakron1 : Colors.red;
    final statusText = isConnected ? "Operativo" : "Sin conexión";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Avatar / Icon
                    Container(
                      width: 45, // Un poco más grande para que luzca mejor
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipOval(
                        child: avatarUrl != null
                            ? Image.network(avatarUrl!, fit: BoxFit.cover)
                            : const Icon(Icons.location_on, size: 28, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          
                          // Corregido: Mapeo de Lista de BinModel
                          Wrap(
                            spacing: 8, // Espacio horizontal entre items
                            runSpacing: 4, // Espacio vertical si salta de línea
                            children: bin.map((item) {
                              return Text(
                                "• ${item.fillingPercentage}% ${item.wasteType.toLowerCase()}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              
              // Status bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}