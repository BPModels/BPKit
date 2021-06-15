//
//  BPRefreshHeaderView.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

public class BPRefreshHeaderView: BPView {
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = .gray0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()
    public  var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        if let path = Bundle.main.path(forResource: "refresh", ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                let loadingGiftImage = UIImage.sd_image(withGIFData: data)
                imageView.image      = loadingGiftImage
            }
        }
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(imageView)
//        self.addSubview(titleLabel)
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(35), height: AdaptSize(35)))
            make.center.equalToSuperview()
        }
//        titleLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(imageView.snp.right).offset(AdaptSize(10))
//            make.height.centerY.right.equalToSuperview()
//        }
    }
    
    public func setStatus(status: BPRefreshStatus) {
        switch status {
        case .headerPulling:
            self.titleLabel.text = "下拉刷新"
        case .headerPullMax:
            self.titleLabel.text = "松手开始刷新"
        case .headerLoading:
            self.titleLabel.text = "刷新中～"
        default:
            self.titleLabel.text = ""
            return
        }
    }
}
