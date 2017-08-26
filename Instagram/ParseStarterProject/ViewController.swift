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
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signupOrLogin: UIButton!
    @IBOutlet var changeSignupMode: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if email.text == "" || password.text == "" {
            
            createAlert(title: "Error", message: "Please enter a username and password")
        }
        
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
                
            if signupMode {
                
                //Sign Up
                let user = PFUser()
                
                user.username = email.text
                user.password = password.text
                
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
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            }
            
            else {
                
                //Log In
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: { (user, error) in
                    
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
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
                
            }
        }
        
        email.resignFirstResponder()
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
}
