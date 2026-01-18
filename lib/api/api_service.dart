import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/api/api_end_points.dart';
import 'package:movies/models/series.dart';

class ApiService {

  static Future<List<TvSeries>?> getTopRatedSeries() async {
      List<TvSeries> series = [];
      try {
        http.Response response = await http.get(Uri.parse(
            '${Api.baseUrl}tv/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
        var res = jsonDecode(response.body);
        
        // Cogemos las 10 primeras
        res['results'].take(10).forEach(
              (s) => series.add(TvSeries.fromMap(s)),
            );
        return series;
      } catch (e) {
        print(e);
        return null;
      }
    }

  static Future<List<Actor>?> getPopularActors() async {

    var url = Uri.parse('${Api.baseUrl}${ApiEndPoints.popularActors}?api_key=${Api.apiKey}&language=en-US');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      
      List<dynamic> list = data['results'];
      return list.map((item) => Actor.fromMap(item)).toList();
    } else {
      return null;
    }
  }


  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

//Nuevo metodo para drilldown de actores
static Future<Actor?> getActorDetails(int id) async {
    try {
      var url = Uri.parse('${Api.baseUrl}person/$id?api_key=${Api.apiKey}&language=en-US');
      var response = await http.get(url);
      
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Actor.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  
  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }
  //Consulta API para obtener las películas de un actor
  static Future<List<Movie>?> getActorMovies(int actorId) async {
      List<Movie> movies = [];
      try {
        // Endpoint: /person/{id}/movie_credits
        http.Response response = await http.get(Uri.parse(
            '${Api.baseUrl}person/$actorId/movie_credits?api_key=${Api.apiKey}&language=en-US'));
        var res = jsonDecode(response.body);
        //Cogemos las primeras 20 peliculas
        res['cast'].take(20).forEach(
              (m) => movies.add(Movie.fromMap(m)),
            );
        return movies;
      } catch (e) {
        print(e);
        return null;
      }
    }
    
  static Future<List<Actor>?> getSeriesCast(int seriesId) async {
      List<Actor> actors = [];
      try {
        http.Response response = await http.get(Uri.parse(
            '${Api.baseUrl}tv/$seriesId/credits?api_key=${Api.apiKey}&language=en-US'));
        var res = jsonDecode(response.body);
        
        // Cogemos los primeros 20
        res['cast'].take(20).forEach(
              (a) => actors.add(Actor.fromMap(a)),
            );
        return actors;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

