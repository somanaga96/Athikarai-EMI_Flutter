import 'package:flutter/material.dart';

class EmiSchedulePage extends StatelessWidget {
  final List<Map<String, dynamic>> schedule;

  const EmiSchedulePage({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EMI Schedule")),
      body: SafeArea(
        // ✅ uses only visible device area
        top: false, // AppBar already handles top
        bottom: true,
        left: true,
        right: true,
        child: SizedBox.expand(
          // ✅ takes full device width & height
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _TableHeaderDelegate(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _TableRow(row: schedule[index]);
                  },
                  childCount: schedule.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= HEADER ================= */

class _TableHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 46;

  @override
  double get maxExtent => 46;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity, // ✅ full device width
      color: Colors.blue.shade100,
      child: const Row(
        children: [
          _HeaderCell("Month / Date", flex: 2, alignLeft: true),
          _HeaderCell("Interest", flex: 1),
          _HeaderCell("EMI", flex: 1),
          _HeaderCell("Closing", flex: 1),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TableHeaderDelegate oldDelegate) => false;
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool alignLeft;

  const _HeaderCell(
    this.text, {
    required this.flex,
    this.alignLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment:
            alignLeft ? Alignment.centerLeft : Alignment.center,
        child: Padding(
          padding: alignLeft
              ? const EdgeInsets.only(left: 12)
              : EdgeInsets.zero,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= ROW ================= */

class _TableRow extends StatelessWidget {
  final Map<String, dynamic> row;

  const _TableRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final DateTime d = row["date"];

    return Container(
      width: double.infinity, // ✅ full width
      height: 46,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          _MonthDateCell(
            month: row["month"],
            date: d,
          ),
          _Cell(_fmt(row["interest"])),
          _Cell(_fmt(row["emi"])),
          _Cell(_fmt(row["closing"])),
        ],
      ),
    );
  }

  String _fmt(num v) => v.toStringAsFixed(0);
}

/* ================= CUSTOM CELLS ================= */

class _MonthDateCell extends StatelessWidget {
  final int month;
  final DateTime date;

  const _MonthDateCell({
    required this.month,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "EMI $month",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${date.day}/${date.month}/${date.year}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String value;

  const _Cell(this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
