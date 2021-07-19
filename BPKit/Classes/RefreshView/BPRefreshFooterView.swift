//
//  BPRefreshFooterView.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

public class BPRefreshFooterView: BPView {
    public var titleLabel: UILabel = {
        let label = UILabel()
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    public override func updateUI() {
        super.updateUI()
        titleLabel.textColor = .gray0
        self.backgroundColor = .clear
    }
    
    public func setStatus(status: BPRefreshStatus) {
        switch status {
        case .footerPulling:
            self.titleLabel.text = "上拉加载更多"
        case .footerPullMax:
            self.titleLabel.text = "松手开始加载"
        case .footerLoading:
            self.titleLabel.text = "加载中～"
        default:
            self.titleLabel.text = ""
        }
    }
}
