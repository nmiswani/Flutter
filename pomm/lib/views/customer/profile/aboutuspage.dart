import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pomm/models/aboutus.dart';
import 'package:pomm/shared/myserverconfig.dart';

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

  bool isLoading = true;
  AboutUs? aboutUsData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchAboutUsData();
  }

  Future<void> fetchAboutUsData() async {
    final response = await http.get(
      Uri.parse("${MyServerConfig.server}/pomm/php/get_aboutus.php"),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        setState(() {
          aboutUsData = AboutUs.fromJson(jsonResponse['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 243, 247),
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
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
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
                                aboutUsData?.image1,
                                aboutUsData?.image2,
                                aboutUsData?.image3,
                              ].map((imgPath) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imgPath != null
                                            ? "${MyServerConfig.server}/pomm/assets/aboutus/$imgPath"
                                            : "${MyServerConfig.server}/pomm/assets/aboutus/default.jpg", // default image if null
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Icon(Icons.broken_image);
                                        },
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          aboutUsData?.title ?? 'Loading...',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              242,
                              243,
                              247,
                            ).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                aboutUsData?.description ?? 'Loading...',
                                style: GoogleFonts.inter(fontSize: 14),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                aboutUsData?.sambungan ?? '',
                                style: GoogleFonts.inter(fontSize: 14),
                                textAlign: TextAlign.justify,
                              ),
                            ],
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
                                  "📞 Contact No: ${aboutUsData?.contactNumber ?? 'Loading...'}",
                                  style: GoogleFonts.inter(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "📧 Email: ${aboutUsData?.email ?? 'Loading...'}",
                                  style: GoogleFonts.inter(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "⏰ Operating Hours: ${aboutUsData?.operatingHours ?? 'Loading...'}",
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
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    double.tryParse(
                                          aboutUsData?.locationLat ?? "0.0",
                                        ) ??
                                        0.0,
                                    double.tryParse(
                                          aboutUsData?.locationLng ?? "0.0",
                                        ) ??
                                        0.0,
                                  ),
                                  zoom: 17.0,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  if (!_controller.isCompleted) {
                                    _controller.complete(controller);
                                  }
                                },
                                markers: {
                                  Marker(
                                    markerId: MarkerId('uum'),
                                    position: LatLng(
                                      double.tryParse(
                                            aboutUsData?.locationLat ?? "0.0",
                                          ) ??
                                          0.0,
                                      double.tryParse(
                                            aboutUsData?.locationLng ?? "0.0",
                                          ) ??
                                          0.0,
                                    ),
                                    infoWindow: InfoWindow(
                                      title:
                                          aboutUsData?.locationName ??
                                          'Loading...',
                                      snippet:
                                          aboutUsData?.locationAddress ??
                                          'Loading...',
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
