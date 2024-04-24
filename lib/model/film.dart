import 'package:flutter/src/widgets/image.dart';

final String tableFilms = 'notes';
class FilmFields {
  static final List<String> values = [
    id, isImportant, number, title, description, time, image
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
  static final String image = 'image';
}

class Film {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  final String? image;

  Film({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,

    this.image,
  });

  get color => null;

  Film copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,

    String? image,
  }) =>
      Film(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,

        image: image ?? this.image,
      );

  static Film fromJson(Map<String, Object?> json) => Film(
    id: json[FilmFields.id] as int?,
    isImportant: json[FilmFields.isImportant] == 1,
    number: json[FilmFields.number] as int,
    title: json[FilmFields.title] as String,
    description: json[FilmFields.description] as String,
    createdTime: DateTime.parse(json[FilmFields.time] as String),
    image: json[FilmFields.image] as String?,
  );

  Map<String, Object?> toJson() => {
    FilmFields.id: id,
    FilmFields.title: title,
    FilmFields.isImportant: isImportant ? 1 : 0,
    FilmFields.number: number,
    FilmFields.description: description,
    FilmFields.time: createdTime.toIso8601String(),

    FilmFields.image: image,
  };
}