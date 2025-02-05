
import UIKit
import SnapKit
import ChartKit

class CategoriesSummaryChartContentView: UIView, UIContentView {
    
    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private var intervalButton = DateIntervalButton()
    private var chart: Chart = PieChart()
    private var amountLabel = UILabel()
    
    //MARK: - Lifecycle
    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateConfiguration() {
        guard let conf = self.configuration as? CategoriesSummaryChartConfiguration else { return }
        let chartData = getChartData(from: conf.elements)
        chart.setElements(chartData)
        intervalButton.interval = conf.interval
        amountLabel.text = getAmountSum(from: conf.elements).currency()
    }
    
    //MARK: - UI
    private func setupUI() {
        setupIntervalButton()
        setupChart()
        setupAmountLabel()
    }
    
    private func setupIntervalButton(){
        self.addSubview(intervalButton)
        intervalButton.translatesAutoresizingMaskIntoConstraints = false
        
        intervalButton.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
        }
        
        intervalButton.addAction(UIAction(handler: { [weak self] _ in
            guard let conf = self?.configuration as? CategoriesSummaryChartConfiguration else { return }
            conf.intervalButtonDidPressed?()
        }), for: .touchUpInside)
    }
    
    private func setupChart() {
        guard let chart = self.chart as? PieChart else { return }
        self.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.snp.makeConstraints { maker in
            maker.top.equalTo(intervalButton.snp.bottom).offset(10)
            maker.width.equalTo(chart.snp.height)
            maker.centerX.bottom.equalToSuperview()
        }
        
        chart.delegate = self
        chart.inset = .fraction(0.75)
        chart.innerCornerRadius = 4
        chart.outerCornerRadius = 4
        chart.spaceBetweenSlices = 3
    }
    
    private func setupAmountLabel() {
        self.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        amountLabel.snp.makeConstraints { maker in
            maker.center.equalTo(chart)
            maker.size.lessThanOrEqualTo(chart)
        }
        
        amountLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    //MARK: - Helpers
    private func getChartData(from items: [CategoriesSummaryItem]) -> [ChartElement] {
        let charData = items.map { ChartElement(value: $0.amount, color: $0.color) }
        if charData.isEmpty {
            return [ChartElement(value: 1, color: .systemGray5)]
        }
        return charData
    }
    
    private func getAmountSum(from items: [CategoriesSummaryItem]) -> Double {
        return items.reduce(0, { $0 + $1.amount } )
    }
    
}

extension CategoriesSummaryChartContentView: ChartDelegate {
    func chartDidPressed(_ chart: any Chart) {
        guard let conf = configuration as? CategoriesSummaryChartConfiguration else { return }
        conf.chartDidPressed?()
    }
}
