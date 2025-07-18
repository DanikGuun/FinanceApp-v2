
import UIKit

class CategorySummaryView: UIView, CategoriesSummaryPresenter, UICollectionViewDelegate {
    
    var delegate: (any CategoriesSummaryDelegate)?
    var dataSource: (any CategoriesSummaryDataSource)? { didSet { reloadData() } }
    
    var interval: DateInterval = DateInterval()
    var intervalType: IntervalType
    
    private var categoriesCollectionDataSource: UICollectionViewDiffableDataSource<UUID, UUID>! { didSet { reloadData() } }
    private var items: [CategoriesSummaryItem] = []
    
    private var categoriesCollection: UICollectionView!
    
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        self.interval = DateInterval()
        self.intervalType = .day
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.interval = DateInterval()
        self.intervalType = .day
        super.init(coder: coder)
    }
    
    //MARK: - UI
    private func setupUI(){
        self.backgroundColor = .clear
        setupCollectionView()
    }
    
    //MARK: - CollectionView
    private func setupCollectionView() {
        self.categoriesCollection = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        self.addSubview(categoriesCollection)
        categoriesCollection.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollection.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        categoriesCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        categoriesCollection.showsVerticalScrollIndicator = false
        categoriesCollection.allowsSelection = true
        categoriesCollection.backgroundColor = .clear
        categoriesCollection.delegate = self
        setupCollectionDataSource()
        reloadSnapshot()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let id = categoriesCollectionDataSource.itemIdentifier(for: indexPath), let item = items.first(where: { $0.id == id }) else { return }
        requestToOpenIntervalSummary(for: item)
    }
    
    private func setupCollectionDataSource() {
        self.categoriesCollectionDataSource = UICollectionViewDiffableDataSource(collectionView: categoriesCollection, cellProvider: { [weak self] (collectionView, indexPath, id) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            guard let self = self else { return cell }
            if let item = self.items.first(where: { $0.id == id }) {
                var conf = CategoriesSummaryViewCellConfiguration()
                conf.element = item
                conf.percentage = Int((item.amount / max(self.getTotalAmount(), 1) * 100).rounded())
                cell.contentConfiguration = conf
            }
            return cell
        })
    }
    
    private func getTotalAmount() -> CGFloat {
        return items.reduce(0, { $0 + $1.amount })
    }
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(items.map { $0.id })
        categoriesCollectionDataSource.apply(snapshot)
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: - Handlers
    func reloadData() {
        self.items = dataSource?.categoriesSummary(self, getSummaryItemsFor: self.interval) ?? []
        reloadSnapshot()
    }
    
    func requestToOpenIntervalSummary(for category: CategoriesSummaryItem) {
        delegate?.categoriesSummary(self, openSummaryControllerFor: interval, category: category)
    }
    
}
