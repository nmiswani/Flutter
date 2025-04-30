import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 231, 231),
      appBar: AppBar(
        title: Text(
          "Help",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildContactCard(
            icon: Icons.report_problem,
            title: "Report Issue",
            subtitle: "Report an app issue",
            emailSubject: "Report Issue - POMM App",
            backgroundColor: Colors.red.shade400,
          ),
          _buildContactCard(
            icon: Icons.money_off,
            title: "Refund Request",
            subtitle: "Request for refund",
            emailSubject: "Refund Request - POMM App",
            backgroundColor: Colors.blue.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String emailSubject,
    required Color backgroundColor,
  }) {
    return Card(
      color: backgroundColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Colors.white,
        ),
        onTap: () {
          _launchEmail(emailSubject);
        },
      ),
    );
  }

  Future<void> _launchEmail(String subject) async {
    final String encodedSubject = Uri.encodeComponent(subject);
    final Uri emailUri = Uri.parse(
      'mailto:utgadgetsolution@gmail.com?subject=$encodedSubject',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not open email app", style: GoogleFonts.inter()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
