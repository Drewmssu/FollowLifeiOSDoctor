//
//  ProfileViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import FollowLifeFramework

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editCmdButton: UIButton!
    @IBOutlet weak var cmpTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    // @IBOutlet weak var specialtyPicker: UIPickerView!
    @IBOutlet weak var editSpecialtyButton: UIButton!
    
    @IBOutlet weak var editAddressButton: UIButton!
    @IBOutlet weak var specialtyTextField: UITextField!
    
    let fullName: String = Preference.retreiveData(key: "fullName")
    let phoneNumber: String = Preference.retreiveData(key: "phoneNumber")
    let email: String = Preference.retreiveData(key: "email")
    let token: String = Preference.retreiveData(key: "token")
    let idDoctor: String = Preference.retreiveData(key: "idDoctor")
    
    var specialtiesList: [String] = [String]()
    var specialtiesIndexList: [Int] = [Int]()
    var update: Int = Int()
    var specialtyPicker : UIPickerView!
    var selectedSpecialty: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cmpTextField.isUserInteractionEnabled = false
        specialtyTextField.isUserInteractionEnabled = false
        
        fullNameLabel!.text = fullName
        phoneNumberLabel!.text = phoneNumber
        emailLabel!.text = email
        NotificationCenter.default.addObserver(self, selector: #selector(setAddress), name: Notification.Name(rawValue: "changeAddress"), object: nil)
        
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(idDoctor)", method: .get, headers: ["X-FLLWLF-TOKEN": token, "Accept": "application/json"])
            .responseJSON { (response) in
                
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let value):
                    
                    let jsonObject: JSON = JSON(value)
                    
                    if statusCode == 200 {
                        print(jsonObject)
                        if jsonObject["Result"]["medicIdentification"].stringValue as String == "null" {
                            let problemAlert = UIAlertController(title: "No CMP code registered", message: "Register your CMD code to gain full access to the app.", preferredStyle: UIAlertControllerStyle.alert)
                            problemAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(problemAlert, animated: true, completion: nil)
                        } else {
                            self.editCmdButton.isEnabled = false
                            self.cmpTextField.text = jsonObject["Result"]["medicIdentification"].stringValue
                        }
                        
                        if (jsonObject["Result"]["medicalSpeciality"].isEmpty) {
                        } else {
                            self.editSpecialtyButton.isEnabled = false
                            self.specialtyTextField.text = jsonObject["Result"]["medicalSpeciality"][0]["Name"].stringValue
                            
                        }
                        if jsonObject["Result"]["address"].stringValue as String != "null" {
                            
                            self.editAddressButton.isEnabled = false
                            self.addressLabel.text = jsonObject["Result"]["address"]["Street"].stringValue + " " + jsonObject["Result"]["address"]["Number"].stringValue + ". " + jsonObject["Result"]["address"]["complement"].stringValue + ". " + jsonObject["Result"]["address"]["Neighborhood"].stringValue + ", " + jsonObject["Result"]["address"]["District"].stringValue
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
    
    @IBAction func editCmpAction(_ sender: UIButton) {
        
        
        
        let alert = UIAlertController(title: "Editing",
                                      message: "Submit your CMD code.",
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0]
            let cmpCode = textField.text!
            
            let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to submit this CMD code: \(cmpCode)? It can't be changed later.", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                
                
                let parameters = [
                    "MedicalIdentification": cmpCode
                ]
                
                
                Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.idDoctor)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Content-Type": "application/json"]).responseJSON { (response) in
                    
                    let statusCode = response.response?.statusCode
                    
                    switch response.result {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        
                    case .success(let value):
                        
                        let jsonObject: JSON = JSON(value)
                        
                        if statusCode == 200 {
                            
                            self.cmpTextField.text = cmpCode
                            self.editCmdButton.isEnabled = false
                            
                            
                        }
                        else {
                            self.showErrorMessage()
                        }
                        
                    }
                }
                
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
        specialtyTextField.isUserInteractionEnabled = true
        
        createSpecialityPicker(specialtyTextField)
        loadSpecialties()
        self.specialtyTextField.becomeFirstResponder()
    }
    
    @objc func doneClick() {
        
        specialtyTextField.resignFirstResponder()
        let name = specialtyTextField.text!
        let specialty = [
            "Code": selectedSpecialty,
            "Text": name
            ] as [String : Any]
        let parameters = [
            "MedicalSpecialities": specialty
        ]
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.idDoctor)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Content-Type": "application/json"]).responseJSON { (response) in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                
                let jsonObject: JSON = JSON(value)
                print(jsonObject)
                if statusCode == 200 {
                    
                    self.editSpecialtyButton.isEnabled = false
                    self.specialtyTextField.isUserInteractionEnabled = false
                    
                }
                else {
                    print(jsonObject)
                    self.showErrorMessage()
                }
                
            }
        }
        
    }
    
    @objc func cancelClick() {
        specialtyTextField.resignFirstResponder()
    }
    
    func showErrorMessage() {
        let problemAlert = UIAlertController(title: "We had a problem", message: "We had some technical problems. Please, try again in a few minutes.", preferredStyle: UIAlertControllerStyle.alert)
        problemAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(problemAlert, animated: true, completion: nil)
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
                                if let code = specialty["Code"].int {
                                    self.specialtiesIndexList.append(code)
                                }
                            }
                        }
                        self.specialtyPicker.reloadAllComponents()
                    }
                }
        }
    }
    
    @objc func setAddress() {
        addressLabel.text = Preference.retreiveData(key: "address")
        self.editAddressButton.isUserInteractionEnabled = false
    }
    
    func createSpecialityPicker(_ textField : UITextField) {
        
        self.specialtyPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.specialtyPicker.delegate = self
        self.specialtyPicker.dataSource = self
        self.specialtyPicker.backgroundColor = UIColor.white
        textField.inputView = self.specialtyPicker
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ProfileViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ProfileViewController.cancelClick))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        
        
        //self.specialtyPicker.addSubview(toolbar)
        
        
    }
    
    
    func logOut(){
        
        
        Alamofire.request("\(FollowLifeApi.patientsUrl)/logout", method: .get, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Accept": "application/json"]).responseJSON { (response) in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                
                let jsonObject: JSON = JSON(value)
                print(statusCode)
                if statusCode == 200 {
                    
                    
                }
                else {
                    
                    self.showErrorMessage()
                }
                
            }
        }
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
        selectedSpecialty = specialtiesIndexList[row]
        return specialtiesList[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.specialtyTextField.text = specialtiesList[row]
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
