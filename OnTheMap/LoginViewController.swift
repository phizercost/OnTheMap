//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Phizer Cost on 8/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTextFields(emailTextField)
        resetTextFields(passwordTextField)
        
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        initializeTextField(textField, "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resetTextFields(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetTextFields(textField)
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func raiseAlert(title:String, notification:String) {
        let alert  = UIAlertController(title: title, message: notification, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func initializeTextField(_ textField: UITextField, _ withText: String) {
        textField.delegate = self
        textField.textAlignment = .left
        textField.text = withText
        
        if textField.tag == 1 {
            textField.isSecureTextEntry = true
        }
    }
    
    func resetTextFields(_ textField: UITextField){
        if textField.text?.count == 0 {
            switch textField.tag {
            case 0:
                initializeTextField(textField, "Email")
            case 1:
                initializeTextField(textField, "Password")
                textField.isSecureTextEntry = false
            default:
                break
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let url = URL(string: Constants.Udacity.signUpUrl) else {
            return
        }
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        Global.shared().loginFunction(email: emailTextField.text! , password: passwordTextField.text!) { (result, error) in
            if result {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "showMap", sender: self.loginBtn)
            } else {
                DispatchQueue.main.async {
                    self.raiseAlert(title: "ERROR", notification: error!)
                }
            }
        }
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
