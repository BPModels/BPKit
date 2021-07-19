# BPKit

[![CI Status](https://img.shields.io/travis/TestEngineerFish/BPKit.svg?style=flat)](https://travis-ci.org/TestEngineerFish/BPKit)
[![Version](https://img.shields.io/cocoapods/v/BPKit.svg?style=flat)](https://cocoapods.org/pods/BPKit)
[![License](https://img.shields.io/cocoapods/l/BPKit.svg?style=flat)](https://cocoapods.org/pods/BPKit)
[![Platform](https://img.shields.io/cocoapods/p/BPKit.svg?style=flat)](https://cocoapods.org/pods/BPKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BPKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BPKit'
```

## Author

TestEngineerFish, 916878440@qq.com

## License

BPKit is available under the MIT license. See the LICENSE file for more info.



## USE

### 暗黑模式

> 所有自定义视图，都需要继承自 **BPView** ,或对应的子类，比如 **BPTableViewCell**
>
> 视图中的颜色设置，均需要放在 **updateUI()** 函数中申明，此函数会在视图初始化和切换暗黑模式时被调用
>
> 视图的Color赋值，建议使用 **UIColor.with( normal: UIColor, dark: UIColor)** 便于在不同模式显示不同的颜色
>
> 默认根视图都有默认设置黑白颜色

### BPTableView

* 刷新、加载更多

    ```swift
    // 开启下拉刷新
    self.tableView.setRefreshHeaderEnable {
          // 下拉请求的接口
            self.request()
    }
    // 开启上拉加载更多
    self.tableView.setRefreshFooterEnable {
          // 上拉请求的接口
            self.request()
    }
    
    // 注意⚠️
        public func request() {
            guard let request = self.delegate?.request else { return }
            BPNetworkService.default.request(BPStructDataArrayResponse<T>.self, request: request) { (response) in
                guard let modelList = response.dataArray else { return }
                if self.tableView.page > 1 {
                    self.modelList += modelList
                } else {
                    self.modelList = modelList
                }
                self.tableView.reloadData()
            } fail: { (error) in
                // 在请求的失败回调中，需要结束刷新状态
                self.tableView.scrollEnd()
                kWindow.toast((error as NSError).message)
            }
        }
    ```

* 索引

    ```swift
    /// 实现索引回调即可
    tableView.indexDelegate = self
    /// 索引内容
    func indexTitle(section: Int) -> String
    ```

* 空页面

    ```swift
    /// 实现协议
    tableView.dataSource = self
    /// 设置空页面内容
        /// - Parameters:
        ///   - image: 图片（为空则取默认图）
        ///   - hintText: 文案
        ///   - buttonText: 按钮文案
        ///   - actionBlock: 按钮事件
    self.tableView.dataSource?.setDefaultViewData(image: nil, hintText: "暂无内容", buttonText: "添加", actionBlock: {
        print("Show create view controller")
    })
    ```

* 通用列表 **BPTableViewController**

    ```swift
    /// 继承自 BPTableViewController
    /// BPModel：列表数据类型
    /// BPTestell：列表类型 
    class ViewController: BPTableViewController<BPModel, BPTestCell>, BPTableViewControllerDelegate {}
    
    /// 协议如下
    public protocol BPTableViewControllerDelegate: NSObjectProtocol {
        /// 显示的Header（可选）
        func headerView() -> BPView
        /// 显示的Footer（可选）
        func footerView() -> BPView
        /// 请求体 （ --必须实现--）
        var request: BPRequest { get set }
        /// 是否显示搜索（可选）
        var isShowSearch: Bool { get }
        /// 是否显示筛选（可选）
        var isShowFilter: Bool { get }
        /// 是否显示悬浮添加按钮（可选）
        var isShowAddButton: Bool { get }
    }
    ```

* 通用Cell **BPCommonTableViewCell**

    ```swift
            /// 配置数据
        /// - Parameters:
        ///   - isRequired: 是否必选
        ///   - title: 标题
        ///   - placeholder: 默认
        ///   - canEdit: 是否可编辑
        ///   - icon: 图标
        ///   - unit: 单位
        ///   - hideLine: 是否显示底部分割线
        public func setData(_ isRequired: Bool, title: String?, placeholder: String?, canEdit: Bool, icon: UIImage?, unit: String?, hideLine: Bool = true) 
    ```
    
    

