
import UIKit
import SnapKit

class IconPickerCollectionContentView: UIView, UIContentView {
    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private var backgroundView = UIView()
    
    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        backgroundView.backgroundColor = conf.color
    }
    
    private func setupUI() {
        setupBackgroundView()
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(8)
        }
    }
    
    
    private func getConfiguration() -> IconPickerCollectionConfiguration {
        if let conf = configuration as? IconPickerCollectionConfiguration {
            return conf
        }
        return IconPickerCollectionConfiguration()
    }
    
}
