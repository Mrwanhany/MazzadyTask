//
//  Wrap.swift
//  Mazzady-Task
//
//  Created by Mrwan on 26/04/2025.
//
import UIKit

final class WrapStackView: UIView {
    private let spacing: CGFloat
    private var arrangedSubviews: [UIView] = []

    init(spacing: CGFloat = 8) {
        self.spacing = spacing
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addArrangedSubview(_ view: UIView) {
        arrangedSubviews.append(view)
        addSubview(view)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var x: CGFloat = 0
        var y: CGFloat = 0
        let maxWidth = bounds.width

        for subview in arrangedSubviews {
            subview.sizeToFit()
            let width = subview.frame.width + 16 // for padding
            let height = subview.frame.height + 8

            if x + width > maxWidth {
                x = 0
                y += height + spacing
            }

            subview.frame = CGRect(x: x, y: y, width: width, height: height)
            x += width + spacing
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalHeight: CGFloat = 0
        var rowWidth: CGFloat = 0
        var maxRowHeight: CGFloat = 0

        for view in arrangedSubviews {
            view.sizeToFit()
            let width = view.frame.width + 16
            let height = view.frame.height + 8

            if rowWidth + width > size.width {
                totalHeight += maxRowHeight + spacing
                rowWidth = 0
                maxRowHeight = 0
            }

            rowWidth += width + spacing
            maxRowHeight = max(maxRowHeight, height)
        }

        totalHeight += maxRowHeight
        return CGSize(width: size.width, height: totalHeight)
    }
}
