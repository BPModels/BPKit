# BPLog

[![Swift](https://img.shields.io/badge/Swift-%3E=5.0-Orange?style=flat-square)](https://img.shields.io/badge/Swift-%3E=5.0-Orange?style=flat-square)

[![Platform](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)




## Example

> To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Requirements



## Installation



BPFile is available through [CocoaPods](https://cocoapods.org). To install

it, simply add the following line to your Podfile:



```ruby
pod 'BPLog'
```


## Author



TestEngineerFish, 916878440@qq.com



---

## Use

```swift
// 启动日志
BPOCLog.shared()?.launch()

/// 记录普通操作日志
public func BPLog(_ items: Any..., separator: String = " ", terminator: String = "\n")

/// 记录网络请求日志
public func BPRequestLog(_ items: Any..., separator: String = " ", terminator: String = "\n")

/// Socket请求日志
public func BPSocketLog(_ items: Any..., separator: String = " ", terminator: String = "\n")
```

* 网络请求日志：BPRequest("request")
* 普通操作日志：BPLog("e.g. click button")
* Socket日志：BPSocketLog(“response model”)

## 说明

可通过继承 **BPLogDelegate** 对打包后的日志追加需要的信息，比如用户信息和设备信息等
如需获取日志具体地址，可通过 **BPLogManger** 来获取，实际上大部分的操作也都是由其来提供

### BPLogManger

```swift
    /// 普通操作日志路径
    public var requestLogPath: String

    /// 网络请求日志路径
    public var normalLogPath: Strin

        /// 获取全部日志
    public func getAllLogZip() -> Data? 

    /// 删除全部日志
    public func deleteAllLog()

    /// 删除全部日志压缩包
    public func deleteAllZip()
```



