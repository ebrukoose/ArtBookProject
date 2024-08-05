//
//  DetailsVC.swift
//  ArtBookProje
//
//  Created by EBRU KÖSE on 31.07.2024.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding a tap gesture to hide the keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        
        // Adding a tap gesture to select an image
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        // Attributes
        if let name = nameField.text, !name.isEmpty {
            newPainting.setValue(name, forKey: "name")
        }
        
        if let artist = artistField.text, !artist.isEmpty {
            newPainting.setValue(artist, forKey: "artist")
        }
        
        if let yearText = yearField.text, let year = Int(yearText) {
            newPainting.setValue(year, forKey: "year")
        }
        
        newPainting.setValue(UUID(), forKey: "id")
        
        if let image = imageView.image {
            let imageData = image.jpegData(compressionQuality: 0.5)
            newPainting.setValue(imageData, forKey: "image")
        }
        
        do {
            try context.save()
            print("Success")
        } catch {
            print("Failed to save: \(error)")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

