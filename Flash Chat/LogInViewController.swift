//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        
        //TODO: Log in the user
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                
                print(error!)
            }else {
                
     //           print ("Login successful!")
                
                SVProgressHUD.dismiss ()
               self.performSegue(withIdentifier: "goToChat", sender: self)
                
//               self.dismiss(animated: true, completion: nil)
//
//               self.emailTextfield.endEditing(true)
//
//               self.passwordTextfield.endEditing(true)
//
//               self.loginButton.isEnabled = false
                
                
                
            }
        }
    }
    


    
}  
