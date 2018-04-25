//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
 SVProgressHUD.show()
        //bn3aml authentaction b username w pass
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            //print(error!)
            
            if error != nil {
                print(error!)
                
            }else{
                //sucess
                print("sucesss whorayyy!")
 SVProgressHUD.dismiss()
                //case sucess go to chat
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
            }
        }
    
        

        
        
    } 
    
    
}
