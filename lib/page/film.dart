import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflitecrud/page/detail.dart';
import 'package:sqflitecrud/widget/film_card_widget.dart';

import '../db/films_database.dart';
import '../model/film.dart';
import 'edit.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({Key? key}) : super(key: key);

  @override
  _FilmPageState createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  late List<Film> films;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshFilms();
  }

  @override
  void dispose() {
    FilmsDatabase.instance.close();
    super.dispose();
  }

  Future refreshFilms() async {
    setState(() => isLoading = true);
    this.films = await FilmsDatabase.instance.readAllFilms();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('MyFilmList', style: TextStyle(fontSize: 24, color: Colors.white)),
      actions:
        [Icon(Icons.search),
        SizedBox(width: 12)],
    ),
    body: Center(
      child: isLoading
        ? CircularProgressIndicator()
        : films.isEmpty
          ? Text(
            'No Films added yet',
            style: TextStyle(color: Colors.white, fontSize: 24),
          )
          : buildFilms(),
    ),
    floatingActionButton: FloatingActionButton(
      shape: CircleBorder(side: BorderSide(color: Colors.grey.shade800)),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditFilmPage(),
        ));
        refreshFilms();
      },
    ),
  );

  Widget buildFilms() =>
      //StaggeredGridTilecount
      StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: films.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        itemBuilder: (context, index) {
          final film = films[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FilmDetailPage(filmId: film.id!),
              ));
              refreshFilms();
            },
            child: FilmCardWidget(film: film, index: index),
          );
        },
      );
}



