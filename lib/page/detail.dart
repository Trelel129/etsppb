
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/films_database.dart';
import '../model/film.dart';
import 'edit.dart';

class FilmDetailPage extends StatefulWidget {
  final int filmId;

  const FilmDetailPage({
    Key? key,
    required this.filmId,
  }) : super(key: key);

  @override
  _FilmDetailPageState createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  late Film film;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshFilm();
  }

  Future refreshFilm() async {
    setState(() => isLoading = true);

    this.film = await FilmsDatabase.instance.readFilm(widget.filmId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [editButton(), deleteButton()],
    ),
    body: isLoading ?
    Center(child: CircularProgressIndicator())
        : Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8),
            children: [
              Text(
                film.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                film.description,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Created on ${DateFormat.yMMMd().format(film.createdTime)}',
                style: TextStyle(color: Colors.white38),
              ),
              SizedBox(height: 8),
              if (film.image != null)
              Text(
                film.image as String,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),

            ],
          ),
        ),

  );
  Widget editButton() => IconButton(
    icon: Icon(Icons.edit,),
    onPressed: () async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditFilmPage(film: film),
      ));

      refreshFilm();
    },
  );

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      await FilmsDatabase.instance.delete(widget.filmId);

      Navigator.of(context).pop();
    },
  );
}

