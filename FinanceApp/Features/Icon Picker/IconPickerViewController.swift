
import UIKit
import SnapKit

class IconPickerViewController: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    var delegate: IconPickerDelegate?
    var coordinator: (any Coordinator)?
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: IconPickerViewController.makeLayout())
    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Иконка"
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
        setupCollectionViewDataSource()
        setupCollectionViewSnapshot()
    }
    
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<UUID, UUID>(collectionView: collectionView, cellProvider: { (collection, indexPath, id) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.contentConfiguration = IconPickerCollectionConfiguration()
            return cell
        })
        dataSource.supplementaryViewProvider
    }
    
    private func setupCollectionViewSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems([UUID(), UUID(), UUID(), UUID(), UUID(), UUID(), UUID(), UUID(), UUID()])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalWidth(1/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
