//
//  ProfileViewModel.swift
//  Mazzady-Task
//
//  Created by Mrwan on 24/04/2025.
//

import Foundation
import Alamofire

protocol ProfileViewModelProtocol {
    func fetchUserInfo(completion: @escaping () -> Void)
}

class ProfileViewModel : ProfileViewModelProtocol{
    var user: User = User()
     
        func fetchUserInfo(completion: @escaping () -> Void) {
            let url = "https://stagingapi.mazaady.com/api/interview-tasks/user"

            AF.request(url).validate().responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self.user = item
                        completion()
                        
                    }
                case .failure(let error):
                    print("Error fetching products: \(error.localizedDescription)")
                }
            }
        }

}
