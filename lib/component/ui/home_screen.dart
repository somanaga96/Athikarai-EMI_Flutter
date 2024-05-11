import 'package:flutter/material.dart';

import '../calculation/result_data.dart';
import 'details_screen.dart';

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final List _tenureTypes = ["Months", "Years"];
  String _tenureType = "Months";
  final TextEditingController amount = TextEditingController();
  final TextEditingController months = TextEditingController();
  final TextEditingController rate = TextEditingController();
  bool _switchValue = false;

  bool canShow = false;
  double period = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _input("Amount", amount),
            _periodInput(months),
            _input("Interest", rate),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buttons("Calculate"),
                _buttons("Reset"),
                if (canShow == true) _buttons("Details")
              ],
            ),
            canShow
                ? EmiResult(
                    amount: amount.text,
                    interest: rate.text,
                    canShow: canShow,
                    period: period,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  TextButton _buttons(String buttonName) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.blue,
      ),
      onPressed: () {
        if (buttonName == "Reset") {
          rate.clear();
          months.clear();
          amount.clear();
          setState(() {
            canShow = false;
          });
        } else if (buttonName == "Calculate" &&
            amount.text != "" &&
            months.text != "") {
          setState(() {
            canShow = true;
          });
          if (_tenureType == "Years") {
            period = _tenureType == "Years"
                ? double.parse(months.text) * 12
                : double.parse(months.text);
          } else if (_tenureType == "Months") {
            period = double.parse(months.text);
          }
        } else if (buttonName == "Details") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(
                      amount.text,
                      rate.text,
                      period,
                      canShow,
                    )),
          );
        }
      },
      child: Text(buttonName),
    );
  }

  Row _periodInput(TextEditingController months) {
    return Row(
      children: [
        Flexible(flex: 5, child: _input(_tenureType, months)),
        Flexible(
            flex: 1,
            child: Column(
              children: [
                Text(_tenureType,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Switch(
                    value: _switchValue,
                    onChanged: (bool value) {
                      if (value) {
                        _tenureType = _tenureTypes[1];
                      } else {
                        _tenureType = _tenureTypes[0];
                      }
                      setState(() {
                        _switchValue = value;
                      });
                    })
              ],
            ))
      ],
    );
  }

  Container _input(String value, TextEditingController val) => Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        child: TextField(
          controller: val,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: (value),
              suffixIcon: IconButton(
                  onPressed: () {
                    if (value == "Amount") {
                      amount.clear();
                    } else if (value == "Months" || value == "Years") {
                      months.clear();
                    } else if (value == "Interest") {
                      rate.clear();
                    }
                  },
                  icon: const Icon(Icons.clear))),
          keyboardType: TextInputType.number,
        ),
      );
}
