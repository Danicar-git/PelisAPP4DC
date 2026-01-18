import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/series.dart';
import 'package:get/get.dart';
import 'package:movies/screens/series_details_screen.dart';
import 'package:movies/widgets/index_number.dart';

class SeriesItem extends StatelessWidget {
  const SeriesItem({
    super.key,
    required this.series,
    required this.index,
  });

  final TvSeries series;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SeriesDetailsScreen(series: series));
            print("Clic en serie: ${series.name}");
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
                      Api.imageBaseUrl + series.posterPath,
                      fit: BoxFit.contain,
                      width: 150,
                      height: 220,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
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
                  series.name,
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