import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'FishLinking.dart';
import 'FishEdit.dart';
import 'Fish.dart';
import 'dart:io';

class FishDetailScreen extends StatefulWidget {
  Fish? fish;

  FishDetailScreen({this.fish, super.key});

  @override
  State<FishDetailScreen> createState() => _FishDetailScreenState();
}

class _FishDetailScreenState extends State<FishDetailScreen> {
  late FishController fishController;

  handleDeleteFish() async {
    await fishController.deleteFish(int.parse(widget.fish!.id));
    Navigator.of(context).pop(); // Pop dialog after deletion
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmer la suppression',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Êtes-vous sûr de vouloir supprimer ce poisson ?',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: Text(
                'Non',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                handleDeleteFish(); // Delete fish
                Navigator.of(context).pop(); // Pop dialog
                Navigator.of(context).pop(); // Pop detail screen
              },
              child: Text(
                'Oui',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    fishController = Provider.of<FishController>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFDCE9EF),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  FishEditScreen(fish: widget.fish),
                            ),
                          );
                          print("----url:  ${widget.fish!.imageUrl}");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          _showDeleteConfirmationDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    widget.fish!.typePoisson,
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: widget.fish!.imageUrl.isNotEmpty
                        ? (Uri.parse(widget.fish!.imageUrl).isAbsolute
                            ? Image.network(
                                widget.fish!.imageUrl,
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 100,
                                    color: Colors.grey,
                                  );
                                },
                              )
                            : Image.file(
                                File(widget.fish!.imageUrl),
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 100,
                                    color: Colors.grey,
                                  );
                                },
                              ))
                        : const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.fish!.localisation,
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
