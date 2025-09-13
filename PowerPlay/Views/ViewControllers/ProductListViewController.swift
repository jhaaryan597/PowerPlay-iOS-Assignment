import UIKit

class ProductListViewController: UIViewController {
    
    private let viewModel = ProductListViewModel()
    private let imageLoader = ImageLoader()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onRetry = { [weak self] in
            self?.viewModel.fetchProducts()
        }
        return view
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty-state") // Assuming you add an image named "empty-state" to your assets
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Simplification of your construction journey begins here"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        return view
    }()
    
    private let noSearchResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Not Available"
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupBindings()
        setupKeyboardDismissal()
        viewModel.fetchProducts()
    }
    
    private func setupNavigationBar() {
        // 1. Correct Navigation Bar Color
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 23/255, green: 37/255, blue: 84/255, alpha: 1.0)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white

        // 2. Rebuild Left Bar Button Item
        let logoImageView = UIImageView(image: UIImage(named: "p-logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
        // 3. Rebuild Right Bar Button Items
        let profileButton = UIBarButtonItem(customView: createProfileButton())
        
        navigationItem.rightBarButtonItems = [profileButton]
    }

    // Helper function for the "AJ" profile button
    private func createProfileButton() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200/255, green: 191/255, blue: 231/255, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "AJ"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 30),
            view.heightAnchor.constraint(equalToConstant: 30),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 23/255, green: 37/255, blue: 84/255, alpha: 1.0)
        
        let headerView = createHeaderView()
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorView)
        view.addSubview(emptyStateView)
        view.addSubview(noSearchResultsLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noSearchResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSearchResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.cornerRadius = 20
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let productsLabel = UILabel()
        productsLabel.text = "Products"
        productsLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        productsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = .white
            searchTextField.layer.cornerRadius = 10
            searchTextField.clipsToBounds = true
            searchTextField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            searchTextField.layer.borderWidth = 1
        }
        
        headerView.addSubview(productsLabel)
        headerView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            productsLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            productsLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            productsLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: productsLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12)
        ])
        
        return headerView
    }
    
    private func setupBindings() {
        viewModel.onStateChange = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        switch viewModel.state {
        case .loading:
            activityIndicator.startAnimating()
            tableView.isHidden = true
            errorView.isHidden = true
            emptyStateView.isHidden = true
            noSearchResultsLabel.isHidden = true
        case .loaded:
            activityIndicator.stopAnimating()
            tableView.isHidden = false
            errorView.isHidden = true
            emptyStateView.isHidden = true
            noSearchResultsLabel.isHidden = true
            tableView.reloadData()
        case .error:
            activityIndicator.stopAnimating()
            tableView.isHidden = true
            errorView.isHidden = false
            emptyStateView.isHidden = true
            noSearchResultsLabel.isHidden = true
        case .noData:
            activityIndicator.stopAnimating()
            tableView.isHidden = true
            errorView.isHidden = true
            emptyStateView.isHidden = false
            noSearchResultsLabel.isHidden = true
        case .noSearchResults:
            activityIndicator.stopAnimating()
            tableView.isHidden = false // Keep table view visible to show the white background
            tableView.reloadData() // Clear the table
            errorView.isHidden = true
            emptyStateView.isHidden = true
            noSearchResultsLabel.isHidden = false
        }
    }
    
    @objc private func chatTapped() {}
    @objc private func profileTapped() {}
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .loaded(let products) = viewModel.state {
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell,
              case .loaded(let products) = viewModel.state else {
            return UITableViewCell()
        }
        
        let product = products[indexPath.row]
        cell.configure(with: product, imageLoader: imageLoader)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if case .loaded(let products) = viewModel.state {
            let product = products[indexPath.row]
            let detailViewModel = ProductDetailViewModel(product: product)
            let detailViewController = ProductDetailViewController(viewModel: detailViewModel)
            
            // Set the back button title for the next screen
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            viewModel.fetchProducts()
        }
    }
}
