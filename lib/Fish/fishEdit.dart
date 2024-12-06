import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/Fish/Fish.dart';
import 'FishLinking.dart';
import 'fish_home_screen.dart';

class FishEditScreen extends StatefulWidget {
  Fish? fish;
  FishEditScreen({this.fish, super.key});

  @override
  State<FishEditScreen> createState() => _FishEditScreenState();
}

class _FishEditScreenState extends State<FishEditScreen> {
  late TextEditingController _typePoissonController;
  late TextEditingController _imageUrlController;
  late TextEditingController _localisationController;
  late FishController fishController;

  @override
  void initState() {
    super.initState();
    _typePoissonController = TextEditingController(
        text: widget.fish != null ? widget.fish?.typePoisson : '');
    _imageUrlController = TextEditingController(
        text: widget.fish != null ? widget.fish?.imageUrl : '');
    _localisationController = TextEditingController(
        text: widget.fish != null ? widget.fish?.localisation : '');
  }

  handleCreateFish() async {
    Fish fish = Fish(
      '0',
      typePoisson: _typePoissonController.text,
      imageUrl: _imageUrlController.text,
      localisation: _localisationController.text,
    );
    await fishController.addFish(fish);
  }

  handleEditFish() async {
    Fish fish = Fish(
      widget.fish!.id,
      typePoisson: _typePoissonController.text,
      imageUrl: _imageUrlController.text,
      localisation: _localisationController.text,
    );
    await fishController.editFish(fish);
  }

  @override
  Widget build(BuildContext context) {
    fishController = Provider.of<FishController>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFDCE9EF), // Set background color here
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: fishController.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            GestureDetector(
                              onTap: () async {
                                if (widget.fish == null) {
                                  handleCreateFish();
                                } else {
                                  handleEditFish();
                                }
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen()),
                                    (route) => false);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  widget.fish == null ? "Add" : "Update",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _typePoissonController,
                          style: GoogleFonts.montserrat(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: " Type de poisson",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          keyboardType: TextInputType.url,
                          controller: _imageUrlController,
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: " URL de l'image",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _localisationController,
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: " Localisation",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
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
