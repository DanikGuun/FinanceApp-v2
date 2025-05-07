
import UIKit

class CategoriesSummaryViewCellContentView: UIControl, UIContentView {
    
    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private var imageBackground = UIView()
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var percentageLabel = UILabel()
    private var amountLabel = UILabel()
    
    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        imageBackground.backgroundColor = conf.element.color
        imageView.image = conf.element.image
        titleLabel.text = conf.element.title
        amountLabel.text = conf.element.amount.currency()
        percentageLabel.text = conf.percentage.description + "%"
    }
    
    private func setupUI(){
        self.makeCornersAndShadow()
        self.backgroundColor = .systemBackground
        setupImage()
        setupTitleLabel()
        setupPercentageLabel()
        setupAmountLabel()
    }
    
    private func setupAction() {
        self.isUserInteractionEnabled = true
        self.addAction(UIAction(handler: { [weak self] _ in self?.categoryDidTap() }), for: .touchUpInside)
    }
    
    private func categoryDidTap() {
        let conf = getConfiguration()
        conf.categoryDidPressed?(conf.element)
    }
    
    private func setupImage() {
        self.addSubview(imageBackground)
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.top.bottom.equalToSuperview().inset(8)
            maker.width.equalTo(self.imageBackground.snp.height)
        }
        
        imageBackground.backgroundColor = getConfiguration().element.color
        imageBackground.layer.cornerRadius = 8
        
        imageBackground.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.edges.equalTo(self.imageBackground).inset(6)
        }
        
        imageView.tintColor = .systemBackground
        imageView.image = getConfiguration().element.image!.withTintColor(.systemBackground)
    }
    
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.equalTo(self.imageBackground.snp.trailing).offset(10)
            maker.top.centerY.bottom.equalToSuperview()
        }
        titleLabel.snp.contentCompressionResistanceHorizontalPriority = 250
        titleLabel.text = getConfiguration().element.title
        titleLabel.font = UIFont(name: "SF Pro Rounded Regular", size: 18)
    }
    
    private func setupPercentageLabel() {
        addSubview(percentageLabel)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.snp.makeConstraints { maker in
            maker.trailing.centerY.top.bottom.equalToSuperview().inset(12).priority(.required)
        }
        percentageLabel.text = getConfiguration().percentage.description + "%"
        percentageLabel.font = UIFont(name: "SF Pro Rounded Semibold", size: 15)
        percentageLabel.textColor = .tertiaryLabel
    }
    
    private func setupAmountLabel() {
        addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.bottom.centerY.equalToSuperview()
            maker.trailing.equalTo(self.percentageLabel.snp.leading).inset(-12).priority(.high)
            maker.leading.equalTo(self.titleLabel.snp.trailing).priority(.low)
        }
        amountLabel.font = UIFont(name: "SF Pro Rounded Semibold", size: 15)
        amountLabel.textAlignment = .right
        amountLabel.textColor = .secondaryLabel
        amountLabel.snp.contentCompressionResistanceHorizontalPriority = 750
    }
    
    //MARK: - Handlers
    private func getConfiguration() -> CategoriesSummaryViewCellConfiguration {
        if let conf = configuration as? CategoriesSummaryViewCellConfiguration {
            return conf
        }
        return CategoriesSummaryViewCellConfiguration()
    }
}
