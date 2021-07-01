//
//  BPSelectView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/17.
//

import Foundation

public class BPPickerView: BPTopWindowView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var modelList: [BPPickerModel] = []
    private var selectedBlock: ((BPPickerModel)->Void)?

    private var contentView: BPView = {
        let view = BPView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: AdaptSize(280) + kSafeBottomMargin))
        view.backgroundColor = UIColor.white0
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: AdaptSize(10))
        return view
    }()
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(17))
        label.textAlignment = .center
        return label
    }()
    private var closeButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.close.rawValue, for: .normal)
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(13))
        return button
    }()
    private var confirmButton: BPButton = {
        let button = BPButton(.second)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.white0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        return button
    }()
    public let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        return pickerView
    }()
    
    public init(title: String, modelList: [BPPickerModel], selected block: ((BPPickerModel)->Void)?) {
        self.modelList = modelList
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.selectedBlock   = block
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        contentView.addSubview(confirmButton)
        contentView.addSubview(pickerView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kScreenHeight)
            make.centerX.equalToSuperview()
            make.size.equalTo(contentView.size)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(AdaptSize(25))
            make.height.equalTo(titleLabel.font.lineHeight)
        }
        let buttonSize = CGSize(width: AdaptSize(40), height: AdaptSize(60))
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(185), height: AdaptSize(40)))
            make.bottom.equalToSuperview().offset(AdaptSize(-30) - kSafeBottomMargin)
            make.centerX.equalToSuperview()
        }
        pickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(confirmButton.snp.top)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.pickerView.delegate   = self
        self.pickerView.dataSource = self
        self.closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
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
        let index = self.pickerView.selectedRow(inComponent: 0)
        self.selectedBlock?(modelList[index])
        self.hide()
    }
    
    // MARK: ==== UIPickerViewDelegate && UIPickerViewDataSource ====
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modelList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modelList[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = modelList[row].title
        let label = BPLabel()
        label.text          = title
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return AdaptSize(35)
    }
}
