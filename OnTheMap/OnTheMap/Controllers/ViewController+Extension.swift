//
//  ViewController+Extension.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/23/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Actions
    @IBAction func tappedLogout(_ sender: UIBarButtonItem) {
        Client.logout { (error) in
            if error != nil {
                self.showErrorMessage(title:"Logout failed", message: error?.localizedDescription ?? "")
            }else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Logout", sender: self)
                }
            }
        }
    }
    
    @IBAction func tappedRefresh(_ sender: UIBarButtonItem) {
        Client.getStudentLocation { (studentLocation, error) in
            if let error = error {
                self.showErrorMessage(title:"Download failed", message: error.localizedDescription)
                return
            }
            InformationList.studentInformationList = studentLocation
        }
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        if  Client.objectId != nil  {
            showAlertWithDistructiveButton()
        } else {
            Client.getUserInfo { (error) in
                if let error = error {
                    self.showErrorMessage(title:"Failed To Get User Data", message: error.localizedDescription)
                    return
                }
            }
            
            self.performSegue(withIdentifier: "FindLocationVC", sender: nil)
        }
    }
    
    //MARK: Alert messages fuctions
    
    //show alert for updating a location
    func showAlertWithDistructiveButton() {
        let alert = UIAlertController(title: "location exist", message: "do want to modify?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
                                        self.performSegue(withIdentifier: "FindLocationVC", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //show alert for errors
    func showErrorMessage(title: String ,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

