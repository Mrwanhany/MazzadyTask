//
//  ProfileView.swift
//  Mazzady-Task
//
//  Created by Mrwan on 24/04/2025.
//

import UIKit
import SDWebImage

class MainView: UIViewController {
    
    private let profileViewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        self.profileViewModel.fetchUserInfo {
            self.setUpView()
        }
    }
    
    private func setUpView(){
        view.backgroundColor = Constants.bgColor
      
        // Language + Settings Icon
        let languageButton = UIButton(type: .system)
        languageButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "english", comment: ""), for: .normal)
        languageButton.setTitleColor(.black, for: .normal)
        languageButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        languageButton.tintColor = .systemPink
        languageButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        languageButton.semanticContentAttribute = .forceRightToLeft
        languageButton.contentHorizontalAlignment = .right
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        languageButton.addTarget(self, action: #selector(languageButtonTapped), for: .touchUpInside)


        view.addSubview(languageButton)

        NSLayoutConstraint.activate([
            languageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            languageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            languageButton.widthAnchor.constraint(equalToConstant: 400), // <<< add width constraint
            languageButton.heightAnchor.constraint(equalToConstant: 40) // <<< optional height constraint
        ])

     


        // Profile Image
        let profileImage = UIImageView()
        profileImage.sd_setImage(with: URL(string: profileViewModel.user.image ?? ""))
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true

        // Name + Username + Location
        let nameLabel = makeLabel(text: profileViewModel.user.name ?? "", fontSize: 18, weight: .bold)
        let usernameLabel = makeLabel(text: "@" + (profileViewModel.user.user_name ?? ""), fontSize: 14, color: .darkGray)
        let locationLabel = makeLabel(text: (profileViewModel.user.country_name ?? "") + ", " + (profileViewModel.user.city_name ?? ""), fontSize: 13, color: .lightGray)

        let infoStack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel, locationLabel])
        infoStack.axis = .vertical
        infoStack.alignment = .center
        infoStack.spacing = 4

        // Stats
        let followingView = makeIconLabel(icon: "following", count: "\(profileViewModel.user.following_count ?? 0)", title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "following", comment: ""))
        let followersView = makeIconLabel(icon: "followers", count:  "\(profileViewModel.user.followers_count ?? 0)", title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "followers", comment: ""))

        let statsStack = UIStackView(arrangedSubviews: [followingView, followersView])
        statsStack.axis = .horizontal
        statsStack.spacing = 40
        statsStack.alignment = .center

    
        let productsButton = makeTabButton(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "products", comment: ""), isSelected: true)
        let reviewsButton = makeTabButton(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "reviews", comment: ""))
        let followersButton = makeTabButton(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "followers", comment: ""))

        let tabStack = UIStackView(arrangedSubviews: [productsButton, reviewsButton, followersButton])
        tabStack.axis = .horizontal
        tabStack.distribution = .fillEqually
        tabStack.spacing = 10
        tabStack.translatesAutoresizingMaskIntoConstraints = false


        // Search Bar
        let searchBar = UISearchBar()
        searchBar.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: "")
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .systemPink
     
        let tabContentVC = MainTabView()
        addChild(tabContentVC)
        tabContentVC.didMove(toParent: self)
        tabContentVC.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
      
        // Layout
        let mainStack = UIStackView(arrangedSubviews: [
            languageButton,
            profileImage,
            infoStack,
            statsStack,
            tabContentVC.view,
       
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        

        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    

    private func makeLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight = .regular, color: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.textColor = color
        label.textAlignment = .center
        return label
    }

    private func makeIconLabel(icon: String, count: String, title: String) -> UIStackView {
        let imageView = UIImageView(image: UIImage(named: icon))
        imageView.tintColor = UIColor.systemPink
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let countLabel = makeLabel(text: count, fontSize: 16, weight: .bold, color: UIColor.black)
        let titleLabel = makeLabel(text: title, fontSize: 12, color: UIColor.systemPink)

        let textStack = UIStackView(arrangedSubviews: [countLabel, titleLabel])
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 2

        let containerStack = UIStackView(arrangedSubviews: [imageView, textStack])
        containerStack.axis = .horizontal
        containerStack.spacing = 8
        containerStack.alignment = .center

        return containerStack
    }
    
    private func makeTabButton(title: String, isSelected: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: isSelected ? .bold : .regular)
        button.setTitleColor(isSelected ? UIColor.systemPink : UIColor.gray, for: .normal)
        button.backgroundColor = .clear
        return button
    }
    
    @objc func languageButtonTapped() {
        let languageVC = LanguageViewController()
        languageVC.modalPresentationStyle = .overFullScreen
        present(languageVC, animated: true)
    }

}
