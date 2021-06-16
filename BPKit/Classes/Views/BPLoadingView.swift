//
//  BPLoadingView.swift
//  Tenant
//
//  Created by samsha on 2021/2/18.
//

import Foundation
import SDWebImage

open class BPLoadingView: BPView {

    private var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        if let path = Bundle.main.path(forResource: "loading", ofType: "gif") {
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
        self.createSubviews()
        self.bindProperty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptSize(-30))
            make.size.equalTo(CGSize(width: AdaptSize(122), height: AdaptSize(150)))
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = UIColor.hex(0xf8f8f8)
        self.layer.opacity   = 0.0
    }
    
    // MARK: ==== Event ====
    public func show(view: UIView = kWindow, delay: Double) {
        // 延迟显示
        DispatchQueue.main.async {
            self.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, !self.isHidden else { return }
            view.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(kNavHeight)
            }
            UIView.animate(withDuration: 0.25) {
                self.layer.opacity = 1.0
            }
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            self.isHidden = true
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
}

