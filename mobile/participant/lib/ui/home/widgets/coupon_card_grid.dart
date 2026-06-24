import 'package:diakron_participant/models/coupon/coupon.dart';
import 'package:diakron_participant/routing/routes.dart';
import 'package:diakron_participant/ui/home/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CouponCardGrid extends StatelessWidget {
  const CouponCardGrid({super.key, required this.coupon});

  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    const Color diakronDarkBlue = Color.fromARGB(255, 0, 40, 95);

    return InkWell(
      onTap: () => context.push(Routes.couponById('${coupon.id}')),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagen
            Expanded(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomNetworkImage(urlImage: coupon.urlImage),
                ),
              ),
            ),
            
            // info
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // titulo
                    Text(
                      coupon.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    
                    // puntos
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number,
                          size: 12,
                          color: diakronDarkBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${coupon.pricePoints} pts',
                          style: const TextStyle(
                            color: diakronDarkBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    
                    // categoria 
                    Text(
                      'Beneficio exclusivo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    // fila estrellas (no implementada)
                    /*Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.star, size: 10, color: diakronTeal),
                        Icon(Icons.star, size: 10, color: diakronTeal),
                        Icon(Icons.star, size: 10, color: diakronTeal),
                        Icon(Icons.star, size: 10, color: diakronTeal),
                        Icon(Icons.star_half, size: 10, color: diakronTeal),
                        const SizedBox(width: 4),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}