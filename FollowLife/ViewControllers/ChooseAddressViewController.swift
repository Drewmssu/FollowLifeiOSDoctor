//
//  ChooseAddressViewController.swift
//  FollowLife
//
//  Created by Hillari Zorrilla Delgado on 6/18/18.
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import FollowLifeFramework

class ChooseAddressViewController: UIViewController {
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBOutlet weak var neighborhoodTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    
    @IBOutlet weak var complementTextField: UITextField!
    let token: String = Preference.retreiveData(key: "token")
    let idDoctor: String = Preference.retreiveData(key: "idDoctor")
    
    var districtList: [String] = [String]()
    var districtIndexList: [Int] = [Int]()
    var districtPicker : UIPickerView!
    var selectedDistrict: Int = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        streetTextField.setBottomBorder()
        numberTextField.setBottomBorder()
        neighborhoodTextField.setBottomBorder()
        districtTextField.setBottomBorder()
        complementTextField.setBottomBorder()
        createDistrictPicker(districtTextField)
        loadDistricts()
        
        // Do any additional setup after loading the view.
    }
    
    func loadDistricts(){
        
        Alamofire.request("\(FollowLifeApi.repositoriesUrl)/districts", method: .get, headers: ["X-FLLWLF-TOKEN": token, "Accept": "application/json"])
            .responseJSON { (response) in
                
                let statusCode = response.response?.statusCode
                
                switch response.result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                case .success(let value):
                    
                    let jsonObject: JSON = JSON(value)
                    
                    if statusCode == 200 {
                        if let districts = jsonObject["Result"].array {
                            for district in districts {
                                if let name = district["Text"].string {
                                    self.districtList.append(name)
                                }
                                if let code = district["Code"].int {
                                    self.districtIndexList.append(code)
                                }
                            }
                        }
                        self.districtPicker.reloadAllComponents()
                        
                    }
                }
        }
    }
    
    
    func createDistrictPicker(_ textField : UITextField) {
        
        self.districtPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.districtPicker.delegate = self
        self.districtPicker.dataSource = self
        self.districtPicker.backgroundColor = UIColor.white
        textField.inputView = self.districtPicker
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ChooseAddressViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ChooseAddressViewController.cancelClick))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        
        
        //self.specialtyPicker.addSubview(toolbar)
        
        
    }

    
    @objc func doneClick() {
        
        districtTextField.resignFirstResponder()
        
    }
    
    @objc func cancelClick() {
        districtTextField.resignFirstResponder()
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        // let selectedRow = self.districtPicker.selectedRow(inComponent: 0)
        //print(selectedRow)
        
       // let desiredValue = Int(districtIndexList[selectedRow])
        //print(desiredValue)
        let district = districtTextField.text!
        let number = numberTextField.text!
        let neighborhood = neighborhoodTextField.text!
        let complement = complementTextField.text!
        let street = streetTextField.text!
        
        let parameters = [
            "Number": number,
            "Complement": complement,
            "Neighborhood": neighborhood,
            "Street": street,
            "District": selectedDistrict
            ] as [String : Any]
        
        let address = "\(street) \(number). \(neighborhood), \(district). \(complement)."
        
        print("address: " + address)
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.idDoctor)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Content-Type": "application/json"]).responseJSON { (response) in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                
                let jsonObject: JSON = JSON(value)
          
                if statusCode == 200 {
                    
                    Preference.saveData(key: "address", value: address)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "changeAddress"), object: nil)

                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    print(jsonObject)
                    let problemAlert = UIAlertController(title: "We had a problem", message: "We had some technical problems. Please, try again in a few minutes.", preferredStyle: UIAlertControllerStyle.alert)
                    problemAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                }
                
            }
        }
        
     //self.navigationController?.popViewController(animated: true)
        
    }
   
    
}

extension ChooseAddressViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedDistrict = districtIndexList[row]
        return districtList[row]
        
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.districtTextField.text = districtList[row]
    }
}

extension ChooseAddressViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return districtList.count
    }
    
    
}
