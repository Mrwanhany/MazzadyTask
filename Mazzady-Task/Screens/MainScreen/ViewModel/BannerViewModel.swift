//
//  BannerViewModel.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//

import Foundation
import Alamofire


protocol BannerViewModelProtocol {
    func fetchBanners()
}
class BannerViewModel:BannerViewModelProtocol {
    
    var banners: [Banner] = []
    var onBannersFetched: (() -> Void)?  // closure to notify the view controller
    
    func fetchBanners() {
        let url = "https://stagingapi.mazaady.com/api/interview-tasks/advertisements"
        
        AF.request(url, method: .get).responseDecodable(of: BannerResponse.self) { response in
       
            switch response.result {
                
            case .success(let bannerResponse):
                self.banners = bannerResponse.advertisements
            
                self.onBannersFetched?()
            case .failure(let error):
                print("Failed to fetch banners:", error)
            }
        }
    }
}
