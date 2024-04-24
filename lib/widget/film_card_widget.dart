import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/film.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
];

final _darkColors = [
  Colors.amber.shade700,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
  Colors.pinkAccent.shade400,
  Colors.tealAccent.shade400,
];

class FilmCardWidget extends StatelessWidget {
  const FilmCardWidget({
    Key? key,
    required this.film,
    required this.index,
  }) : super(key: key);

  final Film film;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.brightness == Brightness.light
        ? _lightColors[index % _lightColors.length]
        : _darkColors[index % _darkColors.length];

    final time = DateFormat.yMMMd().format(film.createdTime);

    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              film.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
    );
  }
  double getMinHeight(int index){
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}