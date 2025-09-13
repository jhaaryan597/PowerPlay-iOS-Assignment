import UIKit

class ProductDetailViewController: UIViewController {
    
    private let viewModel: ProductDetailViewModel
    private let imageLoader = ImageLoader()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 1.0)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private let specsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Specifications"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let specsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .orange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(productImageView)
        scrollView.addSubview(mainStackView)
        scrollView.addSubview(ratingView)

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(brandLabel)
        mainStackView.setCustomSpacing(20, after: brandLabel)
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.setCustomSpacing(20, after: priceLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.setCustomSpacing(30, after: descriptionLabel)
        mainStackView.addArrangedSubview(specsTitleLabel)
        mainStackView.setCustomSpacing(16, after: specsTitleLabel)
        mainStackView.addArrangedSubview(specsStackView)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(ratingCountLabel)
        ratingView.addSubview(ratingStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            productImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            mainStackView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 24),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
            
            ratingView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 16),
            ratingView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: -16),
            
            ratingStackView.topAnchor.constraint(equalTo: ratingView.topAnchor, constant: 8),
            ratingStackView.bottomAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: -8),
            ratingStackView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 12),
            ratingStackView.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -12),
        ])
    }
    
    private func configure() {
        let product = viewModel.product
        
        titleLabel.text = product.title
        brandLabel.text = product.brand
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.description
        
        imageLoader.loadImage(from: product.image) { [weak self] image in
            self?.productImageView.image = image ?? UIImage(named: "buds")
        }
        
        for (key, value) in product.specs {
            let specLabel = UILabel()
            specLabel.font = .systemFont(ofSize: 16)
            specLabel.text = "\(key.capitalized): \(value.description)"
            specsStackView.addArrangedSubview(specLabel)
        }
        
        ratingLabel.text = "\(product.rating.rate)"
        ratingCountLabel.text = "(\(product.rating.count) ratings)"
    }
}
