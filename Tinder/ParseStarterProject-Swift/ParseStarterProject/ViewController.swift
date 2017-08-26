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

class ViewController: UIViewController, UITextFieldDelegate {
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signupOrLogin: UIButton!
    @IBOutlet var changeSignupMode: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if username.text == "" || password.text == "" {
            
            createAlert(title: "Error", message: "Please enter a username and password")
        }
            
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode {
                
                //Sign Up
                let user = PFUser()
                
                user.username = username.text
                user.password = password.text
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                acl.getPublicReadAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again"
                        
                        if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                        }
                        
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                    }
                        
                    else {
                        
                        print("User signed up")
                        
                        self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                    }
                })
            }
                
            else {
                
                //Log In
                PFUser.logInWithUsername(inBackground: username.text!, password: password.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again"
                        
                        if let errorMessage = (error! as NSError).userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                        }
                        
                        self.createAlert(title: "Log In Error", message: displayErrorMessage)
                        
                    }
                        
                    else {
                        
                        print("Logged In")
                        
                        self.redirectUser()
                    }
                })
                
            }
        }
        
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            
            // Change to login mode
            
            signupOrLogin.setTitle("Log In", for: [])
            
            changeSignupMode.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Don't have an account?"
            
            signupMode = false
        }
            
        else {
            
            // Change to sign up mode
            
            signupOrLogin.setTitle("Sign up", for: [])
            
            changeSignupMode.setTitle("Log in", for: [])
            
            messageLabel.text = "Already have an account?"
            
            signupMode = true
        }
    }
    
    func redirectUser() {
        
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["photo"] != nil  {
                
                performSegue(withIdentifier: "swipeFromInitialSeque", sender: self)
            }
                
            else {
                
                performSegue(withIdentifier: "goToUserInfo", sender: self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        redirectUser()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
