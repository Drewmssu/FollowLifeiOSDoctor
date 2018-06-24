//
//  LoginViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FollowLifeFramework

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signInAction(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty,
        let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "We had a problem", message: "You must fill in all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        let headers = ["Accept": "application/json"]
        let parameters = ["Email" : email, "Password": password, "DeviceToken": "String"]
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/login", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                let jsonObject: JSON = JSON(value)
                if statusCode == 200 {
                    //Preference.saveData(key: "token", value: jsonObject["SessionToken"].stringValue)
                    //Preference.saveData(key: "userId", value: "\(jsonObject["Id"])")
                    print("\(jsonObject)")
                    let user = UserModel(id: jsonObject["Result"]["Id"].intValue, name: jsonObject["Result"]["FirstName"].stringValue, token: jsonObject["Result"]["SessionToken"].stringValue)
                    let userDefaults = UserDefaults.standard
                    let encodeData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
                    userDefaults.set(encodeData, forKey: "user")
                    userDefaults.synchronize()
                    
                    self.performSegue(withIdentifier: "showHome", sender: self)
                } else if statusCode == 401 ||  statusCode == 404 {
                    let alert = UIAlertController(title: "Incorrect Credentials", message: "Please, try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                } else {
                    let alert = UIAlertController(title: "We had a problem", message: "We had some technical probles. Please, try again in a few minutes.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                }
            }
        }.responseString { (response) in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                if statusCode == 401 ||  statusCode == 404 {
                    let alert = UIAlertController(title: "Incorrect Credentials", message: "\(value). Please, try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                } else {
                    let alert = UIAlertController(title: "We had a problem", message: "We had some technical probles. Please, try again in a few minutes.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        signInButton.layer.cornerRadius = 5
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        signUpLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Register") as! RegisterViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
