//
//  BPDottedLineView.swift
//  Tenant
//
//  Created by samsha on 2021/2/8.
//

import Foundation

/// 水平虚线
class BPDottedLineView: BPView {
    
    init(size: CGSize) {
        super.init(frame: CGRect(origin: .zero, size: size))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== Event ====
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let shapLayer = CAShapeLayer()
        shapLayer.bounds = self.bounds
        shapLayer.position = CGPoint(x: width/2, y: height)
        shapLayer.fillColor   = UIColor.clear.cgColor
        shapLayer.strokeColor = UIColor.gray2.cgColor
        shapLayer.lineWidth   = 0.6
        shapLayer.lineJoin    = .round
        shapLayer.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 2)]
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: width, y: 0))
        shapLayer.path = path.cgPath
        self.layer.addSublayer(shapLayer)
    }
}

