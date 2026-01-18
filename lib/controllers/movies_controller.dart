import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/models/series.dart';

class MoviesController extends GetxController {
  var isLoading = false.obs;
  var mainTopRatedMovies = <Movie>[].obs;
  var watchListMovies = <Movie>[].obs;
  var popularActors = <Actor>[].obs;
  var topRatedSeries = <TvSeries>[].obs;

  var selectedTab = 0.obs;

  void changeTab(int value) {
  selectedTab.value = value;
}

@override
  void onInit() async {
    isLoading.value = true;
    
    // Carga pelis
    var movies = await ApiService.getTopRatedMovies();
    if (movies != null) {
      mainTopRatedMovies.value = movies;
    }
    
    // Carga Series
    var series = await ApiService.getTopRatedSeries();
    if (series != null) {
      topRatedSeries.value = series;
    }
    
    // Carga Actores
    var actors = await ApiService.getPopularActors();
    if (actors != null) {
      popularActors.value = actors;
    }
    
    isLoading.value = false;
    super.onInit();
  }

  bool isInWatchList(Movie movie) {
    return watchListMovies.any((m) => m.id == movie.id);
  }

  void addToWatchList(Movie movie) {
    if (watchListMovies.any((m) => m.id == movie.id)) {
      watchListMovies.remove(movie);
      Get.snackbar('Success', 'removed from watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      watchListMovies.add(movie);
      Get.snackbar('Success', 'added to watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }
}