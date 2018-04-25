//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    // Declare instance variables here

    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        
        //TODO: Set yourself as the delegate of the text field here:
         messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
       
        //sensor lama user yadoos f ay 7etta y3aml call le method call view Tapped
        
        let tapGesture = UITapGestureRecognizer(target: self,
        action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        
        
        //TODO: Register your MessageCell.xib file here:

        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    //means every cell shape design is here
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell design
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        //CHECK IF WE OR ANOTHER USER
        if cell.senderUsername.text ==
            Auth.auth().currentUser?.email as String! {
            //message we sent
            
            cell.avatarImageView.backgroundColor = UIColor.flatRed()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        else {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatMagenta()
        }
       
        return cell
    }
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    //how many celles in my table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped () {
        //kda el view tapped yro7 yandeh method bat3at end editing
        messageTextfield.endEditing(true)
    }
    
    
    
    //TODO: Declare configureTableView here:
    
    //method to set heigh and the width of the msg container
    func configureTableView () {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
 //Animation
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    //user is beginning to type
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
           self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    //we called it manually b3d lma ya5las w ydos f aay 7aetta
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
       
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary){ //generate random id
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print ("Message Saved Successfully")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages (){
        
    let messagedb = Database.database().reference().child("Messages")
        
        messagedb.observe(.childAdded, with: {(snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        })
        
        
    }
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        //firebase loging out code
        do{
            
        try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            print("Sucess Loging out")
        
        }catch {
            print("error sigining out")
        }
        
    }
    


}
