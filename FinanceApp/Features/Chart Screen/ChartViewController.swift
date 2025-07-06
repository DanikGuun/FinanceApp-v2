
import UIKit
import ChartKit

class ChartViewController: UIViewController, Coordinatable, CategoriesSummaryDataSource, CategoriesSummaryDelegate {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    var model: ChartModel!
    
    private var categoryTypeControl = UISegmentedControl()
    private var chart: CategoriesSummaryPresenter = CategoriesSummaryChartView()
    private var summaryView: CategoriesSummaryPresenter = CategorySummaryView()
    private var addTransactionButton = UIButton(configuration: .plain())
    
    private var currentInterval = Calendar.current.dateInterval(of: .day, for: Date())! { didSet { reloadSummaryView() } }
    private var currentCategoryType: CategoryType {
        [CategoryType.expense, .income][categoryTypeControl.selectedSegmentIndex]
    }
    
    //MARK: - Lifecycle
    public convenience init(model: ChartModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Сводка"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    //MARK: - UI
    private func setupUI() {
        setupCategoryTypeControl()
        setupChart()
        setupCategoriesSummary()
        setupAddTransactionButton()
    }
    
    private func setupCategoryTypeControl() {
        view.addSubview(categoryTypeControl)
        categoryTypeControl.translatesAutoresizingMaskIntoConstraints = false
        categoryTypeControl.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.view.safeAreaLayoutGuide).inset(14)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }
        
        categoryTypeControl.insertSegment(withTitle: "Расходы", at: 0, animated: false)
        categoryTypeControl.insertSegment(withTitle: "Доходы", at: 1, animated: false)
        categoryTypeControl.selectedSegmentIndex = 0
        categoryTypeControl.addAction(UIAction(handler: { [weak self] _ in
            self?.reloadData()
        }), for: .valueChanged)
    }
    
    private func setupChart() {
        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.top.equalTo(self.categoryTypeControl.snp.bottom).offset(DC.titleAndItemSpacing)
            maker.leading.trailing.equalToSuperview().inset(20)
            maker.height.equalTo(300)
        }
        
        chart.backgroundColor = .systemGray6
        chart.dataSource = self
        chart.delegate = self
    }
    
    private func setupCategoriesSummary() {
        self.view.addSubview(summaryView)
        self.view.sendSubviewToBack(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.snp.makeConstraints { maker in
            maker.top.equalTo(chart.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        summaryView.dataSource = self
        summaryView.delegate = self
        summaryView.backgroundColor = .clear
    }
    
    private func setupAddTransactionButton() {
        view.addSubview(addTransactionButton)
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTransactionButton.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.trailing.bottom.equalTo(chart).inset(6)
        }
        
        var title = AttributedString("Добавить")
        title.setAttributes(AttributeContainer([.font:  DC.Font.medium(size: 14)]))
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
    
    //MARK: - Data source
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem] {
        let meta = model.getCategoriesSummary(type: currentCategoryType, interval: interval)
        let items = meta.map { getSummaryItem(category: $0) }
        return items
    }
    
    private func getSummaryItem(category: TransactionCategoryMeta) -> CategoriesSummaryItem {
        let item = CategoriesSummaryItem(id: category.id,
                                     amount: category.amount,
                                     color: category.color,
                                     title: category.name,
                                     image: getIcon(iconId: category.iconId))
        return item
    }
    
    private func getIcon(iconId: String) -> UIImage? {
        return model.getIcon(iconId: iconId)
    }
    
    //MARK: - Delegate
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, didSelectInterval interval: DateInterval) {
        currentInterval = interval
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem?) {
        print(category?.title)
    }
    
    private func reloadData() {
        chart.reloadData()
        reloadSummaryView()
    }
    
    private func reloadSummaryView() {
        summaryView.interval = currentInterval
        summaryView.reloadData()
    }
    
}
