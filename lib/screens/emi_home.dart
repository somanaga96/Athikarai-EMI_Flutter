import 'package:flutter/material.dart';
import '../services/emi_calculator.dart';
import '../services/recent_emi_storage.dart';
import '../models/recent_emi.dart';
import 'emi_schedule_page.dart';

class EmiHome extends StatefulWidget {
  const EmiHome({super.key});

  @override
  State<EmiHome> createState() => _EmiHomeState();
}

class _EmiHomeState extends State<EmiHome> {
  final amountCtrl = TextEditingController(text: "10000");
  final rateCtrl = TextEditingController(text: "12");
  final tenureCtrl = TextEditingController(text: "12");

  bool isMyWay = false;
  DateTime loanDate = DateTime.now();
  Map<String, dynamic>? result;

  List<RecentEmi> recentEmis = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _loadRecent();
  // }
  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  _loadRecent();
}


 Future<void> _loadRecent() async {
  final data = await RecentEmiStorage.load();
  print("Loaded recents: ${data.length}");
  setState(() => recentEmis = data);
}


 Future<void> calculate() async {
  final principal = double.parse(amountCtrl.text);
  final rate = double.parse(rateCtrl.text);
  final months = int.parse(tenureCtrl.text);

  final res = isMyWay
      ? EmiCalculator.myWay(
          principal: principal,
          annualRate: rate,
          months: months,
          startDate: loanDate,
        )
      : EmiCalculator.bankEmi(
          principal: principal,
          annualRate: rate,
          months: months,
          startDate: loanDate,
        );

  setState(() => result = res);

  await RecentEmiStorage.save(
    RecentEmi(
      amount: principal,
      rate: rate,
      tenure: months,
      isMyWay: isMyWay,
      loanDate: loanDate,
      emi: res["emi"],
      totalInterest: res["totalInterest"],
    ),
  );

  await _loadRecent(); // 🔥 IMPORTANT
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: AppBar(title: const Text("EMI Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Loan Details"),
            _inputCard(),
            const SizedBox(height: 20),

            _sectionTitle("EMI Type"),
            _emiTypeCard(),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
  onPressed: () async {
    await calculate();
  },
  child: const Text("Calculate EMI"),
),
            ),

            if (result != null) ...[
              const SizedBox(height: 20),
              _resultCard(),
            ],

            if (recentEmis.isNotEmpty) ...[
              const SizedBox(height: 30),
              _sectionTitle("Recent Calculations"),
              ...recentEmis.map(_recentTile),
            ],
          ],
        ),
      ),
    );
  }

  /* ---------- UI ---------- */

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  Widget _inputCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _textField("Loan Amount", amountCtrl),
              _textField("Interest %", rateCtrl),
              _textField("Tenure (Months)", tenureCtrl),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                    "Loan Date: ${loanDate.day}/${loanDate.month}/${loanDate.year}"),
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: loanDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) setState(() => loanDate = d);
                },
              ),
            ],
          ),
        ),
      );

  Widget _emiTypeCard() => Card(
        child: SwitchListTile(
          title: Text(isMyWay ? "My Way EMI" : "Bank EMI"),
          subtitle:
              Text(isMyWay ? "First Saturday" : "1st of every month"),
          value: isMyWay,
          onChanged: (v) => setState(() => isMyWay = v),
        ),
      );

  Widget _resultCard() => Card(
        child: ListTile(
          title:
              Text("Monthly EMI: ${result!["emi"].toStringAsFixed(0)}"),
          subtitle: Text(
              "Total Interest: ${result!["totalInterest"].toStringAsFixed(0)}"),
          trailing: const Icon(Icons.table_chart),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    EmiSchedulePage(schedule: result!["schedule"]),
              ),
            );
          },
        ),
      );

  Widget _recentTile(RecentEmi r) => Card(
        child: ListTile(
          leading: Icon(r.isMyWay ? Icons.star : Icons.account_balance),
          title: Text(
              "₹${r.amount.toInt()} • ${r.tenure}M • ${r.rate}%"),
          subtitle: Text(
              "EMI ${r.emi.toStringAsFixed(0)} | ${r.loanDate.day}/${r.loanDate.month}/${r.loanDate.year}"),
         onTap: () async {
  final res = r.isMyWay
      ? EmiCalculator.myWay(
          principal: r.amount,
          annualRate: r.rate,
          months: r.tenure,
          startDate: r.loanDate,
        )
      : EmiCalculator.bankEmi(
          principal: r.amount,
          annualRate: r.rate,
          months: r.tenure,
          startDate: r.loanDate,
        );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EmiSchedulePage(
        schedule: res["schedule"],
      ),
    ),
  );
},

        ),
      );

  Widget _textField(String label, TextEditingController c) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label),
        ),
      );
}
