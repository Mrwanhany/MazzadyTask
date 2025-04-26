//
//  AdvertisementsCell.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//

import UIKit
import SDWebImage

class BannerCell: UITableViewCell {
    
    static let identifier = "BannerCell"
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bannerImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bannerImageView.frame = contentView.bounds.insetBy(dx: 16, dy: 8) // padding inside the cell
    }
    
    func configure(with imageUrl: String) {
        if let url = URL(string: imageUrl) {
            DispatchQueue.main.async {
                self.bannerImageView.sd_setImage(with: url)
            }
        }
    }
}
