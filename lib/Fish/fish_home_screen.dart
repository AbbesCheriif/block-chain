import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'FishLinking.dart';
import 'Fishdetail.dart';
import 'FishEdit.dart';
import 'Fish.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FishController contactController;
  late List<Fish> fishes;

  @override
  Widget build(BuildContext context) {
    contactController = Provider.of<FishController>(context, listen: true);
    fishes = contactController.fishes;
    debugPrint("fishes size ${fishes.length}");

    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FishEditScreen(),
            ),
          );
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF80DFEA),
            borderRadius: BorderRadius.circular(200),
          ),
          child: const Center(
            child: Text(
              "+",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEAEFEF),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: contactController.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Your Fishes",
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          itemCount: fishes.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isThirdNote = (index + 1) % 3 == 0;
                            Fish fish = fishes[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FishDetailScreen(
                                      fish: fish,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color:
                                    const Color(0xFF91BBD1), // Background color
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Type: ${fish.typePoisson}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: isThirdNote ? 32 : 24,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // const SizedBox(height: 8),
                                      // Text(
                                      //   'Image URL: ${fish.imageUrl}',
                                      //   style: GoogleFonts.montserrat(
                                      //     fontSize: 18,
                                      //     fontWeight: FontWeight.w500,
                                      //     color: const Color(0xFF0C0A0A),
                                      //   ),
                                      // ),
                                      // const SizedBox(height: 8),
                                      // Text(
                                      //   'Location: ${fish.localisation}',
                                      //   style: GoogleFonts.montserrat(
                                      //     fontSize: 18,
                                      //     fontWeight: FontWeight.w500,
                                      //     color: const Color(0xFF0C0A0A),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(
                                  (index + 1) % 3 == 0 ? 2 : 1, 1),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
