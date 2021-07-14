//
//  BPBaseImageView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/7.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Kingfisher

open class BPImageView: UIImageView, BPViewDelegate {
    /// 下载进度闭包
    public typealias ImageDownloadProgress   = (CGFloat) -> Void
    /// 下载完成闭包
    public typealias ImageDownloadCompletion = ((_ image: UIImage?, _ error: Error?, _ imageURL: URL?) -> Void)

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateUI()
    }
    public init() {
        super.init(frame: .zero)
        self.updateUI()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.updateUI()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== BPViewDelegate ====
    open func createSubviews() {}
    
    open func bindProperty() {}
    
    open func bindData() {}
    
    open func updateUI() {
        // 默认颜色
        self.backgroundColor = UIColor.with(.white0, dark: .black0)
    }
    
    public func showImage(with imageStr: String, placeholder: UIImage? = nil, completion: ImageDownloadCompletion? = nil, downloadProgress: ImageDownloadProgress? = nil) -> Void {

        let imageURL = URL(string: imageStr)

        self.kf.setImage(with: imageURL, placeholder: placeholder, options: [], progressBlock: { (receivedByte, totalByte) in
            let progress = CGFloat(receivedByte / totalByte)
            downloadProgress?(progress)
        }) { (result: Result<RetrieveImageResult, KingfisherError>) in
            switch result {
            case .success(let data):
                self.image = data.image
                completion?(data.image, nil, data.source.url)
            case .failure(let error):
                completion?(nil, error, imageURL)
            }
        }
    }
    
    // MARK: ==== Event ====
    public func setCorner(radius: CGFloat) {
        self.layer.cornerRadius  = radius
        self.layer.masksToBounds = true
    }
    
    /// 设置必填图片
    public func setRequisiteImage() {
        self.image = UIImage(named: "icon_requisite")
    }
}
