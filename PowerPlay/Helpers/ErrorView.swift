import UIKit

class ErrorView: UIView {
    
    var onRetry: (() -> Void)?
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(messageLabel)
        addSubview(retryButton)
        
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc private func retryTapped() {
        onRetry?()
    }
}
