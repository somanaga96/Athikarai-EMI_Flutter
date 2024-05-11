import 'package:flutter/material.dart';
import '../calculation/result_data.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final String amount;
  final String rate;
  final double period;
  final bool canShow;
  const DetailScreen(
    this.amount,
    this.rate,
    this.period,
    this.canShow, {
    Key? key,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    double _amount = double.parse(widget.amount);
    final double _rate = double.parse(widget.rate);
    double term = _amount / widget.period;
    double ratePerMonth = (_rate / 100) / 12;
    double interest = 0;

    String d = DateFormat('dd-MM-yy').format(DateTime.now());

    List<TableRow> ans() {
      List<TableRow> result = [];
      for (var i = 1; i <= widget.period; i++) {
        interest = _amount * ratePerMonth;
        result.add(tableRowValue(i, d, _amount, interest, term));
        _amount -= term;
      }
      return result;
    }

    return Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text("EMI"),
        )),
        body: SingleChildScrollView(
          child: Column(children: [
            EmiResult(
              amount: widget.amount,
              period: widget.period,
              interest: widget.rate,
              canShow: widget.canShow,
            ),
            _headline(),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
              },
              border: TableBorder.all(color: Colors.blue, width: 2.5),
              children: ans(),
            )
          ]),
        ));
  }

  TableRow tableRowValue(
      var i, String date, double amount, double interest, double term) {
    //  double outstanding = interest + term;
    double emi = term + interest;
    return TableRow(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(i.toString(), style: const TextStyle(fontSize: 18.0)),
      ]),
      // Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      //   Text(date.toString(), style: const TextStyle(fontSize: 18.0)),
      // ]),
      Column(children: [
        Text(amount.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 20.0,
            ))
      ]),
      Column(children: [
        Text(interest.toStringAsFixed(2),
            style: const TextStyle(fontSize: 20.0)),
      ]),
      Column(children: [
        Text(emi.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 20.0,
            ))
      ]),
    ]);
  }

  _headline() {
    return Container(
      color: Colors.blue,
      margin: const EdgeInsets.only(top: 30),
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          Column(
            children: const [
              Text("No", style: TextStyle(fontSize: 20.0)),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: const [
              Text("Amount",
                  style: TextStyle(
                    fontSize: 20.0,
                  ))
            ],
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
            children: const [
              Text("Interest", style: TextStyle(fontSize: 20.0))
            ],
          ),
          const SizedBox(
            width: 70,
          ),
          Column(
            children: const [Text("EMI", style: TextStyle(fontSize: 20.0))],
          )
        ],
      ),
    );
  }
}
