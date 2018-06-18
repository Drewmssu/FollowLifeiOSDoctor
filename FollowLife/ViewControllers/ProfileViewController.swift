//
//  ProfileViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FollowLifeFramework

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editCmdButton: UIButton!
    @IBOutlet weak var cmpLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var specialtyPicker: UIPickerView!
    @IBOutlet weak var editSpecialtyButton: UIButton!
    
    let fullName: String = Preference.retreiveData(key: "fullName")
    let phoneNumber: String = Preference.retreiveData(key: "phoneNumber")
    let email: String = Preference.retreiveData(key: "email")
    let token: String = Preference.retreiveData(key: "token")
    let idDoctor: String = Preference.retreiveData(key: "idDoctor")
    
    var specialtiesList: [String] = [String]()
    var cancelButton:UIBarButtonItem = UIBarButtonItem()
    var spaceButton:UIBarButtonItem = UIBarButtonItem()
    var doneButton:UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.specialtyPicker.delegate = self
        self.specialtyPicker.dataSource = self
        self.specialtyPicker.isHidden = true
        doneButton = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileViewController.doneClicked))
        spaceButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        cancelButton = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileViewController.cancelClicked))
        createSpecialityPicker()
        loadSpecialties()
        
        fullNameLabel!.text = fullName
        phoneNumberLabel!.text = phoneNumber
        emailLabel!.text = email
        
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(idDoctor)", method: .get, headers: ["X-FLLWLF-TOKEN": token, "Accept": "application/json"])
            .responseJSON { (response) in

            let statusCode = response.response?.statusCode
           
            switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")

                case .success(let value):
                  
                    let jsonObject: JSON = JSON(value)

                    if statusCode == 200 {
                        if jsonObject["Result"]["medicIdentification"].stringValue == "null" {
                            let problemAlert = UIAlertController(title: "No CMP code registered", message: "Register your CMD code to gain full access to the app.", preferredStyle: UIAlertControllerStyle.alert)
                            problemAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(problemAlert, animated: true, completion: nil)
                        } else {
                            self.editCmdButton.isEnabled = false
                            self.cmpLabel.text = jsonObject["Result"]["medicIdentification"].stringValue
                        }
                        
                        
                        
                        
                        
                    }
            }
        }
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func loadSpecialties(){
        
        Alamofire.request("\(FollowLifeApi.repositoriesUrl)/medicalSpecialities", method: .get, headers: ["X-FLLWLF-TOKEN": token, "Accept": "application/json"])
            .responseJSON { (response) in
                
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let value):
                    
                    let jsonObject: JSON = JSON(value)
                    
                    if statusCode == 200 {
                        if let specialties = jsonObject["Result"].array {
                            for specialty in specialties {
                                if let name = specialty["Text"].string {
                                    self.specialtiesList.append(name)
                                }
                            }
                        }
                        self.specialtyPicker.reloadAllComponents()
                    }
                }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        presentImagePickerController(forSourceType: .photoLibrary)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func presentImagePickerController(forSourceType sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = sourceType
            self.present(pickerController, animated: true, completion: nil)
        } else {
            print("Source Type Not Available")
        }
    }
    
    func createSpecialityPicker() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        doneButton.tintColor = UIColor.blue
        cancelButton.tintColor = UIColor.blue
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        self.specialtyPicker.addSubview(toolbar)
        
        
    }
    
    
    
    @objc func cancelClicked() {
        print("it works")
        self.specialtyPicker.isHidden = true
    }
    
    @objc func doneClicked() {
        print("it works done")
        
    }

    func updateDoctorInformation(param: JSON) {
       /* Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(idDoctor)", method: .put, parameters: param, encoding: URLEncoding.default, headers: ["X-FLLWLF-TOKEN": token, "Accept": "application/json"]).responseJSON { (response) in
                
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let value):
                    
                    let jsonObject: JSON = JSON(value)
                    
                    if statusCode == 200 {
                        print(jsonObject)
                    }
                    
                }
        }*/
    }
    
    @IBAction func editCmpAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Editing",
                                      message: "Submit your CMD code.",
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0]
            let cmpCode = textField.text!
        
            let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to submit this CMD code: \(cmpCode)? It can't be changed later.", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                self.cmpLabel.text = cmpCode
                self.editCmdButton.isEnabled = false
                //TODO: updateDoctorInformation
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
            confirmationAlert.addAction(submitAction)
            confirmationAlert.addAction(cancel)
            self.present(confirmationAlert, animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField {
            (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .default
                textField.autocorrectionType = .default
                textField.clearButtonMode = .whileEditing
        }
        alert.addAction(submitAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editSpecialityAction(_ sender: UIButton) {
        if self.specialtyPicker.isHidden {
            self.specialtyPicker.isHidden = false
        }
    }
    
    @IBAction func editAdressAction(_ sender: UIButton) {
    }
    

    
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Action cancelled")
        self.profileImageView.image = UIImage(named: "no-photo")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageView.image = pickedImage
                        picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
}
extension ProfileViewController: UINavigationControllerDelegate {
    

    
}

extension ProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return specialtiesList[row]
    }
}

extension ProfileViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return specialtiesList.count
    }

}





