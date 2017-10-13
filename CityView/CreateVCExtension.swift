//
//  CreateVCExtension.swift
//  CityView
//
//  Created by admin on 7/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func handleSelectLibraryImage(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = false
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PhotoViewController") as! ConfirmPhotoViewController
        vc.backgroundImage = selectedImageFromPicker
        
        
        
            print("finish seleet")
        
        
        dismiss(animated: true, completion: nil)
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

}
