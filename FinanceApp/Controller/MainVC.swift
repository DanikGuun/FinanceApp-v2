
import UIKit
import ChartKit

class MainVC: UIViewController, CategoriesSummaryDataSource {
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem] {
        var items: [CategoriesSummaryItem] = []
        for _ in 0..<10 {
            let amount = Double.random(in: 10..<50)
            let color = [UIColor.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemOrange, .systemTeal, .systemPurple, .systemPink, .systemGray2, .systemGray5].randomElement()!
            let item = CategoriesSummaryItem(amount: amount, color: color)
            items.append(item)
        }
        return items
    }
    
    
    private var chart: CategoriesSummaryPresenter = CategoriesSummaryChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(80)
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.height.equalTo(300)
        }
        
        chart.backgroundColor = .systemGray6
        chart.dataSource = self
    }
}
