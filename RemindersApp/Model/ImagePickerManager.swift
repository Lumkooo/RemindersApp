//
//  ImagePickerManager.swift
//  RemindersApp
//
//  Created by Андрей Шамин on 2/5/21.
//

import UIKit

class ImagePickerManager: NSObject {

    private var picker = UIImagePickerController();
    private var viewController: UIViewController?
    private var pickImageCallback : ((UIImage) -> ())?;

    init(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())){
        super.init()
        self.pickImageCallback = callback;
        self.viewController = viewController;
        self.picker.delegate = self
    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            self.viewController?.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title:"Warning", message: "You don't have camera", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            alertWarning.addAction(alertAction)
            alertWarning.show(alertWarning, sender: nil)
        }
    }

    func openGallery(){
        self.picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.pickImageCallback?(image)
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
}
