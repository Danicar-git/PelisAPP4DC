import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/series.dart';
import 'package:movies/screens/actor_details_screen.dart';
import 'package:movies/widgets/actor_item.dart';

class SeriesDetailsScreen extends StatelessWidget {
  const SeriesDetailsScreen({super.key, required this.series});

  final TvSeries series;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f2326),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cabecera
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const Text('Detalle de serie',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),

              // cartel serie
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  Api.imageBaseUrl + series.posterPath,
                  height: 350,
                  width: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 200, color: Colors.grey),
                  loadingBuilder: (_, __, ___) {
                    if (___ == null) return __;

                    return const FadeShimmer(
                      width: 250,
                      height: 350,
                      highlightColor: Color(0xff22272f),
                      baseColor: Color(0xff20252d),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // titulo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  series.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // descripcion
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  series.overview,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5),
                ),
              ),
              
              const SizedBox(height: 30),

              // reparto
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Reparto", // Título de la sección
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- lista de actores
              SizedBox(
                height: 300, 
                child: FutureBuilder<List<Actor>?>(
                  future: ApiService.getSeriesCast(series.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(child: Text("sin info de actores", style: TextStyle(color: Colors.white70)));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 24),
                      itemBuilder: (_, index) {
                        Actor actor = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => ActorDetailsScreen(actor: actor));
                          },
                          child: ActorItem(
                            actor: actor, 
                            index: index + 1
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}