import Foundation

class ProductListViewModel {
    
    enum State {
        case loading
        case loaded([Product])
        case error(Error)
        case noData
        case noSearchResults
    }
    
    private(set) var state: State = .loading {
        didSet {
            onStateChange?()
        }
    }
    
    var onStateChange: (() -> Void)?
    
    private var allProducts: [Product] = []
    private var displayedProducts: [Product] = []
    private var nextPage: Int? = 0
    private var isLoading = false
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = APIService()) {
        self.networkService = networkService
    }
    
    func fetchProducts() {
        guard !isLoading, let page = nextPage else { return }
        
        isLoading = true
        if allProducts.isEmpty {
            state = .loading
        }
        
        networkService.fetchProducts(page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let response):
                self.allProducts.append(contentsOf: response.data)
                self.displayedProducts = self.allProducts
                let pagination = response.pagination
                if (pagination.page * pagination.limit) < pagination.total {
                    self.nextPage = pagination.page + 1
                } else {
                    self.nextPage = nil
                }
                
                if self.displayedProducts.isEmpty {
                    self.state = .noData
                } else {
                    self.state = .loaded(self.displayedProducts)
                }
                
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    func search(query: String) {
        if query.isEmpty {
            displayedProducts = allProducts
        } else {
            displayedProducts = allProducts.filter {
                $0.title.localizedCaseInsensitiveContains(query) ||
                $0.description.localizedCaseInsensitiveContains(query) ||
                $0.category.localizedCaseInsensitiveContains(query)
            }
        }
        
        if displayedProducts.isEmpty {
            state = .noSearchResults
        } else {
            state = .loaded(displayedProducts)
        }
    }
}
