//
//  TagsViewModel.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//
import UIKit
import Alamofire

protocol TagsViewModelProtocol {
    func fetchTags(completion: @escaping () -> Void)
}

class TagsViewModel :TagsViewModelProtocol{
   
    
    var tags: [Tag] = []
    var onTagFetched: (() -> Void)?  // closure to notify the view controller
    
    func fetchTags(completion: @escaping () -> Void) {
        let url = "https://stagingapi.mazaady.com/api/interview-tasks/tags"
        
        AF.request(url, method: .get).responseDecodable(of: TagsResponse.self) { response in
       
            switch response.result {
            case .success(let tagsResponse):
                self.tags = tagsResponse.tags ?? self.tags
                self.tags.insert(Tag(id: 0, name: LocalizationSystem.sharedInstance.localizedStringForKey(key: "all", comment: "")), at: 0)
                completion()
            case .failure(let error):
                print("Failed to fetch tags:", error)
            }
        }
    }
    
}

