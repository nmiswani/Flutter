import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/models/aboutus.dart';
import 'package:pomm/models/admin.dart';
import 'package:pomm/shared/myserverconfig.dart';
import 'package:pomm/views/admin/adminaboutdashboard.dart';
import 'package:pomm/views/loginclerkadminpage.dart';

class AdminAboutUsPage extends StatefulWidget {
  final Admin admin;
  const AdminAboutUsPage({super.key, required this.admin});

  @override
  State<AdminAboutUsPage> createState() => _AdminAboutUsPageState();
}

class _AdminAboutUsPageState extends State<AdminAboutUsPage>
    with SingleTickerProviderStateMixin {
  String title = '';
  String description = '';
  String sambungan = '';
  String contactNumber = '';
  String email = '';
  String operatingHours = '';
  String locationLat = '';
  String locationLng = '';
  String locationName = '';
  String locationAddress = '';

  late TabController _tabController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool isLoading = true;
  AboutUs? aboutUsData;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentTabIndex = _tabController.index;
      });
    });
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    final url = Uri.parse("${MyServerConfig.server}/pomm/php/get_aboutus.php");

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        print(jsonData); // Untuk debug sahaja

        if (jsonData['success']) {
          final data = jsonData['data'];
          setState(() {
            aboutUsData = AboutUs.fromJson(jsonData['data']);
            isLoading = false;

            title = data['title'] ?? '';
            description = data['description'] ?? '';
            sambungan = data['sambungan'] ?? '';
            contactNumber = data['contact_number'] ?? '';
            email = data['email'] ?? '';
            operatingHours = data['operating_hours'] ?? '';
            locationLat = data['location_lat'] ?? '';
            locationLng = data['location_lng'] ?? '';
            locationName = data['location_name'] ?? '';
            locationAddress = data['location_address'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateAboutUsData({
    required String newTitle,
    required String newDescription,
    required String newSambungan,
    required String newContact,
    required String newEmail,
    required String newHours,
    required String newLat,
    required String newLng,
    required String newLocName,
    required String newLocAddress,
  }) async {
    final response = await http.post(
      Uri.parse('${MyServerConfig.server}/pomm/php/update_aboutus.php'),
      body: {
        'title': newTitle,
        'description': newDescription,
        'sambungan': newSambungan,
        'contact_number': newContact,
        'email': newEmail,
        'operating_hours': newHours,
        'location_lat': newLat,
        'location_lng': newLng,
        'location_name': newLocName,
        'location_address': newLocAddress,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Information updated successful",
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Berjaya
        print("Data berjaya dikemaskini.");
      } else {
        // Error dari SQL - paparkan mesej
        print("Gagal: ${jsonData["message"]}");
      }
    } else {
      // Masalah rangkaian
      print("Gagal sambung ke server: ${response.statusCode}");
    }
  }

  void showEditDialog() {
    final titleCtrl = TextEditingController(
      text: title.isNotEmpty ? title : '',
    );
    final descCtrl = TextEditingController(
      text: description.isNotEmpty ? description : '',
    );
    final sambunganCtrl = TextEditingController(
      text: sambungan.isNotEmpty ? sambungan : '',
    );
    final phoneCtrl = TextEditingController(
      text: contactNumber.isNotEmpty ? contactNumber : '',
    );
    final emailCtrl = TextEditingController(
      text: email.isNotEmpty ? email : '',
    );
    final hourCtrl = TextEditingController(
      text: operatingHours.isNotEmpty ? operatingHours : '',
    );
    final latCtrl = TextEditingController(
      text: locationLat.isNotEmpty ? locationLat : '',
    );
    final lngCtrl = TextEditingController(
      text: locationLng.isNotEmpty ? locationLng : '',
    );
    final locNameCtrl = TextEditingController(
      text: locationName.isNotEmpty ? locationName : '',
    );
    final locAddrCtrl = TextEditingController(
      text: locationAddress.isNotEmpty ? locationAddress : '',
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            title: Text(
              "Update information",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: descCtrl,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: sambunganCtrl,
                    decoration: InputDecoration(
                      labelText: 'Next Description',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: phoneCtrl,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: hourCtrl,
                    decoration: InputDecoration(
                      labelText: 'Operating Hours',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: latCtrl,
                    decoration: InputDecoration(
                      labelText: 'Latitude',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: lngCtrl,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: locNameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Location Name',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: locAddrCtrl,
                    decoration: InputDecoration(
                      labelText: 'Location Address',
                      labelStyle: GoogleFonts.inter(),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.inter()),
              ),
              TextButton(
                onPressed: () {
                  updateAboutUsData(
                    newTitle: titleCtrl.text,
                    newDescription: descCtrl.text,
                    newSambungan: sambunganCtrl.text,
                    newContact: phoneCtrl.text,
                    newEmail: emailCtrl.text,
                    newHours: hourCtrl.text,
                    newLat: latCtrl.text,
                    newLng: lngCtrl.text,
                    newLocName: locNameCtrl.text,
                    newLocAddress: locAddrCtrl.text,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              AdminAboutDashboardPage(admin: widget.admin),
                    ),
                  );
                },
                child: Text('Update', style: GoogleFonts.inter()),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 243, 247),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(105),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Admin Dashboard",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2.5),
                  Text(
                    "Utara Gadget Solution Store",
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => LoginClerkAdminPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Contact & Location'),
              ],
              labelColor: Colors.white,
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            /// Tab 1: Info
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
                                  width: MediaQuery.of(context).size.width,
                                  errorBuilder: (context, error, stackTrace) {
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
                    title,
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
                          description,
                          style: GoogleFonts.inter(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          sambungan,
                          style: GoogleFonts.inter(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
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
                            "📞 Contact No: $contactNumber",
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "📧 Email: $email",
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "⏰ Operating Hours: $operatingHours",
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
                    margin: const EdgeInsets.all(2),
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
                              double.tryParse(locationLat) ?? 0.0,
                              double.tryParse(locationLng) ?? 0.0,
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
                              markerId: const MarkerId('storeLocation'),
                              position: LatLng(
                                double.tryParse(locationLat) ?? 0.0,
                                double.tryParse(locationLng) ?? 0.0,
                              ),
                              infoWindow: InfoWindow(
                                title: locationName,
                                snippet: locationAddress,
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
        floatingActionButton:
            currentTabIndex == 0
                ? FloatingActionButton(
                  onPressed: showEditDialog,
                  backgroundColor: Colors.black,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.edit, color: Colors.white),
                )
                : null,
      ),
    );
  }
}
