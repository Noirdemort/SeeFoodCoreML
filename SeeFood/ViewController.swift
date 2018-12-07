//
//  ViewController.swift
//  SeeFood
//
//  Created by Noirdemort on 07/11/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var resultLabel: UILabel!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }


    @IBAction func cameraPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
        imageView.image = image as? UIImage
        
        let ciimage = CIImage(image:  imageView.image!)
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        detect(image: ciimage!)
    }
    
    func detect(image: CIImage){
        do{
        let model = try VNCoreMLModel(for: Inceptionv3().model)
        let request = VNCoreMLRequest(model: model,completionHandler: { (request, error) in
                let results = request.results as? [VNClassificationObservation]
            let firstResult = results?.first
            
            if (firstResult?.identifier.contains("hotdog"))!{
                self.resultLabel.text =  "HotDog!"
            }else{
                self.resultLabel.text = firstResult?.identifier
            }
        })
        let handler = VNImageRequestHandler(ciImage: image)
        
        try handler.perform([request])
            
        } catch {
            print("Couldn't load model")
            exit(1)
        }
        
        
    }
}

