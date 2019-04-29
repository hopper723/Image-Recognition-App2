//
//  ViewController.swift
//  Image Recognition App2
//
//  Created by Hiu Man Yeung on 4/28/19.
//  Copyright © 2019 Hiu Man Yeung. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let apiKey = API().visual_recognition_api
    let version = "2019-04-28"
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            visualRecognition.classify(image: pickedImage) { (response, error) in
                if let result = response?.result {
                    DispatchQueue.main.async {
                        self.navigationItem.title = result.images.first!.classifiers.first!.classes.first!.className
                    }
                } else {
                    print("Unable to classify image")
                }
            }
        } else {
            print("No photos")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

