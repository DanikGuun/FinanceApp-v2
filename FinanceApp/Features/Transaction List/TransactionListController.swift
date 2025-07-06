
import UIKit

public final class TransactionListController: UIViewController, Coordinatable, UICollectionViewDelegate {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    var model: TransactionListModel!
    
    private var items: [TransactionListItem] = []
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: TransactionListController.makeLayout())
    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    
    //MARK: - Lifecycle
    convenience init(model: TransactionListModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        title = "Операции"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        relaodData()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TransactionListCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        setupCollectionViewDataSource()
        updateSnapshot()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<UUID, UUID>(collectionView: collectionView, cellProvider: { [weak self] (collection, indexPath, id) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let items = self?.items.flatMap { $0.items }
            if let item = items?.first(where: { $0.id == id }), let category = self?.model.getCategory(id: item.categoryID) {
                let title = category.name
                let color = category.color
                let image = self?.model.getIcon(iconId: category.iconId)
                let subtitle = item.amount.currency()
                let conf = TransactionListConfiguration(title: title, subtitle: subtitle, image: image, color: color)
                cell.contentConfiguration = conf
            }
            return cell
        })
        dataSource.supplementaryViewProvider = { [weak self] (collection, kind, indexPath) in
            let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TransactionListCollectionHeaderView
            if var item = self?.items[indexPath.section] {
                item.interval.end = item.interval.end.addingTimeInterval(-1)
                let formatter = DateIntervalFormatter()
                formatter.locale = Locale.actual
                formatter.dateTemplate = "d MMMM yyyy"
                header.text = formatter.string(from: item.interval)
            }
            return header
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        for item in items {
            snapshot.appendSections([item.id])
            snapshot.appendItems(item.items.map { $0.id })
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: DC.standartInset, bottom: 0, trailing: DC.standartInset/2)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.1), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func relaodData() {
        items = model.getTransactionWithLastConfiguration()
        updateSnapshot()
    }
    
}
