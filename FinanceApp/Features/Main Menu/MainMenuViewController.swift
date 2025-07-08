
import UIKit

class MainMenuViewController: UIViewController, Coordinatable, UICollectionViewDelegate {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    var model: MainMenuModel!
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: MainMenuViewController.makeLayout())
    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    
    var items: [MenuItem] = []
    
    public convenience init(model: MainMenuModel) {
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
        title = "Меню"
        
        setupMenuCollectionView()
    }
    
    private func setupMenuCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "cell")
        setupCollectionDataSource()
        updateSnapshot()
    }
    
    private func setupCollectionDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] (collection, indexPath, id) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let item = self?.items.first(where: { $0.id == id }) {
                let conf = MenuCellConfiguration(title: item.title, image: item.image)
                cell.contentConfiguration = conf
            }
            return cell
        })
    }
    
    private func updateSnapshot() {
        items = model.menuItems()
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(items.map { $0.id })
        dataSource.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = dataSource.itemIdentifier(for: indexPath), let item = items.first(where: { $0.id == id }) {
            item.action?(item)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private static func makeLayout() -> UICollectionViewLayout {
        let conf = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: conf)
        return layout
    }
}
