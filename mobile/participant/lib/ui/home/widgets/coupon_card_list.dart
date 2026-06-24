import 'package:diakron_participant/models/coupon/coupon.dart';
import 'package:diakron_participant/routing/routes.dart';
import 'package:diakron_participant/ui/core/themes/colors.dart';
import 'package:diakron_participant/ui/home/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CouponCardList extends StatelessWidget {
  const CouponCardList({
    super.key,
    required this.coupon,
  });

  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    const Color diakronDarkBlue = Color.fromARGB(255, 0, 40, 95);

    return InkWell(
      onTap: () => context.push(
        Routes.couponById('${coupon.id}'),
      ),

      borderRadius: BorderRadius.circular(18),

      child: Container(
        height: 120,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),

              child: SizedBox(
                width: 120,
                height: double.infinity,

                child: CustomNetworkImage(
                  urlImage: coupon.urlImage,
                ),
              ),
            ),

            // INFO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
              
                    Text(
                      coupon.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // DESCRIPTION
                    Expanded(
                      child: Text(
                        "DESCRIPCION",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // POINTS
                    Row(
                      children: [
                        const Icon(
                          Icons.confirmation_number,
                          size: 15,
                          color: diakronDarkBlue,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          '${coupon.pricePoints} pts',

                          style: const TextStyle(
                            color: diakronDarkBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: AppColors.greenDiakron1.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: const Text(
                            'Disponible',

                            style: TextStyle(
                              color: AppColors.greenDiakron1,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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
}