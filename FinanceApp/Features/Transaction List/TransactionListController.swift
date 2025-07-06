
import UIKit

public final class TransactionListController: UIViewController, Coordinatable, UICollectionViewDelegate {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    var model: TransactionListModel!
    
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
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
            let title = "Title \(Int.random(in: 0...10000000))"
            let color = [UIColor.red, .systemCyan, .systemMint, .systemGreen, .systemBlue, .systemRed].randomElement()!
            let conff = UIImage.SymbolConfiguration(paletteColors: [.systemBackground])
            let image = UIImage(systemName: ["trash", "ellipsis", "plus", "bus"].randomElement()!, withConfiguration: conff)
            let subtitle = Int.random(in: 0...10000).currency()
            let conf = TransactionListConfiguration(title: title, subtitle: subtitle, image: image, color: color)
            cell.contentConfiguration = conf
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems((0...10).map { _ in UUID() })
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
