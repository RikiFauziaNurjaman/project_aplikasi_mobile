import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/data/comic_data.dart';
import 'package:project_aplikasi_mobile/models/list_comic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Comic> _listHome = listComic;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _listHome.length,
        itemBuilder: (context, index) {
          final comic = _listHome[index];
          return CarouselView( 
            children: [Image.asset(comic.coverUrl)]
          );
        },
      ),
    );
  }
}