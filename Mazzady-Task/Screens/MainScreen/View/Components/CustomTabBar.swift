//
//  CustomTabBar.swift
//  Mazzady-Task
//
//  Created by Mrwan on 24/04/2025.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeTabBarAppearance()
    }

    private func setupViewControllers() {
        let homeVC = MainView()
        homeVC.view.backgroundColor = Constants.bgColor
        homeVC.tabBarItem = UITabBarItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "home", comment: ""), image: UIImage(named: "home"), tag: 0)

        let searchVC = UIViewController()
        searchVC.view.backgroundColor = .white
        searchVC.tabBarItem = UITabBarItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: ""), image: UIImage(named: "search-normal-bottombar"), tag: 1)

        let storeVC = UIViewController()
        storeVC.view.backgroundColor = .white
        storeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "shop"), tag: 2) // custom icon will be added later

        let cartVC = UIViewController()
        cartVC.view.backgroundColor = .white
        cartVC.tabBarItem = UITabBarItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cart", comment: ""), image: UIImage(named: "bag"), tag: 3)

        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .white
        profileVC.tabBarItem = UITabBarItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "profile", comment: ""), image: UIImage(systemName: "person.fill"), tag: 4)

        viewControllers = [homeVC, searchVC, storeVC, cartVC, profileVC]
    }

    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.bgColor
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBar.tintColor = Constants.mainColor

        tabBar.unselectedItemTintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .lightGray : .systemGray2
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addCustomMiddleButton()
    }

    private func addCustomMiddleButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: tabBar.center.x - 30, y: tabBar.frame.minY , width: 60, height: 60)
        button.backgroundColor = UIColor.dynamicPink()
        button.layer.cornerRadius = 20
        button.setImage(UIImage(named: "shop"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)

        view.addSubview(button)
    }

    @objc private func middleButtonTapped() {
        selectedIndex = 2 // Index of store tab
    }

}
