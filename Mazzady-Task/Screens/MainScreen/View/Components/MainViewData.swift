//
//  ProductsView.swift
//  Mazzady-Task
//
//  Created by Mrwan on 25/04/2025.
//

import UIKit
import Network

class MainViewData: UIViewController {
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private var collectionView: UICollectionView!
    private var tableView: UITableView!
    private let productViewModel = ProductViewModel()
    private let bannerViewModel = BannerViewModel()
    private let tagsViewModel = TagsViewModel()
    private let searchTextField = UITextField()
    let searchButton = UIButton(type: .system)
    var cachedProducts: [ProductResponse] = []
    var searchText: String = "" {
        didSet {
            searchButton.isEnabled = !searchText.isEmpty
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        fetchData()
        setupBindings()
        setupCollectionView()
        setUpTableView()
       
    }
    
    private func fetchData(){
        productViewModel.fetchProducts(name: self.searchText)
        bannerViewModel.fetchBanners()
        tagsViewModel.fetchTags{
            let topTagsSection = self.makeTopTagsSection()
            self.contentStack.addArrangedSubview(topTagsSection)
            
        }
    }
    
    private func setupScrollView() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // important!
        ])
        
      
    }
    
    private func setupCollectionView() {
        let searchSection = makeSearchSection()
        searchSection.translatesAutoresizingMaskIntoConstraints = false
        searchSection.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }

        let spacing: CGFloat = 8
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)

        collectionView.backgroundColor = Constants.bgColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)

        contentStack.addArrangedSubview(searchSection)
        contentStack.addArrangedSubview(collectionView)

        collectionView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
    }

    private func setUpTableView() {
        tableView = UITableView(frame: .zero)
        guard let tableView = tableView else { return }
        tableView.backgroundColor = Constants.bgColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.register(BannerCell.self, forCellReuseIdentifier: BannerCell.identifier)

        contentStack.addArrangedSubview(tableView)
        
        tableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        contentStack.heightAnchor.constraint(equalToConstant: 1950).isActive = true
    }
    
    private func setupBindings() {
        productViewModel.didUpdate = { [weak self] in
            DispatchQueue.main.async {
                if NetworkMonitor.shared.isConnected {
                    self?.collectionView.reloadData()
                } else {
                    if let cachedProducts: [ProductResponse] = CacheManager.shared.load([ProductResponse].self, from: "products.json") {
                        self?.cachedProducts = cachedProducts
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
        bannerViewModel.onBannersFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func makeSearchSection() -> UIView {
        let container = UIView()
        container.backgroundColor = Constants.bgColor

        // Search Field
       
        searchTextField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: "")
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 20
        searchTextField.layer.masksToBounds = true
        searchTextField.leftViewMode = .always

        let searchIcon = UIImageView(image: UIImage(named: "search-normal"))
        searchIcon.tintColor = .systemPink
        searchIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        searchTextField.leftView = searchIcon
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)


        searchButton.setImage(UIImage(named: "send" ), for: .normal)
        searchButton.tintColor = .white
        searchButton.backgroundColor = Constants.mainColor
        searchButton.layer.cornerRadius = 20
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
      

        // Stack
        let hStack = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),

            searchTextField.heightAnchor.constraint(equalToConstant: 40),
        ])

        return container
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        searchButton.isEnabled = !text.isEmpty
        self.productViewModel.fetchProducts(name: text)
    }

    @objc private func searchButtonTapped() {
       
        self.searchText = searchTextField.text!
        self.productViewModel.fetchProducts(name: self.searchText)
    }
    
    private func makeTopTagsSection() -> UIView {
        let container = UIView()

        // Title
        let titleLabel = UILabel()
        titleLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "topTags", comment: "")
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        titleLabel.font = UIFont(name: Fonts().nunito, size: 20.0)
        titleLabel.textColor = .black

        let tags = self.tagsViewModel.tags

        let tagsStack = createTagsStack(tags: tags)

        // Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        container.addSubview(tagsStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            tagsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tagsStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            tagsStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            tagsStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    private func createTagsStack(tags: [Tag]) -> UIView {
        let wrapStack = WrapStackView(spacing: 8)
        tags.forEach { tag in
            let button = UIButton(type: .system)
            button.setTitle(tag.name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.backgroundColor = .white
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray5.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            wrapStack.addArrangedSubview(button)
        }
        return wrapStack
    }
  
}



extension MainViewData : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if NetworkMonitor.shared.isConnected {
              return productViewModel.products.count
          } else {
              return cachedProducts.count
          }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
            let product: ProductResponse
          if NetworkMonitor.shared.isConnected {
              product = productViewModel.products[indexPath.item]
          } else {
              product = cachedProducts[indexPath.item]
          }
          
          cell.configure(with: product)
          return cell
    }

}

extension MainViewData: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 8
        let columns: CGFloat = 3
        let totalSpacing = (columns - 1) * spacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let width = floor(availableWidth / columns)
        

        
        let product: ProductResponse
          if NetworkMonitor.shared.isConnected {
              product = productViewModel.products[indexPath.item]
          } else {
              product = cachedProducts[indexPath.item]
          }
          

        var height: CGFloat = 200 // base height


        if product.offer != nil {
            height += 25 // offer label
            height += 20 // old price label
        } else {
            height = 200
        }

        if product.end_date != nil {
            height += 80 // countdown
        } else {
            height = 200
        }
        
      
        return CGSize(width: width, height: height)
    }

   
}

extension MainViewData : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bannerViewModel.banners.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else {
             return UITableViewCell()
         }
         cell.backgroundColor = Constants.bgColor
         let banner = bannerViewModel.banners[indexPath.row]
         cell.configure(with: banner.image)

         return cell
     }
     
     // MARK: - TableView Delegate
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 200
     }
}
