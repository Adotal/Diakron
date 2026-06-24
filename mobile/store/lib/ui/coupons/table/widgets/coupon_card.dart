import 'package:diakron_stores/models/coupon/coupon.dart';
import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/core/ui/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CouponCard extends StatelessWidget {
  final Coupon coupon;

  const CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () => context.push(Routes.couponById('${coupon.id}')),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align image to top
              children: [
                // 1. Image
                CustomNetworkImage(urlImage: coupon.urlImage),
                const SizedBox(width: 16.0),

                // 2. Content Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title: Now has full width of the Expanded area
                      Text(
                        coupon.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),

                      // Description: Also has full width
                      Text(
                        coupon.descript,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),


                      const SizedBox(height: 6.0),
                      Text('${coupon.redeemTimes} canjeos'),
                      const SizedBox(height: 6.0),

                      // 3. Bottom Row: Price and Status Button at the same height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${coupon.pricePoints} puntos',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: coupon.isActive
                                  ? const Color(0xFF437A0F)
                                  : const Color(0xFFE53935),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              coupon.isActive ? 'ACTIVO' : 'INACTIVO',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
