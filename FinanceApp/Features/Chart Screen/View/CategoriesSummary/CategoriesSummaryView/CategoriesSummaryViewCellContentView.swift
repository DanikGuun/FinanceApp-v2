
import UIKit

class CategoriesSummaryViewCellContentView: UIView, UIContentView {
    
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
        alpha = conf.isSelected ? 0.6 : 1
    }
    
    private func setupUI(){
        self.makeCornersAndShadow()
        self.backgroundColor = .systemBackground
        setupImage()
        setupTitleLabel()
        setupPercentageLabel()
        setupAmountLabel()
    }
    
    private func setupImage() {
        self.addSubview(imageBackground)
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.top.bottom.equalToSuperview().inset(8).priority(750)
            maker.width.equalTo(self.imageBackground.snp.height).priority(750)
        }
        
        imageBackground.backgroundColor = getConfiguration().element.color
        imageBackground.layer.cornerRadius = 8
        
        imageBackground.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.edges.equalTo(self.imageBackground).inset(6).priority(750)
        }
        
        imageView.tintColor = .systemBackground
        imageView.image = getConfiguration().element.image?.withTintColor(.systemBackground)
    }
    
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.equalTo(self.imageBackground.snp.trailing).offset(10)
            maker.top.bottom.equalToSuperview()
        }
        titleLabel.snp.contentCompressionResistanceHorizontalPriority = 250
        titleLabel.snp.contentHuggingHorizontalPriority = 750
        titleLabel.text = getConfiguration().element.title
        titleLabel.font = DC.Font.regular(size: 18)
    }
    
    private func setupPercentageLabel() {
        addSubview(percentageLabel)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.snp.makeConstraints { maker in
            maker.trailing.top.bottom.equalToSuperview().inset(12).priority(.high)
        }
        percentageLabel.snp.contentHuggingHorizontalPriority = 1000
        percentageLabel.text = getConfiguration().percentage.description + "%"
        percentageLabel.font =  DC.Font.semibold(size: 15)
        percentageLabel.textColor = .tertiaryLabel
    }
    
    private func setupAmountLabel() {
        addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.bottom.equalToSuperview().priority(.medium)
            maker.trailing.equalTo(self.percentageLabel.snp.leading).inset(-12).priority(.high)
            maker.leading.equalTo(self.titleLabel.snp.trailing).priority(.medium)
        }
        amountLabel.font =  DC.Font.semibold(size: 15)
        amountLabel.textAlignment = .right
        amountLabel.textColor = .secondaryLabel
        amountLabel.snp.contentCompressionResistanceHorizontalPriority = 800
    }
    
    //MARK: - Handlers
    private func getConfiguration() -> CategoriesSummaryViewCellConfiguration {
        if let conf = configuration as? CategoriesSummaryViewCellConfiguration {
            return conf
        }
        return CategoriesSummaryViewCellConfiguration()
    }
}
