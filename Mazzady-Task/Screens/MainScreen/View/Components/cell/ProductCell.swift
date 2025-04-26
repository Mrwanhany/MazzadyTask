//
//  ProductCell.swift
//  Mazzady-Task
//
//  Created by Mrwan on 24/04/2025.
//

import UIKit
import SDWebImage




import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    static let identifier = "ProductCollectionViewCell"

    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12 // or match the contentView corner radius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.numberOfLines = 2
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let offerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .red
        label.numberOfLines = 3
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.attributedText = NSAttributedString(string: "", attributes: [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
  
    let lotStartInLbl: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.numberOfLines = 2
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let countdownStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(offerLabel)
        contentView.addSubview(oldPriceLabel)
        contentView.addSubview(lotStartInLbl)
        
        setupCountdownStack()

        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
             productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             productImageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.heightAnchor.constraint(equalToConstant: 14),
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 6),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
         
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            offerLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            offerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            oldPriceLabel.centerYAnchor.constraint(equalTo: offerLabel.centerYAnchor),
            oldPriceLabel.leadingAnchor.constraint(equalTo: offerLabel.trailingAnchor, constant: 4),

           
            lotStartInLbl.topAnchor.constraint(equalTo: offerLabel.bottomAnchor, constant: 8),
            lotStartInLbl.leadingAnchor.constraint(equalTo: offerLabel.leadingAnchor),

        ])
        
    }

    private func setupCountdownStack() {
      
        countdownStackView.backgroundColor = .clear // Parent is now transparent
        countdownStackView.axis = .horizontal
        countdownStackView.alignment = .center
        countdownStackView.distribution = .fillEqually
        countdownStackView.spacing = 4
        countdownStackView.translatesAutoresizingMaskIntoConstraints = false

        let timeUnits = ["D", "H", "M"]
        
        for unit in timeUnits {
            // Create a capsule container view
            let capsuleView = UIView()
            capsuleView.backgroundColor = UIColor(hex: "#FFF5E9")
            capsuleView.layer.cornerRadius = 16
            capsuleView.layer.masksToBounds = true
            capsuleView.translatesAutoresizingMaskIntoConstraints = false

            // Create the label
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 12)
            label.textColor = .orange
            label.textAlignment = .center
            label.text = "0\n\(unit)"
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false

            // Add label to capsule view
            capsuleView.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: capsuleView.topAnchor, constant: 6),
                label.bottomAnchor.constraint(equalTo: capsuleView.bottomAnchor, constant: -6),
                label.leadingAnchor.constraint(equalTo: capsuleView.leadingAnchor, constant: 8),
                label.trailingAnchor.constraint(equalTo: capsuleView.trailingAnchor, constant: -8)
            ])

            // Add capsule to the stack
            countdownStackView.addArrangedSubview(capsuleView)
        }

        contentView.addSubview(countdownStackView)
        NSLayoutConstraint.activate([
            countdownStackView.heightAnchor.constraint(equalToConstant: 100), // adjust height as needed
            countdownStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            countdownStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            countdownStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor ,constant: 20)
        ])
    }


    func configure(with product: ProductResponse) {
        titleLabel.text = product.name
        
        
        let priceTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: "price", comment: "") + "\n"
        let priceValue = "\(product.price ?? 0) \(product.currency)"

        let fullPriceText = NSMutableAttributedString(string: priceTitle, attributes: [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ])

        let priceValueText = NSAttributedString(string: priceValue, attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ])

        fullPriceText.append(priceValueText)
        priceLabel.attributedText = fullPriceText

       

        if let offer = product.offer {
            
            
            let offerTitle = LocalizationSystem.sharedInstance.localizedStringForKey(key: "offerPrice", comment: "") + "\n"
            let offerValue = "\(Int(offer)) \(product.currency)\n"
            let oldValue = "\(Int(product.price ?? 0)) \(product.currency)"

            // Create styled parts
            let attributedText = NSMutableAttributedString(string: offerTitle, attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ])

            let offerValueAttr = NSAttributedString(string: offerValue , attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ])

            let oldPriceAttr = NSAttributedString(string: oldValue, attributes: [
                .foregroundColor: UIColor.systemPink,
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ])

            // Combine
            attributedText.append(offerValueAttr)
            attributedText.append(oldPriceAttr)

            offerLabel.attributedText = attributedText
            
            offerLabel.isHidden = false
            oldPriceLabel.isHidden = false
     
        } else {
            offerLabel.isHidden = true
            oldPriceLabel.isHidden = true
        }

        if let url = URL(string: product.image) {
            
            productImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "shop"))
        }

        if let seconds = product.end_date {
            lotStartInLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "lotStartIn", comment: "")
            lotStartInLbl.textColor =  UIColor.gray
            let days = Int(seconds.rounded()) / 86400
            let hours = (Int(seconds.rounded()) % 86400) / 3600
            let minutes = (Int(seconds.rounded()) % 3600) / 60

            (0..<3).forEach {
                if let label = countdownStackView.arrangedSubviews[$0] as? UILabel {
                    let time = $0 == 0 ? days : $0 == 1 ? hours : minutes
                    let unit = ["D", "H", "M"][$0]
                    label.text = "\(time)\n\(unit)"
                }
            }
            countdownStackView.isHidden = false
            lotStartInLbl.isHidden = false
        } else {
            countdownStackView.isHidden = true
            lotStartInLbl.isHidden = true
        }
    }
}
