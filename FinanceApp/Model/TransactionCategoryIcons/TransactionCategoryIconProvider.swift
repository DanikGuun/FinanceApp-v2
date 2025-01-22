
protocol TransactionCategoryIconProvider {
    
    func getIcons() -> [TransactionCategoryIcon]
    func getIcon(id: String) -> TransactionCategoryIcon?
    func getIconsWithType() -> [TransactionCategoryIconKind: [TransactionCategoryIcon]]
    
}

