import 'dart:convert';

import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/book_reading/book_reading_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/best_seller_cell.dart';
import '../../common_widget/genres_cell.dart';
import '../../common_widget/recently_cell.dart';
import '../../common_widget/show_guest_dialog.dart';
import '../../common_widget/top_picks_cell.dart';
import '../../model/book_model.dart';
import '../main_tab/main_tab_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<BookModel> topPicksArr = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTopPicks();
  }

  Future<void> fetchTopPicks() async {
    debugPrint('🔄 Starting API call...');
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.4:8000/api/public-books'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        debugPrint('✅ Parsed data length: ${data.length}');

        setState(() {
          topPicksArr = data.map((e) => BookModel.fromJson(e)).toList();
          isLoading = false;
          errorMessage = null;
        });

        debugPrint('📚 Books loaded: ${topPicksArr.length} items');

        // Debug print image URLs
        for (var book in topPicksArr) {
          debugPrint('Book ${book.id}: ${book.title}');
          debugPrint('Cover path: ${book.cover}');
          debugPrint('Full image URL: ${book.imageUrl}');
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load books: ${response.statusCode}';
        });
        debugPrint('❌ API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
      debugPrint('💥 Exception caught: $e');
    }
  }

  List bestArr = [
    {
      "name": "Fatherhood",
      "author": "by Christopher Wilson",
      "img": "assets/img/4.jpg",
      "rating": 5.0
    },
    {
      "name": "In A Land Of Paper Gods",
      "author": "by Rebecca Mackenzie",
      "img": "assets/img/5.jpg",
      "rating": 4.0
    },
    {
      "name": "Tattletale",
      "author": "by Sarah J. Noughton",
      "img": "assets/img/6.jpg",
      "rating": 3.0
    }
  ];

  List genresArr = [
    {
      "name": "Graphic Novels",
      "img": "assets/img/g1.png",
    },
    {
      "name": "Fiction",
      "img": "assets/img/g1.png",
    },
    {
      "name": "History",
      "img": "assets/img/g1.png",
    }
  ];

  List recentArr = [
    {
      "name": "The Fatal Tree",
      "author": "by Jake Arnott",
      "img": "assets/img/10.jpg"
    },
    {
      "name": "Day Four",
      "author": "by LOTZ, SARAH",
      "img": "assets/img/11.jpg"
    },
    {
      "name": "Door to Door",
      "author": "by Edward Humes",
      "img": "assets/img/12.jpg"
    }
  ];

  Future<void> handleProtectedAction(VoidCallback onSuccess) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      showSignInRequiredDialog(context);
    } else {
      onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchTopPicks,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    child: Transform.scale(
                      scale: 1.5,
                      origin: Offset(0, media.width * 0.8),
                      child: Container(
                        width: media.width,
                        height: media.width,
                        decoration: BoxDecoration(
                          color: TColor.primary,
                          borderRadius:
                              BorderRadius.circular(media.width * 0.5),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: media.width * 0.1),
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: const Text(
                          "Our Top Picks",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        leading: Container(),
                        leadingWidth: 1,
                        actions: [
                          IconButton(
                            onPressed: () {
                              sideMenuScaffoldKey.currentState?.openEndDrawer();
                            },
                            icon: const Icon(Icons.menu),
                          )
                        ],
                      ),
                      // Top Picks Section
                      Container(
                        width: media.width,
                        height: media.width * 0.8,
                        child: _buildTopPicksSection(),
                      ),

                      // Bestsellers Section
                      sectionTitle("Bestsellers"),
                      SizedBox(
                        height: media.width * 0.9,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 8,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: bestArr.length,
                          itemBuilder: (context, index) {
                            var bObj = bestArr[index];
                            return GestureDetector(
                              onTap: () {
                                handleProtectedAction(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookReadingView(bObj: bObj),
                                    ),
                                  );
                                });
                              },
                              child: BestSellerCell(bObj: bObj),
                            );
                          },
                        ),
                      ),

                      // Genres Section
                      sectionTitle("Genres"),
                      SizedBox(
                        height: media.width * 0.6,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 8,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: genresArr.length,
                          itemBuilder: (context, index) {
                            var bObj = genresArr[index];
                            return GestureDetector(
                              onTap: () {
                                handleProtectedAction(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Genre selected: ${bObj['name']}"),
                                    ),
                                  );
                                });
                              },
                              child: GenresCell(
                                bObj: bObj,
                                bgcolor: index % 2 == 0
                                    ? TColor.color1
                                    : TColor.color2,
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: media.width * 0.1),

                      // Recently Viewed Section
                      sectionTitle("Recently Viewed"),
                      SizedBox(
                        height: media.width * 0.7,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 8,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: recentArr.length,
                          itemBuilder: (context, index) {
                            var bObj = recentArr[index];
                            return RecentlyCell(iObj: bObj);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopPicksSection() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading books...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                fetchTopPicks();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: TColor.primary,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (topPicksArr.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              color: Colors.white,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No books available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: topPicksArr.length,
      itemBuilder: (context, itemIndex, _) {
        var book = topPicksArr[itemIndex];
        return GestureDetector(
          onTap: () {
            handleProtectedAction(() {
              // Navigate to book details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookReadingView(
                    bObj: {
                      'name': book.title,
                      'author': book.author,
                      'img': book.imageUrl,
                      'description': book.description ?? '',
                      'rating': 5.0, // You can add rating to your model
                    },
                  ),
                ),
              );
            });
          },
          child: TopPicksCell(
            iObj: {
              'name': book.title,
              'author': book.author,
              'img': book.imageUrl,
            },
          ),
        );
      },
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 1,
        enlargeCenterPage: true,
        viewportFraction: 0.45,
        enlargeFactor: 0.4,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: TColor.text,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
