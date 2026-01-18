import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/widgets/search_box.dart';
import 'package:movies/widgets/tab_builder.dart';
import 'package:movies/widgets/top_rated_item.dart'; 
import 'package:movies/widgets/actor_item.dart';
import 'package:movies/widgets/series_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final MoviesController controller = Get.put(MoviesController());
  final SearchController1 searchController = Get.put(SearchController1());
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Que quieres ver?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text;
                Get.find<SearchController1>().searchController.text = '';
                Get.find<SearchController1>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            
           //Codigo menu desplegable
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.selectedTab.value,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    dropdownColor: const Color(0xFF3A3F47),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Top 5 Películas'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Top Series'),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text('Actores Populares'),
                      ),
                    ],
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        controller.changeTab(newValue);
                      }
                    },
                  ),
                ),
              )),
            ),

            const SizedBox(
              height: 20,
            ),

            //Modificacion lista dinamica peliculas/actores/series
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        
                        // Cantidad de items
                        itemCount: controller.selectedTab.value == 0
                            ? controller.mainTopRatedMovies.length
                            : controller.selectedTab.value == 1 
                                ? controller.topRatedSeries.length
                                : controller.popularActors.length,
                        
                        itemBuilder: (_, index) {
                          if (controller.selectedTab.value == 0) {
                            // opcion 0 pelis
                            return TopRatedItem(
                                movie: controller.mainTopRatedMovies[index], 
                                index: index + 1
                            );
                          } else if (controller.selectedTab.value == 1) {
                             // opcion 1 series
                            return SeriesItem(
                                series: controller.topRatedSeries[index],
                                index: index + 1
                            );
                          } else {
                            // opcion 3 actores
                            return ActorItem(
                                actor: controller.popularActors[index],
                                index: index + 1
                            );
                          }
                        },
                      ),
                    )),
            ),
            
            const SizedBox(height: 20),
            
            DefaultTabController(
              length: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                      indicatorWeight: 3,
                      indicatorColor: Color(
                        0xFF3A3F47,
                      ),
                      labelStyle: TextStyle(fontSize: 11.0), 
                      tabs: [
                        Tab(text: 'Now playing'),
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Top rated'),
                        Tab(text: 'Popular'),
                      ]),
                  SizedBox(
                    height: 400,
                    child: TabBarView(children: [
                      TabBuilder(
                        future: ApiService.getCustomMovies(
                            'now_playing?api_key=${Api.apiKey}&language=en-US&page=1'),
                      ),
                      TabBuilder(
                        future: ApiService.getCustomMovies(
                            'upcoming?api_key=${Api.apiKey}&language=en-US&page=1'),
                      ),
                      TabBuilder(
                        future: ApiService.getCustomMovies(
                            'top_rated?api_key=${Api.apiKey}&language=en-US&page=1'),
                      ),
                      TabBuilder(
                        future: ApiService.getCustomMovies(
                            'popular?api_key=${Api.apiKey}&language=en-US&page=1'),
                      ),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}