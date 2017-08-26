//
//  MatchesTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by ANDREAS VELOUNIAS on 07/08/2017.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {
    
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var messagesLabel: UILabel!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var send: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func Send(_ sender: Any) {
        
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId!
        
        message["recipient"] = userIdLabel.text
        
        message["content"] = messageTextField.text
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        message.saveInBackground()
        
        send.setTitle("Message Sent!", for: .normal)
        send.setTitleColor(UIColor.red, for: .normal)
        send.isEnabled = false
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        send.setTitle("Send", for: .normal)
        send.setTitleColor(UIColor.blue, for: .normal)
        send.isEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
