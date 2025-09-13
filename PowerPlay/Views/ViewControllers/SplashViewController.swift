import UIKit

class SplashViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "p-logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 23/255, green: 37/255, blue: 84/255, alpha: 1.0)
        view.addSubview(logoImageView)
        
        setupConstraints()
        
        // Set initial state for the animation
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateSplashScreen()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func animateSplashScreen() {
        // Animate the logo to scale up and fade in
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.logoImageView.transform = .identity
            self.logoImageView.alpha = 1
        }) { _ in
            // On completion, start a subtle pulse animation
            UIView.animate(withDuration: 0.7, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
                self.logoImageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion: nil)
        }
    }
}
