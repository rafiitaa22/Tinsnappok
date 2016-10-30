/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet var imageLogin: UIImageView!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var activityIndicator :UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        
        //Descomenta esta linea para probar que Parse funciona correctamente
        /* let user = PFObject(className: "Users")
        user["name"] = "Rafa"
        user.saveInBackground { (sucess, error) in
            if sucess {
                print("El usuario se ha guardado correctamente en Parse")
            }else{
                if error != nil{
                    print(error?.localizedDescription)
                    
                }else{
                    print("Error desconocido")
                }
            }
 */
        // modificar un usuario creado
        let query = PFQuery(className: "Users")
        query.getObjectInBackground(withId: "ArsWOLdkju") { (object, error) in
            if error != nil{
                print(error?.localizedDescription)
            
            }else{
                if let user = object{
                    user["name"] = "Rafa"
                    user.saveInBackground(block: { (sucess, error) in
                        if sucess {
                            print("Se ha modificado correctamente")
                        }else{
                            print(error?.localizedDescription)
                        }
                    })
                }
            }
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.current()?.username != nil {
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
        
        
        
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        if infoCompleted(){
            //Procedemos a registrar al usuario
            
           self.startActivityIndicator()
            
            
            
            let user = PFUser()
            user.username = self.emailTextField.text
            user.email = self.emailTextField.text
            user.password = self.passwordTextField.text
            user.signUpInBackground(block: { (sucess, error) in
                
            self.stopActivityIndicator()
            
                
                if error != nil{
                    var errorMessage = "¡Uy! Ha habido un error.."
                    
                    if let parseError = error?.localizedDescription {
                        errorMessage = parseError
                
                    }
                    
                    self.createAlert(title: "Error de registro", message: errorMessage)
                    
                } else{
                    
                    print("usuario registrado correctamente")
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                    
                }
            })
        }
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if infoCompleted(){
            //Procedemos a logear al usuario
            
            self.startActivityIndicator()
            
            PFUser.logInWithUsername(inBackground: self.emailTextField.text!, password: self.passwordTextField.text!, block: { (user, error) in
                
            self.stopActivityIndicator()
                
                if error != nil{
                    
                    var errorMessage = "¡Uy! Ha habido un error.."
                    
                    if let parseError = error?.localizedDescription {
                        errorMessage = parseError
                        
                    }
                    
                    self.createAlert(title: "Error al iniciar sesión", message: errorMessage)
                    
                } else{
                    
                    print("Hemos entrado correctamente")
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                    
                }
            })
            
            
            
        }
    }

    @IBAction func recoverPassword(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func infoCompleted () -> Bool {
        var infoCompleted = true
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            infoCompleted = false
            
            createAlert(title: "Verifica tus datos", message: "Asegurate de introducir una correo y contraseña válido.")
           
            
        }
        
        return infoCompleted
    }
    
    func createAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func startActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(){
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
}

extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
