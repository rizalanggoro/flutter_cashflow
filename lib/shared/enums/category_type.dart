enum CategoryType { income, expense }

extension XCategoryType on CategoryType {
  bool get isIncome => this == CategoryType.income;
  bool get isExpense => this == CategoryType.expense;
}
