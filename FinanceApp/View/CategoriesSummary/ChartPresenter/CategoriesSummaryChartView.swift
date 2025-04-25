
import UIKit

class CategoriesSummaryChartView: UIView, CategoriesSummaryPresenter, UICollectionViewDelegate {
    
    var interval: DateInterval { 
        get { return dateManager.interval }
        set {
            dateManager.interval = newValue
            intervalHasBeenUpdated()
        }
    }
    var intervalType: IntervalType {
        get { return dateManager.intervalType }
        set {
            dateManager.intervalType = newValue
            intervalHasBeenUpdated()
        }
    }
    
    var delegate: (any CategoriesSummaryDelegate)?
    var dataSource: CategoriesSummaryDataSource? { didSet { reloadData() } }

    private var dateManager = IntervalManager()
    private var isFirstLayout = true
    private var endScrollType: EndScrollType = .none
    private var intervalTypeControl = UISegmentedControl()
    private var chartCollection = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    private var chartCollectionDataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    private var activeChartItems = ActiveChartItems()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        reloadActiveChartItems()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirstLayout{
            isFirstLayout = false
            scrollCollectionToMid()
        }
    }
    
    //MARK: - UI
    private func setupUI() {
        setupSegmentedControl()
        setupChartCollection()
    }
    
    //MARK: - Interval Segmented Picker
    private func setupSegmentedControl() {
        self.addSubview(intervalTypeControl)
        intervalTypeControl.translatesAutoresizingMaskIntoConstraints = false
        
        intervalTypeControl.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview().inset(10)
        }
        
        intervalTypeControl.apportionsSegmentWidthsByContent = true
        for (index, type) in IntervalType.allCases().enumerated() {
            intervalTypeControl.insertSegment(action: UIAction(title: type.description, handler: { _ in
            }), at: index, animated: false)
        }
        intervalTypeControl.selectedSegmentIndex = 0
        intervalTypeControl.addAction(UIAction(handler: updateInterval), for: .valueChanged)
    }
    
    private func updateInterval(_ sender: Any?) {
        self.intervalType = IntervalType.allCases()[self.intervalTypeControl.selectedSegmentIndex]
        if self.intervalType == .custom(interval: dateManager.interval) {
            chartCollection.isScrollEnabled = false
        }
        else {
            chartCollection.isScrollEnabled = true
        }
    }
    
    //MARK: Collection Delegate
    
    private func setupChartCollection() {
        self.addSubview(chartCollection)
        chartCollection.translatesAutoresizingMaskIntoConstraints = false
        
        chartCollection.snp.makeConstraints { maker in
            maker.top.equalTo(intervalTypeControl.snp.bottom).offset(5)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().inset(20)
        }
        
        chartCollection.delegate = self
        chartCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        chartCollection.isPagingEnabled = true
        chartCollection.showsHorizontalScrollIndicator = false
        chartCollection.backgroundColor = .clear
        setupChartCollectionDataSource()
        reloadChartCollectionSnapshot()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setNeedUpdateActiveChartItems(for: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isMidItemSoLong() == false {
            updateActiveChartItemsIfNeeded()
        }
    }
    
    //MARK: - Chart Collection
    private func setupChartCollectionDataSource() {
        chartCollectionDataSource = UICollectionViewDiffableDataSource<UUID, UUID>(
            collectionView: chartCollection, cellProvider: { [weak self] (collectionView, indexPath, id) in
                
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            var conf = CategoriesSummaryChartConfiguration()
            if let item = self?.activeChartItems.item(id: id) {
                conf.elements = item.elements
                conf.interval = item.interval
                
                conf.chartDidPressed = { elements in
                    print("chart")
                }
                conf.intervalButtonDidPressed = { interval in
                    print("interval")
                }
            }
            cell.contentConfiguration = conf
            return cell
                
        })
    }
    
    private func reloadChartCollectionSnapshot() {
        let id1 = activeChartItems.first.id
        let id2 = activeChartItems.second.id
        
        var chartCollectionSnapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        chartCollectionSnapshot.appendSections([UUID()])
        chartCollectionSnapshot.appendItems([id1, id2])
        if activeChartItems.third.interval.start < Date() {
            let id3 = activeChartItems.third.id
            chartCollectionSnapshot.appendItems([id3])
        }
        chartCollectionDataSource.apply(chartCollectionSnapshot, animatingDifferences: false)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let conf = UICollectionViewCompositionalLayoutConfiguration()
        conf.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: conf)
        return layout
    }
    
    private func isMidItemSoLong() -> Bool {
        guard let midItem = chartCollection.cellForItem(at: IndexPath(row: 1, section: 0)) else { return false }
        let midItemSize = chartCollection.bounds.intersection(midItem.frame).size
        return midItemSize.width != 0
    }
    
    private func scrollCollectionToMid() {
        let indexPath = IndexPath(row: 1, section: 0)
        chartCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    
    //MARK: - Active Chart Items
    private func setNeedUpdateActiveChartItems(for indexPath: IndexPath){
        guard let id = chartCollectionDataSource.itemIdentifier(for: indexPath) else { return }
        if id == activeChartItems.first.id {
            endScrollType = .left
        }
        else if id == activeChartItems.third.id {
            endScrollType = .right
        }
        else {
            endScrollType = .none
        }
    }
    
    private func updateActiveChartItemsIfNeeded() {
        if endScrollType == .left {
            dateManager.decrement()
        }
        else if endScrollType == .right {
            dateManager.increment()
        }
        
        if isCollectionRunningOutFromRightBoundary() == false {
            reloadData()
            scrollCollectionToMid()
        }
        endScrollType = .none
    }
    
    private func isCollectionRunningOutFromRightBoundary() -> Bool {
        return dateManager.interval.end >= Date() && endScrollType == .right
    }
    
    private func reloadActiveChartItems() {
        guard let dataSource = getDateSource() else { return }
    
        let firstElements = dataSource.categoriesSummary(self, getSummaryItemsFor: dateManager.decremented())
        activeChartItems.first = ChartCollectionItem(elements: firstElements)
        activeChartItems.first.interval = dateManager.decremented()
        
        let secondElements = dataSource.categoriesSummary(self, getSummaryItemsFor: dateManager.interval)
        activeChartItems.second = ChartCollectionItem(elements: secondElements)
        activeChartItems.second.interval = dateManager.interval
        
        let thirdElements = dataSource.categoriesSummary(self, getSummaryItemsFor: dateManager.incremented())
        activeChartItems.third = ChartCollectionItem(elements: thirdElements)
        activeChartItems.third.interval = dateManager.incremented()
    }
    
    //MARK: - Handlers
    private func intervalHasBeenUpdated() {
        reloadData()
        delegate?.categoriesSummary(self, didSelectInterval: interval)
    }
    
    func requestToOpenIntervalPicker() {
        delegate?.categoriesSummary(self, requestToOpenIntervalPicker: intervalType)
    }
    
    func requestToOpenIntervalSummary() {
        delegate?.categoriesSummary(self, openSummaryControllerFor: interval, category: nil)
    }
    
    func reloadData() {
        reloadActiveChartItems()
        reloadChartCollectionSnapshot()
    }
    
    private func getDateSource() -> CategoriesSummaryDataSource? {
        if dataSource == nil {
            print("DataSource For ChartView is nil")
        }
        return dataSource
    }
    
}

struct ChartCollectionItem: Identifiable, Equatable {
    let id = UUID()
    var elements: [CategoriesSummaryItem] = []
    var interval: DateInterval = DateInterval()
}

struct ActiveChartItems {
    private var items = [ChartCollectionItem(), ChartCollectionItem(), ChartCollectionItem()]
    var first: ChartCollectionItem {
        get { return items[0] }
        set { items[0] = newValue }
    }
    var second: ChartCollectionItem {
        get { return items[1] }
        set { items[1] = newValue }
    }
    var third: ChartCollectionItem {
        get { return items[2] }
        set { items[2] = newValue }
    }
    
    func item(id: UUID) -> ChartCollectionItem? {
        return items.first { $0.id == id }
    }
    
    mutating func appendRight(_ item: ChartCollectionItem) {
        items[0] = items[1]
        items[1] = items[2]
        items[2] = item
    }
    
    mutating func appendLeft(_ item: ChartCollectionItem) {
        items[2] = items[1]
        items[1] = items[0]
        items[0] = item
    }
}

//чтобы кореектно обрабатывать пролистывание до крайних элементов
fileprivate enum EndScrollType {
    case none
    case left
    case right
}
