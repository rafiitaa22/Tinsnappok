//
//  PostViewController.swift
//  Tinsnappok
//
//  Created by Rafael Larrosa Espejo on 28/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    var activityIndicator : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        
        self.hideKeyboardWhenTappingAround()

        // Do any additional setup after loading the view.
    }

    @IBAction func uploadImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Selecciona una imagen", message: "¿De donde deseas escoger la imagen?", preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.loadFromLibrary()
        }
        alertController.addAction(libraryAction)
        
        let cameraAction = UIAlertAction(title: "Cámara de fotos", style: .default) { (action) in
            self.takePhoto()
        }
        alertController.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func loadFromLibrary(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary //añadir camara en la app oficial
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func takePhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera //añadir camara en la app oficial
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func publish(_ sender: UIButton) {
        self.startActivityIndicator()
        let post = PFObject(className: "Post")
        post["idUser"] = PFUser.current()?.objectId
        post["message"] = self.textView.text
        
        let imageData = UIImageJPEGRepresentation(self.imageView.image!, 0.8)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        post["imageFile"] = imageFile
        
        post.saveInBackground { (sucess, error) in
            self.stopActivityIndicator()
            if error != nil{
                self.sendAlert(title: "No se ha subido la imagen", message: (error?.localizedDescription)!)
                
            }else{
                self.sendAlert(title: "¡Post publicado!", message: "¡Has publicado correctamente tu post!")
                self.textView.text = ""
                self.imageView.image = #imageLiteral(resourceName: "placeholder")
                
                
            }
        }
        
        
    }
    
    func startActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(){
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func sendAlert(title:String,message:String){
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Vale", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//cerrr teclado

extension PostViewController{
    func hideKeyboardWhenTappingAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

extension PostViewController: UITextViewDelegate{
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}



