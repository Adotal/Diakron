import 'package:diakron_participant/models/bin_model/bin_model.dart';
import 'package:diakron_participant/ui/core/themes/colors.dart';
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
    final statusColor = isConnected
        ? AppColors.greenDiakron1
        : Colors.red;

    final statusText = isConnected
        ? "Operativo"
        : "Sin conexión";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // ICONO
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.grey2.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),

                      child: ClipOval(
                        child: avatarUrl != null
                            ? Image.network(
                                avatarUrl!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.location_on,
                                size: 28,
                                color: AppColors.greenDiakron1,
                              ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: bin.map((item) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),

                                child: Text(
                                  "${item.fillingPercentage}% ${item.wasteType}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        Colors.grey.shade700,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),

              // STATUS
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  16,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isConnected
                            ? Icons.check_circle
                            : Icons.error_outline,
                        size: 16,
                        color: statusColor,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
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