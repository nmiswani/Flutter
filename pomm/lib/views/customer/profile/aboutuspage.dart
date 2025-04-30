import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(6.462580, 100.500999),
    zoom: 17.0,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Overview'), Tab(text: 'Contact & Location')],
          labelColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items:
                      [
                        'assets/images/utaragadget.jpg',
                        'assets/images/utaragadget.jpg',
                        'assets/images/utaragadget.jpg',
                      ].map((imgPath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imgPath,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome to Utara Gadget Solution!",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Utara Gadget Solution is an electronics accessories store located at VMall, Universiti Utara Malaysia (UUM). "
                    "We offer a wide range of high-quality electronic accessories such as charging cables, adapters, powerbanks, speakers, "
                    "earphones, phone casings, tempered glass, and many more.\n\n"
                    "We are committed to offering durable products at affordable prices, ideal for students, staff, and the UUM campus community. "
                    "If you're looking for practical and trendy accessories, Utara Gadget Solution is your go-to store on campus. "
                    "To further enhance customer convenience, this Android app helps customers browse, purchase, and track orders "
                    "conveniently from their mobile device.",
                    style: GoogleFonts.inter(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "📞 Contact No: 012-3456789",
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "📧 Email: utgadgetsolution@gmail.com",
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "⏰ Operating Hours: 10:00 am - 6:00 pm",
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  "📍 Located at",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.all(2),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _initialPosition,
                        onMapCreated: (GoogleMapController controller) {
                          if (!_controller.isCompleted) {
                            _controller.complete(controller);
                          }
                        },
                        markers: {
                          const Marker(
                            markerId: MarkerId('uum'),
                            position: LatLng(6.462580, 100.500999),
                            infoWindow: InfoWindow(
                              title: 'Varsity Mall',
                              snippet:
                                  'Universiti Utara Malaysia, 06050, Kedah',
                            ),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
