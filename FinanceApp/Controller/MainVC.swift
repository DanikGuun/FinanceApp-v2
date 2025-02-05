
import UIKit
import ChartKit

class MainVC: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var conf = CategoriesSummaryChartConfiguration(elements: [
            CategoriesSummaryItem(amount: 2, color: .systemMint),
            CategoriesSummaryItem(amount: 2, color: .systemRed),
            CategoriesSummaryItem(amount: 2, color: .systemCyan)
        ], interval: DateInterval())
        conf.chartDidPressed = { print("Chart Press") }
        conf.intervalButtonDidPressed = { print("Interval Press") }
        cell.contentConfiguration = conf
        
        return cell
    }
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.dataSource = self
        collection.collectionViewLayout = getLayout()
        
        let but = UIButton(frame: CGRect(x: 0, y: 500, width: 150, height: 50))
        but.configuration = UIButton.Configuration.filled()
        but.addAction(UIAction(handler: {[self] _ in
            let cell = self.collection.cellForItem(at: IndexPath(row: 0, section: 0))
            var conf = cell?.contentConfiguration as! CategoriesSummaryChartConfiguration
            conf.elements[0].amount = 5235
            cell?.contentConfiguration = conf
        }), for: .touchUpInside)
        view.addSubview(but)
    }

    private func getLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let conf = layout.configuration
        conf.scrollDirection = .horizontal
        layout.configuration = conf
        return layout
    }
    
}
