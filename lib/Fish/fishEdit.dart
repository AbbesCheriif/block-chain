import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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
  late String imagePath;
  late String localisation;
  late String predictedType;
  late FishController fishController;
  bool isLocationLoading = true;
  bool isPredictionLoading = false;

  @override
  void initState() {
    super.initState();
    imagePath = widget.fish != null ? widget.fish!.imageUrl : '';
    localisation = widget.fish != null ? widget.fish!.localisation : '';
    predictedType = widget.fish != null ? widget.fish!.typePoisson : '';
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Le service de localisation est désactivé. Activez-le dans les paramètres.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
              'Permission de localisation refusée par l\'utilisateur.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permission de localisation refusée définitivement.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        localisation = "${position.latitude}, ${position.longitude}";
        isLocationLoading = false;
      });
    } catch (e) {
      setState(() {
        localisation =
            "Erreur lors de la récupération de la localisation : ${e.toString()}";
        isLocationLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imagePath = image.path;
          predictedType = '';
        });
        await _sendImageToFlaskAPI();
      }
    } catch (e) {
      print("Erreur lors de la sélection de l'image: $e");
    }
  }

  Future<void> _sendImageToFlaskAPI() async {
    setState(() {
      isPredictionLoading = true;
    });

    try {
      final uri = Uri.parse('http://192.168.1.13:5000/predict');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = json.decode(await response.stream.bytesToString());
        setState(() {
          predictedType = responseBody['predicted_class'];
        });
      } else {
        print("Erreur de prédiction: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de l'envoi de l'image à l'API Flask: $e");
    } finally {
      setState(() {
        isPredictionLoading = false;
      });
    }
  }

  void handleCreateFish() async {
    Fish fish = Fish(
      '0',
      typePoisson: predictedType,
      imageUrl: imagePath,
      localisation: localisation,
    );
    await fishController.addFish(fish);
  }

  void handleEditFish() async {
    Fish fish = Fish(
      widget.fish!.id,
      typePoisson: predictedType,
      imageUrl: imagePath,
      localisation: localisation,
    );
    await fishController.editFish(fish);
  }

  @override
  Widget build(BuildContext context) {
    fishController = Provider.of<FishController>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFDCE9EF),
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
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.image, size: 30),
                                const SizedBox(width: 10),
                                Text(
                                  imagePath.isEmpty
                                      ? "Sélectionner une image"
                                      : "Image sélectionnée",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (isPredictionLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Text(
                            "Type de poisson prédit : $predictedType",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        const SizedBox(height: 12),
                        if (isLocationLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Text(
                            "Localisation : $localisation",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
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
