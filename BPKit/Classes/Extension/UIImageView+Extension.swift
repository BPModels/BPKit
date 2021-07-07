//
//  UIImageView+Extension.swift
//  BPKit
//
//  Created by samsha on 2021/7/7.
//

import Foundation

public extension UIImageView {
    /// 设置内边距
    /// - Parameters:
    ///   - image: 图片
    ///   - edge: 内边距
    func setInsets(with image: UIImage, edge: UIEdgeInsets) {
        let w = image.size.width + edge.left + edge.right
        let h = image.size.height + edge.top + edge.bottom
        UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 0.0)
        image.draw(in: CGRect(x: edge.left, y: edge.top, width: image.size.width, height: image.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
    }
}
