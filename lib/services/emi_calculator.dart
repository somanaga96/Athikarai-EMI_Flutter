import 'dart:math';
import '../utils/date_utils.dart';

class EmiCalculator {

  // ================= BANK WAY =================
  static Map<String, dynamic> bankEmi({
    required double principal,
    required double annualRate,
    required int months,
    required DateTime startDate,
  }) {
    double r = annualRate / 12 / 100;
    double emi =
        principal * r * pow(1 + r, months) / (pow(1 + r, months) - 1);

    double balance = principal;
    double totalInterest = 0;

    List<Map<String, dynamic>> schedule = [];

    for (int i = 0; i < months; i++) {
      DateTime emiDate = DateTime(startDate.year, startDate.month + i, 1);

      double interest = balance * r;
      double principalPaid = emi - interest;
      balance -= principalPaid;
      totalInterest += interest;

      schedule.add({
        "month": i + 1,
        "date": emiDate,
        "opening": balance + principalPaid,
        "principal": principalPaid,
        "interest": interest,
        "emi": emi,
        "closing": balance < 0 ? 0 : balance,
      });
    }

    return {
      "emi": emi,
      "totalInterest": totalInterest,
      "totalAmount": principal + totalInterest,
      "schedule": schedule,
    };
  }

  // ================= MY WAY =================
  static Map<String, dynamic> myWay({
    required double principal,
    required double annualRate,
    required int months,
    required DateTime startDate,
  }) {
    double monthlyPrincipal = principal / months;
    double rate = annualRate / 12 / 100;

    double balance = principal;
    double totalInterest = 0;

    List<Map<String, dynamic>> schedule = [];

    for (int i = 0; i < months; i++) {
      DateTime monthBase = DateTime(startDate.year, startDate.month + i, 1);
      DateTime emiDate = firstSaturdayOfMonth(monthBase);

      double interest = balance * rate;
      double emi = monthlyPrincipal + interest;

      balance -= monthlyPrincipal;
      totalInterest += interest;

      schedule.add({
        "month": i + 1,
        "date": emiDate,
        "opening": balance + monthlyPrincipal,
        "principal": monthlyPrincipal,
        "interest": interest,
        "emi": emi,
        "closing": balance < 0 ? 0 : balance,
      });
    }

    return {
      "emi": monthlyPrincipal,
      "totalInterest": totalInterest,
      "totalAmount": principal + totalInterest,
      "schedule": schedule,
    };
  }
}
