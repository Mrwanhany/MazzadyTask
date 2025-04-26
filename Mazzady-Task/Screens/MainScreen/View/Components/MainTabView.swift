//
//  TabView.swift
//  Mazzady-Task
//
//  Created by Mrwan on 25/04/2025.
//

import UIKit
import Tabman
import Pageboy

class MainTabView: TabmanViewController {


    private var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Example tab view controllers
        let mainViewVc = MainViewData()
        mainViewVc.view.backgroundColor = Constants.bgColor

        let reviewsVC = UIViewController()
        reviewsVC.view.backgroundColor = Constants.bgColor

        let followersVC = UIViewController()
        followersVC.view.backgroundColor = Constants.bgColor

        viewControllers = [mainViewVc, reviewsVC, followersVC]

        self.dataSource = self

        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.buttons.customize { $0.tintColor = .gray; $0.selectedTintColor = Constants.mainColor }
        bar.indicator.tintColor = Constants.mainColor
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 50.0)

        addBar(bar, dataSource: self, at: .top)
    }
}

extension MainTabView: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let titles = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "products", comment: ""), LocalizationSystem.sharedInstance.localizedStringForKey(key: "reviews", comment: ""), LocalizationSystem.sharedInstance.localizedStringForKey(key: "followers", comment: "")]
        return TMBarItem(title: titles[index])
    }
}

