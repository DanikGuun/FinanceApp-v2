
import UIKit

class CategorySummaryView: UIView, CategoriesSummaryPresenter {
    
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
        self.makeCornersAndShadow()
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
        categoriesCollection.backgroundColor = .clear
        setupCollectionDataSource()
        reloadSnapshot()
    }
    
    private func setupCollectionDataSource() {
        self.categoriesCollectionDataSource = UICollectionViewDiffableDataSource(collectionView: categoriesCollection, cellProvider: { (collectionView, indexPath, id) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let item = self.items.first(where: { $0.id == id }) {
                var conf = CategoriesSummaryViewCellConfiguration()
                conf.element = item
                conf.categoryDidPressed = { _ in
                    print("category pressed")
                }
                cell.contentConfiguration = conf
            }
            return cell
        })
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
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
