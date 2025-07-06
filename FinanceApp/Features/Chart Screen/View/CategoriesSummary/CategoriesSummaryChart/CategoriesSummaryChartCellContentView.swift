
import UIKit
import SnapKit
import ChartKit

class CategoriesSummaryChartCellContentView: UIView, UIContentView {
    
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
        let conf = getConfiguration()
        updateChart()
        updateIntervalButton()
        amountLabel.text = getAmountSum(from: conf.elements).currency()
    }
    
    private func updateChart() {
        let conf = getConfiguration()
        let chartData = getChartData(from: conf.elements)
        chart.setElements(chartData)
        updateChartActions()
    }
    
    private func updateChartActions(){
        let conf = getConfiguration()
        
        if let chart = chart as? UIControl {
            chart.removeAllActions()
            chart.addAction(UIAction(handler: { _ in
                conf.chartDidPressed?(conf.elements)
            }), for: .touchUpInside)
        }
    }
    
    private func updateIntervalButton() {
        let conf = getConfiguration()
        intervalButton.interval = conf.interval
        intervalButton.removeAllActions()
        intervalButton.addAction(UIAction(handler: { [weak self] _ in
            conf.intervalButtonDidPressed?(self?.intervalButton.interval ?? DateInterval())
        }), for: .touchUpInside)
    }
    
    //MARK: - UI
    private func setupUI() {
        self.backgroundColor = .clear
        setupIntervalButton()
        setupChart()
        setupAmountLabel()
    }
    
    private func setupIntervalButton(){
        self.addSubview(intervalButton)
        intervalButton.translatesAutoresizingMaskIntoConstraints = false
        
        intervalButton.snp.makeConstraints { maker in
            maker.top.centerX.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func setupChart() {
        guard let chart = self.chart as? PieChart else { return }
        self.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.snp.makeConstraints { maker in
            maker.top.equalTo(intervalButton.snp.bottom).offset(10).priority(.low)
            maker.centerX.bottom.equalToSuperview()
            maker.width.equalTo(chart.snp.height)
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
    
    private func getConfiguration() -> CategoriesSummaryChartCellConfiguration {
        if let conf = configuration as? CategoriesSummaryChartCellConfiguration {
            return conf
        }
        return CategoriesSummaryChartCellConfiguration()
    }
    
}

extension CategoriesSummaryChartCellContentView: ChartDelegate {
    func chartDidPressed(_ chart: any Chart) {
        let conf = getConfiguration()
        conf.chartDidPressed?(conf.elements)
    }
}
