//
//  ViewController.swift
//  MachineLearning
//
//  Created by Moe Latt on 5/18/19.
//  Copyright © 2019 Moe Latt. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType =  .camera//open camera with .camera .photoLibrary
        imagePicker.allowsEditing = false
      
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let pickCameraImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = pickCameraImage
            
            guard let ciImage = CIImage(image: pickCameraImage) else{
                fatalError("can not convert image")
            }
            detection(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detection(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)else{
            fatalError("Loading coreML modle is failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation], let firstResult = result.first else{
                fatalError("model fail to process image and confidence value")
            }
           // self.textLabel.text = result.first?.identifier
            self.textLabel.text = (result.first?.identifier)
            self.textLabel.numberOfLines = 0
            self.textLabel.text = "\(Int(firstResult.confidence * 100))% match it is a \(firstResult.identifier)"
            
            print(result)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func removeImage(_ sender: UIBarButtonItem) {
        imageView.image = .none
        textLabel.text = .none
        
    }
    
}

