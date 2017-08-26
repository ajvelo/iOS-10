//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by ANDREAS VELOUNIAS on 06/08/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var users = [String: String]()
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var timeCreated = [Date]()
    let dateFormatter = DateFormatter()
    var imageFullscreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                self.users.removeAll()
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                    
                    
                }
                
            }
            
            
            let getFollowedUsersQuery = PFQuery(className: "Followers")
            
            getFollowedUsersQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                    
                    for object in followers {
                        
                        if let follower = object as? PFObject {
                            
                            let followedUser = follower["following"] as! String
                            
                            let query = PFQuery(className: "Posts")
                            
                            query.whereKey("userid", equalTo: followedUser)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    
                                    for object in posts {
                                        
                                        if let post = object as? PFObject {
                                            
                                            self.messages.append(post["message"] as! String)
                                            
                                            self.imageFiles.append(post["imageFile"] as! PFFile)
                                            
                                            self.usernames.append(self.users[post["userid"] as! String]!)
                                            
                                            self.timeCreated.append(post.createdAt! as Date)
                                            
                                            self.tableView.reloadData()
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                                
                            })
                            
                        }
                        
                        
                    }
                    
                }
                
            })
            
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let downloadedImage = UIImage(data: imageData) {
                    
                    cell.postedImage.image = downloadedImage
                    
                }
                
            }
            
        }

        let date = dateFormatter.string(from: timeCreated[indexPath.row])
        
        cell.postedImage.image = UIImage(named: "camera-icon-34.png")
        
        cell.usernameLabel.text = usernames[indexPath.row]
        
        cell.messageLabel.text = messages[indexPath.row]
        
        cell.date.text = date
        
        return cell
    }
    
    func removeImage() {
        
        let imageView = (self.view.viewWithTag(100)! as! UIImageView)
        imageView.removeFromSuperview()
        imageFullscreen = false
    }
    
    func addImageViewWithImage(image: UIImage) {
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.image = image
        imageView.tag = 100
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.removeImage))
        dismissTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(dismissTap)
        self.view.addSubview(imageView)
        imageFullscreen = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell
        
        if imageFullscreen {
            removeImage()
        }
        
        else {
            self.addImageViewWithImage(image: cell.postedImage.image!)
        }
    }
    
}
