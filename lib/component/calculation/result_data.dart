import 'package:flutter/material.dart';

class EmiResult extends StatelessWidget {
  final String amount;
  final double period;
  final String interest;
  final bool canShow;

  const EmiResult({
    Key? key,
    required this.amount,
    required this.canShow,
    required this.interest,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return emiResultWidget(amount, period, interest, canShow);
  }

  Widget emiResultWidget(
      String amount, double period, String interest, bool canShow) {
    if (amount.isNotEmpty) {
      canShow = true;
    }
    double ratePerMonth = (double.parse(interest) / 100) / 12;
    double interestAmount = 0;
    double interestSum = 0;
    double term = double.parse(amount) / period;
    double _amount = double.parse(amount);
    double totalAmount = 0;

    for (var i = 1; i <= period; i++) {
      interestAmount = _amount * ratePerMonth;
      interestSum += interestAmount;
      _amount -= term;
    }
    totalAmount = double.parse(amount) + interestSum;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: canShow
          ? Column(children: [
              Table(
                  defaultColumnWidth: const FixedColumnWidth(170.0),
                  border: TableBorder.all(
                      color: Colors.black, style: BorderStyle.solid, width: 2),
                  children: [
                    TableRow(children: [
                      const Column(children: [
                        Text('Amount', style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: [
                        Text(amount, style: const TextStyle(fontSize: 20.0))
                      ]),
                    ]),
                    TableRow(children: [
                      const Column(children: [
                        Text('Total Interest paid',
                            style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: [
                        Text(interestSum.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                    ]),
                    TableRow(children: [
                      const Column(children: [
                        Text('Total Amount paid',
                            style: TextStyle(fontSize: 20.0))
                      ]),
                      Column(children: [
                        Text(totalAmount.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 20.0))
                      ]),
                    ]),
                  ]),
            ])
          : Container(),
    );
  }
}
