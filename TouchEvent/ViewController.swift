//
//  ViewController.swift
//  TouchEvent
//
//  Created by 大場史温 on 2024/08/23.
//

import UIKit
import PhotosUI


class ViewController: UIViewController, PHPickerViewControllerDelegate  {
    
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    var selectedImageName: String = "flower"
    
    var imageViewArray: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func selectImage1() {
        selectedImageName = "flower"
    }
    
    @IBAction func selectImage2() {
        selectedImageName = "cloud"
    }
    
    @IBAction func selectImage3() {
        selectedImageName = "heart"
    }
    
    @IBAction func selectImage4() {
        selectedImageName = "star"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: view)
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        imageView.image = UIImage(named: selectedImageName)
        imageView.center = location
        
        view.addSubview(imageView)
        
        imageViewArray.append(imageView)
    }
    
    @IBAction func changeBackground () {
        var configuration = PHPickerConfiguration()
        
        configuration.filter = PHPickerFilter.images
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first!.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.backgroundImageView.image = image as? UIImage
                }
            }
        }
        dismiss(animated: true)
    }
    
    @IBAction func save() {
        UIGraphicsBeginImageContextWithOptions(backgroundImageView.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: -backgroundImageView.frame.origin.x, y: -backgroundImageView.frame.origin.y)
        view.layer.render(in: context)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenShot!, nil, nil, nil)
    }
    
    @IBAction func undo() {
        if imageViewArray.isEmpty{return}
        let removeImage = imageViewArray.last!
        removeImage.removeFromSuperview()
        imageViewArray.removeLast()
    }

}

