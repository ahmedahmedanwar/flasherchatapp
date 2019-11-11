//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
    
    // Declare instance variables here

    var messageArray : [ Message ] = [Message] ()
    
    
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
        
        navigationItem.hidesBackButton = true
        //TODO: Set yourself as the delegate of the text field here:

        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        
        let tapgesture = UITapGestureRecognizer (target: self, action:
            #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapgesture)

        //TODO: Register your MessageCell.xib file here:
        
            messageTableView.register(UINib (nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
        
    }
    

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
    
        cell.messageBody.text = messageArray [indexPath.row].messageBody
        cell.senderUsername.text = messageArray [indexPath.row].sender
        
        cell.avatarImageView.image = UIImage (named: "egg")
        
        if 	cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            cell.avatarImageView.backgroundColor = UIColor.green
            cell.messageBackground.backgroundColor = UIColor.gray
            
        }else{
            
            cell.avatarImageView.backgroundColor = UIColor.purple
                       cell.messageBackground.backgroundColor = UIColor.orange
            
        }
        
        
      
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    //TODO: Declare tableViewTapped here:
    
    @objc func tableViewTapped (){
        
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView (){
        
        messageTableView.rowHeight = UITableView.automaticDimension
        
         messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        UIView.animate(withDuration: 0.5) {
            
            self.heightConstraint.constant = 351
            
            
            NotificationCenter.default.addObserver(self,
            selector: #selector(self.keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            
            self.view.layoutIfNeeded()
            
        }
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    
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
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
    
       let messagesDB = Database.database().reference().child("Messages")
        
       let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                "MessageBody": messageTextfield.text!]
      
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in

            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully!")
            }

            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""


        }

    }
    
        
    //TODO: Create the retrieveMessages method here:
    
    
    func retrieveMessages () {
    
        let messagesDB = Database.database().reference().child("Messages")

        messagesDB.observe(.childAdded) { (snapshot) in
           let  snapshotValue = snapshot.value as! Dictionary<String,String >
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
                let messages = Message()
                messages.messageBody = text
                messages.sender = sender
            
            	self.messageArray.append(messages)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        do {
            try Auth.auth().signOut()
            
               showAlertWithDistructiveButton()

            
        }
        catch {
            
            print ("an error has been happend")
            
            showAlert()
            }
       
        }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
             let keyboardHeight = keyboardRectangle.height
            
            print(keyboardHeight)
        }
        
        }
    
    }

extension ChatViewController {
    
    
    func showAlertWithDistructiveButton() {
        let alert = UIAlertController(title: "Sign out?", message: "Do you really want to Logout ", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
        }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
                                        if
                                            self.navigationController?.popToRootViewController(animated: true) != nil {
                                            }else {
                                            
                                            self.showAlert()
                                        }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Unexpected error", message: "Sorry unexpected error happend please ceck your internet status ", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: " OK ",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

}



