import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pomm/shared/myserverconfig.dart';

class AdminAboutUsPage extends StatefulWidget {
  const AdminAboutUsPage({super.key});

  @override
  State<AdminAboutUsPage> createState() => _AdminAboutUsPageState();
}

class _AdminAboutUsPageState extends State<AdminAboutUsPage>
    with SingleTickerProviderStateMixin {
  String title = '';
  String description = '';
  String contactNumber = '';
  String email = '';
  String operatingHours = '';
  String locationLat = '';
  String locationLng = '';
  String locationName = '';
  String locationAddress = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            title = data['title'] ?? '';
            description = data['description'] ?? '';
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
            title: const Text('Edit About Us'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: hourCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Operating Hours',
                    ),
                  ),
                  TextField(
                    controller: latCtrl,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                  ),
                  TextField(
                    controller: lngCtrl,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                  ),
                  TextField(
                    controller: locNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Location Name',
                    ),
                  ),
                  TextField(
                    controller: locAddrCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Location Address',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  updateAboutUsData(
                    newTitle: titleCtrl.text,
                    newDescription: descCtrl.text,
                    newContact: phoneCtrl.text,
                    newEmail: emailCtrl.text,
                    newHours: hourCtrl.text,
                    newLat: latCtrl.text,
                    newLng: lngCtrl.text,
                    newLocName: locNameCtrl.text,
                    newLocAddress: locAddrCtrl.text,
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - About Us'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Info'), Tab(text: 'Settings')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1 - Info
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(description),
                const Divider(height: 32),
                Text('Contact Number: $contactNumber'),
                Text('Email: $email'),
                Text('Operating Hours: $operatingHours'),
                const SizedBox(height: 16),
                const Text(
                  'Location Info',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("📍 $locationName"),
                Text("🏠 $locationAddress"),
                Text("🧭 Lat: $locationLat, Lng: $locationLng"),
              ],
            ),
          ),
          // Tab 2 - Settings
          Center(
            child: ElevatedButton(
              onPressed: showEditDialog,
              child: const Text('Edit About Us'),
            ),
          ),
        ],
      ),
    );
  }
}
