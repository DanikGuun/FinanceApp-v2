
import UIKit
import ChartKit

class MainVC: UIViewController, CategoriesSummaryDataSource {
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem] {
        var item = CategoriesSummaryItem()
        item.amount = 100
        item.color = [UIColor.red, UIColor.green, UIColor.blue].randomElement()!
        return [item]
    }
    
    
    private var chart: CategoriesSummaryWithIntervalPresenter = CategoriesSummaryChartView()
    
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
