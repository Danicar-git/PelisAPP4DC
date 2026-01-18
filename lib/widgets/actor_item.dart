import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/screens/actor_details_screen.dart';
import 'package:movies/widgets/index_number.dart';

class ActorItem extends StatelessWidget {
  const ActorItem({
    super.key,
    required this.actor,
    required this.index,
  });

  final Actor actor;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => ActorDetailsScreen(actor: actor));
          },
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            width: 150,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 150,
                    height: 220,
                    color: const Color(0xff2a2f38),
                    
                    child: Image.network(
                      Api.imageBaseUrl + actor.profilePath,
                      fit: BoxFit.contain, 
                      width: 150,
                      height: 220,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                      loadingBuilder: (_, __, ___) {
                        if (___ == null) return __;
                        return const FadeShimmer(
                          width: 150,
                          height: 220,
                          highlightColor: Color(0xff22272f),
                          baseColor: Color(0xff20252d),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  actor.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 55,
          child: IndexNumber(number: index),
        )
      ],
    );
  }
}