import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsly/model/articlemodel.dart';
import 'package:newsly/model/slidermodel.dart';
import 'package:newsly/services/news.dart';
import 'package:newsly/services/sliderdata.dart';

import 'articleview.dart';

class AllNews extends StatefulWidget {
  String news;
  AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<Slidermodel> sliders = [];
  List<Articlemodel> news = [];

  void initState() {
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    news = newsclass.news;
    setState(() {});
  }

  getSlider() async {
    Sliders slider = new Sliders();
    await slider.getSlider();
    sliders = slider.sliders;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Daily News"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount:
                widget.news == "Breaking News" ? sliders.length : news.length,
            itemBuilder: (context, index) {
              return AllNewsSection(
                  url: widget.news == "Breaking News"
                      ? sliders[index].url!
                      : news[index].url!,
                  image: widget.news == "Breaking News"
                      ? sliders[index].urlToImage!
                      : news[index].urlToImage!,
                  desc: widget.news == "Breaking News"
                      ? sliders[index].description!
                      : news[index].description!,
                  title: widget.news == "Breaking News"
                      ? sliders[index].title!
                      : news[index].title!);
            }),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  String image, desc, title, url;
  AllNewsSection(
      {required this.image,
      required this.desc,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Articleview(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              desc,
              maxLines: 3,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
