import 'package:flutter/material.dart';
import '../screens/emi_schedule_page.dart';

class ResultCard extends StatelessWidget {
  final double emi;
  final double totalInterest;
  final double totalAmount;
  final List<Map<String, double>> schedule;

  const ResultCard({
    super.key,
    required this.emi,
    required this.totalInterest,
    required this.totalAmount,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmiSchedulePage(schedule: schedule),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _row("Monthly EMI", emi),
              _row("Total Interest", totalInterest),
              _row("Total Amount", totalAmount),
              const SizedBox(height: 10),
              const Text(
                "Tap to view EMI schedule",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value.toStringAsFixed(0),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
