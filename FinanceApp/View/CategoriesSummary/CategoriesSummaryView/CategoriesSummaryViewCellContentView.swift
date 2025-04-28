
import UIKit

class CategoriesSummaryViewCellContentView: UIView, UIContentView {
    
    var configuration: any UIContentConfiguration
    
    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.makeCornersAndShadow()
        self.backgroundColor = .blue
    }
    
    //MARK: - Handlers
    private func getConfiguration() -> CategoriesSummaryViewCellConfiguration {
        if let conf = configuration as? CategoriesSummaryViewCellConfiguration {
            return conf
        }
        return CategoriesSummaryViewCellConfiguration()
    }
}
