import '../../../../data/models/transaction.dart';

class ChartDetailData {
  final DateTime dateTime;
  final List<TransactionModel> transactions;
  final double totalIncome, totalExpense;

  ChartDetailData({
    required this.dateTime,
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
  });
}
