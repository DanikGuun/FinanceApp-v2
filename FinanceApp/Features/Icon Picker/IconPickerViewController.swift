
import UIKit
import SnapKit

class IconPickerViewController: UIViewController, Coordinatable, UICollectionViewDelegate {
    var model: IconPickerModel!
    var delegate: ExtendedIconPickerDelegate?
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: IconPickerViewController.makeLayout())
    private var dataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    private var sections: [IconPickerSection] = []
    
    public convenience init(model: IconPickerModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
        
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(IconPickerCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "section")
        setupCollectionViewDataSource()
        updateCollectionViewSnapshot()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].icons[indexPath.item]
        delegate?.extendedIconPicker(didSelectIcon: item.iconId)
        dismiss(animated: true)
    }
    
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<UUID, UUID>(collectionView: collectionView, cellProvider: { [weak self] (collection, indexPath, id) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let item = self?.sections.flatMap({ $0.icons }).first(where: { $0.id == id }) {
                var conf = IconPickerCollectionConfiguration()
                conf.color = item.color
                conf.image = item.image
                cell.contentConfiguration = conf
            }
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collection, kind, indexPath) in
            let view = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "section", for: indexPath) as? IconPickerCollectionHeaderView
            let text = self?.sections[indexPath.section].title
            view?.text = text
            return view
        }
    }
    
    private func updateCollectionViewSnapshot() {
        sections = model.getSections()
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        for section in sections {
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.icons.map { $0.id }, toSection: section.id)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalWidth(1/4))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
        group.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = -10
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
