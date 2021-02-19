//
//  ImagePicker.swift
//  TowBoss
//
//  Created by lavi on 05/12/19.
//  Copyright © 2019 lavi. All rights reserved.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    /**
     Return picked image with fixed orientation
     - parameter info : info is picked image detail data
     */
    func didFinishPickingImage(_ info: AnyObject?)
}

class ImagePicker : NSObject {
    
    fileprivate var imagePicker : UIImagePickerController? = nil
    fileprivate var target      : UIViewController?
    public weak var delegate    : ImagePickerDelegate?
    
    /**
     Show Action Sheet to choose source type of image picker and then present image picker.
     - parameter target : To pass reference of current controller as a parent object to present image picker.
     */
    public func showImagePicker(_ target : UIViewController) {
        self.target = target
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.showActionSheet()
    }
    
    //Action Sheet
    fileprivate func showActionSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        target?.present(alert, animated: true, completion: nil)
    }
    
    //Camera
    fileprivate func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            //Camera Avialable in Device
            imagePicker?.sourceType = UIImagePickerController.SourceType.camera
            imagePicker?.allowsEditing = true
            target?.present(imagePicker!, animated: true, completion: nil)
        }else{
            //Camera not available in Device
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            target?.present(alert, animated: true, completion: nil)
        }
    }
    
    //Gallery
    fileprivate func openGallary(){
        imagePicker?.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        target?.present(imagePicker!, animated: true, completion: nil)
    }
    
    /**
     Show Image Picker to Pick image with given source type 'Library' or 'Camera'
     - parameter target : To pass reference of current controller as a parent object to present image picker.
     sourceType : Source Type is to open either camera or Photo Library
     */
    public func showImagePickerWith(_ target: UIViewController,with sourceType : UIImagePickerController.SourceType) {
        self.target = target
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.sourceType = sourceType
        self.imagePicker?.delegate = self
        self.target?.present(imagePicker!, animated: true, completion: nil)
    }
}

//MARK:- Image Picker Delegate
extension ImagePicker : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.delegate?.didFinishPickingImage(info as AnyObject)
        target?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Send response to main controller view
        self.delegate?.didFinishPickingImage(nil)
        self.target?.dismiss(animated: true, completion: nil)
    }
}



