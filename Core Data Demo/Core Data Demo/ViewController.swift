//
//  ViewController.swift
//  Core Data Demo
//
//  Created by ANDREAS VELOUNIAS on 01/08/2017.
//  Copyright © 2017 fusion. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var registerUsername: UITextField!
    @IBOutlet var registerPassword: UITextField!
    @IBOutlet var loginUsername: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var informationSaved: UILabel!
    @IBOutlet var loginSuccessful: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func registerButton(_ sender: Any) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        newUser.setValue(registerUsername.text, forKey: "username")
        newUser.setValue(registerPassword.text, forKey: "password")
        // newUser.setValue(30, forKey: "age")
        
        do {
            
            try context.save()
            
            informationSaved.text = "Information Saved!"
        }
        catch {
            
            // Process any errors
            print("Error")
        }
        
        registerUsername.resignFirstResponder()
        registerPassword.resignFirstResponder()
    }
   
    
    @IBAction func login(_ sender: Any) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.returnsObjectsAsFaults = false
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if loginUsername.text == registerUsername.text && loginPassword.text == registerPassword.text {
                    
                        if let username = result.value(forKey: "username") as? String {
                            
                            if let password = result.value(forKey: "password") as? String {
                                
                                loginSuccessful.text = "Login Successful!"
                                
                                print("Username: " + username + " Password: " + password)
                            }
                        }
                        
                        else {
                            print("username cannot be cast as key")
                        }
                    }
                        
                    else {
                        loginSuccessful.text = "Username or password incorrect."
                        
                        }
                }
        }
            else {
                loginSuccessful.text = "Username or password not found."
                
            }
        }
        catch {
            
            // Process any errors
            print("Couldn't fetch results")
        }
        
        loginUsername.resignFirstResponder()
        loginPassword.resignFirstResponder()

    }
    
    @IBAction func deleteAll(_ sender: Any) {
        deleteAllData(entity: "Users")
        registerUsername.text = ""
        registerPassword.text = ""
        loginUsername.text = ""
        loginPassword.text = ""
        print("Deleted")
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        registerUsername.resignFirstResponder()
        registerPassword.resignFirstResponder()
        loginUsername.resignFirstResponder()
        loginPassword.resignFirstResponder()
        return true
    }
    
    func deleteAllData(entity: String)
    {
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            
            for result in results as! [NSManagedObject] {
                
                context.delete(result)
            }
        }
        
        catch {
            print("Object could not be deleted")
        }
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
}

