import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/widgets/index_number.dart';

class TopRatedItem extends StatelessWidget {
  const TopRatedItem({
    super.key,
    required this.movie,
    required this.index,
  });

  final Movie movie;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(

          onTap: () => Get.to(
            DetailsScreen(movie: movie),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            width: 150,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    Api.imageBaseUrl + movie.posterPath,
                    fit: BoxFit.cover,
                    height: 220,
                    width: 150,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 150,
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
                const SizedBox(height: 10),

                Text(
                  movie.title, // Usamos title
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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