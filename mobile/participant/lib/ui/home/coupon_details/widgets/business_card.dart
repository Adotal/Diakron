import 'package:diakron_participant/models/store/store.dart';
import 'package:diakron_participant/ui/home/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CustomNetworkImage(urlImage: store.urlLogo),
              ),

              const SizedBox(width: 15),
              // Business Info Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.commercialName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${getFormattedOpenDays(store.schedule)}\nDirección: ${store.address}",
                      style: TextStyle(
                        fontSize: 12,
                        // color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        //   0.7,
                        // ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedOpenDays(Map<String, dynamic> schedule) {
    final openDays = schedule.entries
        .where((entry) => entry.value['isOpen'] == true)
        .map((entry) => entry.key)
        .toList();

    if (openDays.isEmpty) return "Cerrado";

    // Logic to return "Lunes - Viernes"
    return "${openDays.first} - ${openDays.last}";
  }
}
