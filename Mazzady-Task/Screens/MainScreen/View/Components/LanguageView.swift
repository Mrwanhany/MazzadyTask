//
//  LanguageView.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//

import UIKit

class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let languages = ["English", "العربية"]
    var filteredLanguages: [String] = []
    
    private let containerView = UIView()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlur()
        setupContainer()
        setupHeader()
        setupSearchBar()
        setupTableView()
    }
    
    private func setupBlur() {
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        blurEffectView.addGestureRecognizer(tap)
    }
    
    private func setupContainer() {
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupHeader() {
        let titleLabel = UILabel()
        titleLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "lang", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "search", comment: "")
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        
        containerView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        filteredLanguages = languages
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    private func changeLanguage(to language: String) {
        var localeIdentifier = "en"

        if language == "العربية" {
            localeIdentifier = "ar"
        }

        UserDefaults.standard.set([localeIdentifier], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        scheduleReopenNotification()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               exit(0)
           }
    }

    private func scheduleReopenNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Language Updated!"
        content.body = "Tap to reopen the app with the new language."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false) // ⬅️ 2 seconds

        let request = UNNotificationRequest(identifier: "reopenAppNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }


    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.text = filteredLanguages[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = filteredLanguages[indexPath.row]
        if selectedLanguage == "English" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")

        } else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")

        }
        exit(0)
    
            
    }
    
    // MARK: - SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredLanguages = languages
        } else {
            filteredLanguages = languages.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
extension SceneDelegate {
    func reloadApp() {
        guard let window = self.window else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
        window.makeKeyAndVisible()
    }
}
