import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 231, 231),
      appBar: AppBar(
        title: Text(
          "User Guide",
          style: GoogleFonts.inter(color: Colors.white, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Text(
              "How to use POMM app:",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          _buildStep(
            number: "1",
            title: "Register & Login",
            description:
                "Create an account using your email and password. If you already have an account, simply log in.",
          ),
          _buildStep(
            number: "2",
            title: "Browse Products",
            description:
                "Go to the product page to view a list of items available from Utara Gadget Solution Store.",
          ),
          _buildStep(
            number: "3",
            title: "Add to Cart",
            description:
                "Click on a product to view details, then tap 'Add to cart' to save it before purchasing.",
          ),
          _buildStep(
            number: "4",
            title: "Checkout & Make Payment",
            description:
                "Open your cart and proceed to checkout. Follow the steps to complete your payment.",
          ),
          _buildStep(
            number: "5",
            title: "Track Order",
            description:
                "After payment, you can track the status of your order from the 'Order' page.",
          ),
          _buildStep(
            number: "6",
            title: "Email Notification",
            description:
                "All order status updates will be automatically sent to your registered email.",
          ),
          _buildStep(
            number: "7",
            title: "Get Help or Refund",
            description:
                "If you face any issue, go to the 'Help' page to report a problem or request a refund.",
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "Enjoy your shopping with us!",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.red,
            child: Text(
              number,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: GoogleFonts.inter(fontSize: 12.5, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
