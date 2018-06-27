//
//  RegisterViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FollowLifeFramework

class RegisterViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.setBottomBorder()
        lastNameTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        signUpButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "We had a problem", message: "You must fill in all the fields", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
        }
        
        let headers = ["Accept": "application/json"]
        let parameters = ["FirstName": firstName, "LastName": lastName, "Email": email, "Password": password]
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/register", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let value):
                    let jsonObject: JSON = JSON(value)
                    if statusCode == 200 {
                        self.performSegue(withIdentifier: "showFirstPlanScene", sender: self)
                    } else {
                        let problemAlert = UIAlertController(title: "We had a problem", message: jsonObject["Message"].stringValue, preferredStyle: UIAlertControllerStyle.alert)
                        problemAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(problemAlert, animated: true, completion: nil)
                    }
                }
        }
    }
    
    @IBAction func alreadyHaveAnAccountAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
