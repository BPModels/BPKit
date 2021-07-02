//
//  BPRedDotView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/7.
//

import Foundation

public class BPRedDotView: BPView {
    
    private var showNumber: Bool
    private let maxNumber: Int   = 99
    private var defaultH:CGFloat = .zero
    
    private let numLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textColor     = UIColor.white0
        label.textAlignment = .center
        return label
    }()
    
    public init(showNumber: Bool = false) {
        self.showNumber = showNumber
        super.init(frame: .zero)
        if showNumber {
            defaultH = AdaptSize(18)
        } else {
            // 小圆点
            defaultH = AdaptSize(5)
            self.size = CGSize(width: defaultH, height: defaultH)
        }
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        if showNumber {
            self.addSubview(self.numLabel)
            self.numLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.backgroundColor    = UIColor.red0
        self.layer.cornerRadius = defaultH/2
    }
    
    // MARK: ==== Event ====
    public func updateNumber(_ num: Int) {
        let value          = self.getNumberStr(num: num)
        self.numLabel.text = value
        self.isHidden      = num <= 0
        // update layout
        if self.superview != nil {
            var w = defaultH
            if (num > 9 || num < 0) {
                w = value.textWidth(font: numLabel.font, height: defaultH) + defaultH
            }
            self.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize(width: w, height: defaultH))
            }
        }
    }
    
    // TODO: ==== Tools ====
    public func getNumberStr(num: Int) -> String {
        return num > maxNumber ? "\(maxNumber)+" : "\(num)"
    }
    
}
