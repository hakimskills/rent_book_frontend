import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/book_reading/book_reading_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/best_seller_cell.dart';
import '../../common_widget/genres_cell.dart';
import '../../common_widget/recently_cell.dart';
import '../../common_widget/show_guest_dialog.dart';
import '../../common_widget/top_picks_cell.dart';
import '../main_tab/main_tab_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List topPicksArr = [
    {
      "name": "The Dissapearance of Emila Zola",
      "author": "Michael Rosen",
      "img": "assets/img/1.jpg"
    },
    {
      "name": "Fatherhood",
      "author": "Marcus Berkmann",
      "img": "assets/img/2.jpg"
    },
    {
      "name": "The Time Travellers Handbook",
      "author": "Stride Lottie",
      "img": "assets/img/3.jpg"
    }
  ];

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
      body: SingleChildScrollView(
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
                              BorderRadius.circular(media.width * 0.5)),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                            fontWeight: FontWeight.w700),
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
                    SizedBox(
                      width: media.width,
                      height: media.width * 0.8,
                      child: CarouselSlider.builder(
                        itemCount: topPicksArr.length,
                        itemBuilder: (context, itemIndex, _) {
                          var iObj = topPicksArr[itemIndex] as Map? ?? {};
                          return TopPicksCell(iObj: iObj);
                        },
                        options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1,
                          enlargeCenterPage: true,
                          viewportFraction: 0.45,
                          enlargeFactor: 0.4,
                          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                        ),
                      ),
                    ),
                    sectionTitle("Bestsellers"),
                    SizedBox(
                      height: media.width * 0.9,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: bestArr.length,
                        itemBuilder: (context, index) {
                          var bObj = bestArr[index] as Map? ?? {};
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
                    sectionTitle("Genres"),
                    SizedBox(
                      height: media.width * 0.6,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: genresArr.length,
                        itemBuilder: (context, index) {
                          var bObj = genresArr[index] as Map? ?? {};
                          return GestureDetector(
                            onTap: () {
                              handleProtectedAction(() {
                                // Example action after login
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Genre selected: ${bObj['name']}"),
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
                    sectionTitle("Recently Viewed"),
                    SizedBox(
                      height: media.width * 0.7,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: recentArr.length,
                        itemBuilder: (context, index) {
                          var bObj = recentArr[index] as Map? ?? {};
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
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
            color: TColor.text, fontSize: 22, fontWeight: FontWeight.w700),
      ),
    );
  }
}
