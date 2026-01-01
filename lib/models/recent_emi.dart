class RecentEmi {
  final double amount;
  final double rate;
  final int tenure;
  final bool isMyWay;
  final DateTime loanDate;
  final double emi;
  final double totalInterest;

  RecentEmi({
    required this.amount,
    required this.rate,
    required this.tenure,
    required this.isMyWay,
    required this.loanDate,
    required this.emi,
    required this.totalInterest,
  });

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "rate": rate,
        "tenure": tenure,
        "isMyWay": isMyWay,
        "loanDate": loanDate.toIso8601String(),
        "emi": emi,
        "totalInterest": totalInterest,
      };

  factory RecentEmi.fromJson(Map<String, dynamic> json) {
    return RecentEmi(
      amount: json["amount"],
      rate: json["rate"],
      tenure: json["tenure"],
      isMyWay: json["isMyWay"],
      loanDate: DateTime.parse(json["loanDate"]),
      emi: json["emi"],
      totalInterest: json["totalInterest"],
    );
  }
}
