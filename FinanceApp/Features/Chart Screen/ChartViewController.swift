
import UIKit
import ChartKit

class ChartViewController: UIViewController, Coordinatable, CategoriesSummaryDataSource, CategoriesSummaryDelegate {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
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
    private var addTransactionButton = UIButton(configuration: .plain())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
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
        setupUI()
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, didSelectInterval interval: DateInterval) {
        summaryView.reloadData()
    }
    
    private func setupUI() {
        setupAddTransactionButton()
    }
    
    private func setupAddTransactionButton() {
        view.addSubview(addTransactionButton)
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTransactionButton.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.trailing.bottom.equalTo(chart).inset(6)
        }
        
        var title = AttributedString("Добавить")
        title.setAttributes(AttributeContainer([.font: UIFont.systemFont(ofSize: 14, weight: .medium)]))
        let imageConf = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "plus.square.fill", withConfiguration: imageConf)
        var conf = addTransactionButton.configuration
        conf?.title = "Добавить"
        conf?.image = image
        conf?.attributedTitle = title
        conf?.imagePadding = 3
        addTransactionButton.configuration = conf
        addTransactionButton.addAction(UIAction(handler: { [weak self] _ in
            self?.coordinator?.showAddTransactionVC(callback: nil)
        }), for: .touchUpInside)
    }
}
