//
//  ViewController.swift
//  OnTheMap
//
//  Created by Fato0omAH on 9/7/19.
//  Copyright © 2019 Fatema. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        username.text = ""
        password.text = ""
    }
    
    //MARK: Actions
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        username.text = ""
        password.text = ""
    }
    @IBAction func tappedLogin(_ sender: Any) {
        setLoggingIn(true)
        Client.login(username: self.username.text ?? "", password: self.password.text ?? "", completion: handleLoginResponse(success:error:isNetworkError:))
    }
    
    @IBAction func tappedSignUp(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")!, options: [:], completionHandler: nil)
    }
    
    //MARK: Other functions
    
    //handle login response
    func handleLoginResponse(success: Bool, error: Error?, isNetworkError: Bool) {
        setLoggingIn(false)
        if success {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }else{
            if !isNetworkError{
                self.showErrorMessage(title:"Login Failed", message: "Invalid username or password.")
            }else {
                self.showErrorMessage(title:"Login Failed", message: error?.localizedDescription ?? "")
            }
            
        }
    }
    
    //activity indicator setter
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        username.isEnabled = !loggingIn
        password.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
    }
}

