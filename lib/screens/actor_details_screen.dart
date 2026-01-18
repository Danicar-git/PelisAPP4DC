import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/details_screen.dart';

class ActorDetailsScreen extends StatelessWidget {
  const ActorDetailsScreen({super.key, required this.actor});

  final Actor actor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f2326),
      body: SafeArea(
        child: SingleChildScrollView( // Añadimos Scroll vertical por si la lista es larga
          child: Column(
            children: [
              // --- CABECERA (Flecha y Título) ---
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const Text('Actor Details',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),

              // --- FOTO DEL ACTOR ---
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  Api.imageBaseUrl + actor.profilePath,
                  height: 350,
                  width: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, size: 200, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              
              // --- NOMBRE DEL ACTOR ---
              Text(
                actor.name,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              
              const SizedBox(height: 30),

              // Seccion pelis del actor
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Peliculas de:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lista de peliculas del actor
              SizedBox(
                height: 300,
                child: FutureBuilder<List<Movie>?>(
                  future: ApiService.getActorMovies(actor.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No se encontraron peliculas", style: TextStyle(color: Colors.white70)));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 24),
                      itemBuilder: (_, index) {
                        Movie movie = snapshot.data![index];
                        
                        return GestureDetector(
                          onTap: () {
                            
                            Get.to(() => DetailsScreen(movie: movie));
                          },
                          child: SizedBox(
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
                                      Api.imageBaseUrl + movie.posterPath,
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
                                  movie.title,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
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