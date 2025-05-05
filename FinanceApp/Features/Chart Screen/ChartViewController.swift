
import UIKit
import ChartKit

class ChartViewController: UIViewController, CategoriesSummaryDataSource, CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem] {
        var items: [CategoriesSummaryItem] = []
        for _ in 0..<10 {
            let amount = Double.random(in: 10..<5000000)
            let color = [UIColor.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemOrange, .systemTeal, .systemPurple, .systemPink, .systemGray2, .systemGray5].randomElement()!
            let item = CategoriesSummaryItem(amount: amount, color: color, title: "Транспорт", image: UIImage(systemName: "bus.fill"))
            items.append(item)
        }
        return items
    }
    
    
    private var chart: CategoriesSummaryPresenter = CategoriesSummaryChartView()
    private var summaryView: CategoriesSummaryPresenter = CategorySummaryView()
    
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
        chart.delegate = self
        
        self.view.addSubview(summaryView)
        self.view.sendSubviewToBack(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.snp.makeConstraints { maker in
            maker.top.equalTo(chart.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        summaryView.dataSource = self
        summaryView.backgroundColor = .clear
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, didSelectInterval interval: DateInterval) {
        summaryView.reloadData()
    }
}
