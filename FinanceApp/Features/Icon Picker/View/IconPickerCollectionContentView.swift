
import UIKit
import SnapKit

class IconPickerCollectionContentView: UIView, UIContentView {
    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private var backgroundView = UIView()
    private var imageView = UIImageView()
    
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
        imageView.image = conf.image
        alpha = conf.isHighlited ? 0.7 : 1
    }
    
    private func setupUI() {
        setupBackgroundView()
        setupImageView()
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(8)
        }
        
        backgroundView.makeCornersAndShadow()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(15)
        }
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func getConfiguration() -> IconPickerCollectionConfiguration {
        if let conf = configuration as? IconPickerCollectionConfiguration {
            return conf
        }
        return IconPickerCollectionConfiguration()
    }
    
}
