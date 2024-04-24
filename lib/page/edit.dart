import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflitecrud/db/films_database.dart';
import 'package:sqflitecrud/model/film.dart';
import 'package:sqflitecrud/widget/film_form_widget.dart';

class AddEditFilmPage extends StatefulWidget {
  final Film? film;

  const AddEditFilmPage({
    Key? key,
    this.film,
  }) : super(key: key);

  @override
  _AddEditFilmPageState createState() => _AddEditFilmPageState();
}

class _AddEditFilmPageState extends State<AddEditFilmPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  late String? image;

  @override
  void initState() {
    super.initState();

    isImportant = widget.film?.isImportant ?? false;
    number = widget.film?.number ?? 0;
    title = widget.film?.title ?? '';
    description = widget.film?.description ?? '';

    image = widget.film?.image ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: FilmFormWidget(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        image: image,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedNumber: (number) => setState(() => this.number = number),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
        onChangedImage: (image) => setState(() => this.image = image),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: isFormValid ? Colors.grey.shade50 : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateFilm,
        child: const Text('Save', style: TextStyle(color: Colors.black)),
      ),
    );
  }

  void addOrUpdateFilm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.film != null;

      if (isUpdating) {
        await updateFilm();

      } else {
        await addFilm();

      }
      Navigator.of(context).pop();
    }
  }

  Future updateFilm() async {
    final film = widget.film!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      image: image,
    );

    await FilmsDatabase.instance.update(film);
  }

  Future addFilm() async {
    final film = Film(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
      image: image,
    );

    await FilmsDatabase.instance.create(film);
  }

}