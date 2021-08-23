import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/categoriesScreen.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/model/modelAllNews.dart';
import 'package:flutter_news_app/model/modelBbcNews.dart';
import 'package:flutter_news_app/newsDetailScreen.dart';
import 'package:flutter_news_app/view_model/newsListViewModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsListViewModel newsListViewModel = NewsListViewModel();
  final format = new DateFormat('MMMM dd,yyyy');

  @override
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: Kheight * 0.05,
            width: Kwidth * 0.05,
          ),
        ),
        title: Text('News',
            style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        children: [
          Container(
            height: Kheight * 0.55,
            child: FutureBuilder<ModelBbcNews>(
              future: newsListViewModel.fetchBBcNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinkit);
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.articles?.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                            snapshot.data!.articles![index].publishedAt!);

                        return Container(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Kheight * 0.02),
                                height: Kheight * 0.6,
                                width: Kwidth * 0.9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${snapshot.data!.articles![index].urlToImage!}",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(child: spinkit2),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: InkWell(
                                  onTap: () {
                                    String newsImage = snapshot
                                        .data!.articles![index].urlToImage!;
                                    String newsTitle =
                                        snapshot.data!.articles![index].title!;
                                    String newsDate = snapshot
                                        .data!.articles![index].publishedAt!;
                                    String newsAuthor =
                                        snapshot.data!.articles![index].author!;
                                    String newsDesc = snapshot
                                        .data!.articles![index].description!;
                                    String newsContent = snapshot
                                        .data!.articles![index].content!;
                                    String newsSource = snapshot
                                        .data!.articles![index].source!.name!;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailScreen(
                                                    newsImage,
                                                    newsTitle,
                                                    newsDate,
                                                    newsAuthor,
                                                    newsDesc,
                                                    newsContent,
                                                    newsSource)));
                                  },
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.all(10),
                                        height: Kheight * 0.22,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: Kwidth * 0.7,
                                              child: Text(
                                                '${snapshot.data!.articles![index].title!}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                // softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: Kwidth * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                        '${snapshot.data!.articles![index].source!.name}',
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .blueAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${format.format(dateTime)}',
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }
              },
            ),
          ),
          FutureBuilder<ModelAllNews>(
            future: newsListViewModel.fetchNews('general'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('');
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: new NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt!);

                      return InkWell(
                        onTap: () {
                          String newsImage =
                              snapshot.data!.articles![index].urlToImage!;
                          String newsTitle =
                              snapshot.data!.articles![index].title!;
                          String newsDate =
                              snapshot.data!.articles![index].publishedAt!;
                          String newsAuthor =
                              snapshot.data!.articles![index].author!;
                          String newsDesc =
                              snapshot.data!.articles![index].description!;
                          String newsContent =
                              snapshot.data!.articles![index].content!;
                          String newsSource =
                              snapshot.data!.articles![index].source!.name!;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                      newsImage,
                                      newsTitle,
                                      newsDate,
                                      newsAuthor,
                                      newsDesc,
                                      newsContent,
                                      newsSource)));
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: Kwidth * 0.04,
                              vertical: Kheight * 0.02),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${snapshot.data!.articles![index].urlToImage!}",
                                  height: Kheight * 0.18,
                                  width: Kwidth * 0.3,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(child: spinkit2),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 10),
                                  height: Kheight * 0.18,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Kwidth * 0.59,
                                        child: Text(
                                          '${snapshot.data!.articles![index].title!}',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600),
                                          // softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: Kwidth * 0.56,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Text(
                                                  '${snapshot.data!.articles![index].source!.name}',
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${format.format(dateTime)}',
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                      // return Row(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Text(snapshot.data!.articles![index].title!),
                      //       ],
                      //     ),

                      //   ],
                      // );
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50.0,
);
