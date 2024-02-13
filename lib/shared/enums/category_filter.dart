@Deprecated('Gunakan category type')
enum CategoryFilter { all, income, expense }

@Deprecated('Gunakan category type')
extension XCategoryFilter on CategoryFilter {
  bool get isAll => this == CategoryFilter.all;
  bool get isIncome => this == CategoryFilter.income;
  bool get isExpense => this == CategoryFilter.expense;
}
