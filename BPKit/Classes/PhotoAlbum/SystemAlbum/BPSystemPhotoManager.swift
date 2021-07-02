//
//  BPSystemPhotoManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import AVFoundation
import Photos.PHPhotoLibrary

public class BPSystemPhotoManager: BPView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public static let share = BPSystemPhotoManager()
    private var completeBlock: MediaListBlock?
    
    /// 显示选择相机还是相册
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    public func show(complete block:MediaListBlock?, maxCount: Int = 1) {
        BPActionSheet().addItem(title: "相册", actionBlock: {
            BPSystemPhotoManager.share.showPhoto(complete: { (modelList) in
                block?(modelList)
            }, maxCount: maxCount)
        }).addItem(title: "相机", actionBlock: {
            BPSystemPhotoManager.share.showCamera { (modelList) in
                block?(modelList)
            }
        }).show()
    }
    
    /// 显示系统相机
    /// - Parameter block: 拍照后回调
    public func showCamera(complete block:MediaListBlock?) {
        BPAuthorizationManager.share.camera { [weak self] (result) in
            guard let self = self, result else { return }
            self.completeBlock = block
            let vc = UIImagePickerController()
            vc.delegate      = self
            vc.allowsEditing = true
            vc.sourceType    = .camera
            UIViewController.currentViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    /// 显示系统相册
    /// - Parameters:
    ///   - block: 选择后的回调
    ///   - maxCount: 最大选择数量
    public func showPhoto(complete block: MediaListBlock?, maxCount: Int = 1) {
        BPAuthorizationManager.share.photo { [weak self] (result) in
            guard let self = self, result else { return }
            self.completeBlock = block
            let vc = BPSystemPhotoViewController()
            vc.maxSelectCount = maxCount
            vc.selectedBlock = { [weak self] (medioModelList) in
                guard let self = self else { return }
                self.completeBlock?(medioModelList)
            }
            UIViewController.currentNavigationController?.push(vc: vc)
        }
    }

    // MARK: ==== UIImagePickerControllerDelegate, UINavigationControllerDelegate ====
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        BPLog("取消选择照片")
        self.completeBlock?([])
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        var model = BPMediaModel()
        model.image = image
        self.completeBlock?([model])
        BPLog("选择了照片")
        picker.dismiss(animated: true, completion: nil)
    }
}
