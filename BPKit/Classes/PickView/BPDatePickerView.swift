//
//  BPDatePickerView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/19.
//

import Foundation
public enum BPDatePickerType {
    case day
    case month
    case year
}

public class BPDatePickerView: BPTopWindowView {
    private var type: BPDatePickerType
    private var selectedBlock: ((Date)->Void)?

    private var contentView: BPView = {
        let view = BPView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: AdaptSize(220) + kSafeBottomMargin))
        view.backgroundColor = UIColor.white0
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(10))
        return view
    }()
    private var cancelButton: BPButton = {
        let button = BPButton()
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.gray0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
    private var confirmButton: BPButton = {
        let button = BPButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
    public let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh-Hans")
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()
    
    public init(type: BPDatePickerType = .day, selected block: ((Date)->Void)?) {
        self.type = type
        super.init(frame: .zero)
        self.selectedBlock = block
        self.createSubviews()
        self.bindProperty()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(contentView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(confirmButton)
        contentView.addSubview(datePicker)
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kScreenHeight)
            make.centerX.equalToSuperview()
            make.size.equalTo(contentView.size)
        }
        let buttonSize = CGSize(width: AdaptSize(80), height: AdaptSize(56))
        cancelButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
        datePicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
            make.top.equalTo(confirmButton.snp.bottom)
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard datePicker.subviews.first?.subviews.first?.subviews.count == 3 else {
            return
        }
        switch type {
        case .year:
            datePicker.subviews.first?.subviews.first?.subviews[0].isHidden = false
            datePicker.subviews.first?.subviews.first?.subviews[1].isHidden = true
            datePicker.subviews.first?.subviews.first?.subviews[2].isHidden = true
            datePicker.subviews.first?.subviews.first?.subviews[0].left += AdaptSize(75)
        case .month:
            datePicker.subviews.first?.subviews.first?.subviews[0].isHidden = false
            datePicker.subviews.first?.subviews.first?.subviews[1].isHidden = false
            datePicker.subviews.first?.subviews.first?.subviews[2].isHidden = true
            datePicker.subviews.first?.subviews.first?.subviews[0].left += AdaptSize(20)
            datePicker.subviews.first?.subviews.first?.subviews[1].left += AdaptSize(70)
        case .day:
            break
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    public func setMaxDate(date: Date) {
        self.datePicker.maximumDate = date
    }
    
    public func setMinDate(date: Date) {
        self.datePicker.minimumDate = date
    }
    
    public override func show(view: UIView = kWindow) {
        super.show(view: view)
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.height)
        }
    }
    
    @objc
    public override func hide() {
        super.hide()
        UIView.animate(withDuration: 0.25) { [weak self] in
               guard let self = self else { return }
               self.contentView.transform = .identity
        } completion: { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    func confirmAction() {
        let date = self.datePicker.date
        self.selectedBlock?(date)
        self.hide()
    }
}
