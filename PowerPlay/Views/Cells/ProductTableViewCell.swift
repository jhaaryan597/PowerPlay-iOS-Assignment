import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let identifier = "ProductTableViewCell"
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .orange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let titleRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        return stackView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .darkGray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(textStackView)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        
        titleRowStackView.addArrangedSubview(titleLabel)
        titleRowStackView.addArrangedSubview(ratingStackView)
        
        textStackView.addArrangedSubview(titleRowStackView)
        textStackView.addArrangedSubview(categoryLabel)
        textStackView.setCustomSpacing(8, after: categoryLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.setCustomSpacing(8, after: descriptionLabel)
        textStackView.addArrangedSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 100),
            productImageView.heightAnchor.constraint(equalToConstant: 100),
            
            textStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with product: Product, imageLoader: ImageLoader) {
        titleLabel.text = product.title
        categoryLabel.text = product.category
        descriptionLabel.text = product.description
        priceLabel.text = "$\(product.price)"
        ratingLabel.text = "\(product.rating.rate)"
        
        productImageView.image = nil
        imageLoader.loadImage(from: product.image) { [weak self] image in
            self?.productImageView.image = image ?? UIImage(named: "buds")
        }
    }
}
