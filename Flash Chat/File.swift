//
//  File.swift
//  Flash Chat
//
//  Created by Mido on 10/9/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

class Messages {
    
    func showAlertWithDistructiveButton() {
        let alert = UIAlertController(title: "Sign out?", message: "Do you really want to Logout ", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
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
