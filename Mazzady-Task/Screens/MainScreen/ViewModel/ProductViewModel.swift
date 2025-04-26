//
//  ProductViewModel.swift
//  Mazzady-Task
//
//  Created by Mrwan on 24/04/2025.
//

import Foundation
import Alamofire

protocol ProductViewModelProtocol {
    func fetchProducts(name:String)
}

class ProductViewModel : ProductViewModelProtocol{
    var products: [ProductResponse] = []
        var didUpdate: (() -> Void)?



    func fetchProducts(name : String) {
            let url = "https://stagingapi.mazaady.com/api/interview-tasks/products?name=\(name)" // replace with actual URL

            AF.request(url).validate().responseDecodable(of: [ProductResponse].self) { response in
                switch response.result {
                case .success(let items):
                    self.products.removeAll()
                    self.products.append(contentsOf: items)
                    CacheManager.shared.save(items, to: "products.json")
                    self.didUpdate?()

                case .failure(let error):
                    print("Error fetching products: \(error)")
                }
            }
        }

}

