//
//  prescriptionFormMedViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import FollowLifeFramework
import SwiftyJSON

class PrescriptionFormMedViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityDosisTextField: UITextField!
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var calendarTextField: UITextField!
    
    let patientId: String = Preference.retreiveData(key: "idPatient")
    let idDoctor: String = Preference.retreiveData(key: "idDoctor")
    let token: String = Preference.retreiveData(key: "token")
    
    /*var quantityDosisList: [String] = ["1 pill","2 pills","3 pills","4 pills"]
    var quantityDosisIntList: [Int] = [1,2,3,4]
    */
    var quantityDosis = [
        "1 pill": 1,
        "2 pills": 2,
        "3 pills": 3,
        "4 pills": 4
    ]
    var dosageList: [String] = [
        "Every 2 hours",
        "Every 4 hours",
        "Every 6 hours",
        "Every 8 hours (three times a day)",
        "Every 10 hours",
        "Every 12 hours (twice a day)",
        "Every 24 hours (Once a day)"
    ]
    var calendar = [
        "One day": 1,
        "Two days": 2,
        "Three days": 3,
        "One Week": 7,
        "One Month": 30,
        "Two Months": 60
    ]
    var quantityDosisPicker : UIPickerView = UIPickerView()
    var dosagePicker : UIPickerView =  UIPickerView()
    var calendarPicker : UIPickerView =  UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quantityDosisPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.dosagePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
         self.dosagePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.calendarPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        addToolbar(textField: self.nameTextField)
        createPicker(textField: self.quantityDosisTextField, picker: self.quantityDosisPicker)
        createPicker(textField: self.dosageTextField, picker: self.dosagePicker)
        createPicker(textField: self.calendarTextField, picker: self.calendarPicker)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let parameters = [
            "Frecuency": self.dosageTextField.text!,
            "Quantity": self.quantityDosis[self.quantityDosisTextField.text!]!,
            "DurationInDays": self.calendar[self.calendarTextField.text!]!,
            "Description": nameTextField.text!,
            "StartedAt": getCurrenttime(),
            "PrescriptionTypeId": 1
            ] as [String : Any]
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.idDoctor)/patients/\(self.patientId)/prescriptions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Accept": "application/json"]).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success( _):
                if statusCode == 200 {
                    for controller in self.navigationController!.viewControllers {
                        if controller.isKind(of: PrescriptionListTableViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    //                    self.editSpecialtyButton.isEnabled = false
                    //                    self.specialtyTextField.isUserInteractionEnabled = false
                }
                else {
                    self.showErrorMessage()
                }
                
            }
        }
    }
    
    func createPicker(textField : UITextField,picker : UIPickerView) {
        
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        textField.inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        //        toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        
        //self.specialtyPicker.addSubview(toolbar)
    }
    
    func addToolbar(textField : UITextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
    }
    
    func getCurrenttime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        
        return dateString
    }
    
    @objc func doneClicked() {
        if(nameTextField.isFirstResponder ==  true) {
            let name = nameTextField.text
            if name == "" {
                completeFieldsMessage()
            }
            nameTextField.resignFirstResponder()
        } else if(dosageTextField.isFirstResponder ==  true) {

            let dosage = dosageTextField.text
            if dosage == "" {
                completeFieldsMessage()
            }
            dosageTextField.resignFirstResponder()
        } else if(quantityDosisTextField.isFirstResponder ==  true) {
            let quantityDosis = quantityDosisTextField.text
            if quantityDosis == "" {
                completeFieldsMessage()
            }
            quantityDosisTextField.resignFirstResponder()
        } else if(calendarTextField.isFirstResponder ==  true) {
            let calendar = calendarTextField.text
            if calendar == "" {
                completeFieldsMessage()
            }
            calendarTextField.resignFirstResponder()
        }
    }
    
    func completeFieldsMessage(){
        let alert = UIAlertController(title: "We had a problem", message: "You must fill in all the fields.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showErrorMessage() {
        let problemAlert = UIAlertController(title: "We had a problem", message: "We had some technical problems. Please, try again in a few minutes.", preferredStyle: UIAlertControllerStyle.alert)
        problemAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(problemAlert, animated: true, completion: nil)
    }
    

    @objc func cancelClicked() {
        if(nameTextField.isFirstResponder ==  true) {
            nameTextField.text = ""
            nameTextField.resignFirstResponder()
        } else if(dosageTextField.isFirstResponder ==  true) {
            dosageTextField.text = ""
            dosageTextField.resignFirstResponder()
        } else if(quantityDosisTextField.isFirstResponder ==  true) {
            quantityDosisTextField.text = ""
            quantityDosisTextField.resignFirstResponder()
        }else if(calendarTextField.isFirstResponder ==  true) {
            calendarTextField.text = ""
            calendarTextField.resignFirstResponder()
        }
    }
}

extension PrescriptionFormMedViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == quantityDosisPicker {
            return Array(self.quantityDosis)[row].key
        } else if pickerView == dosagePicker {
            return dosageList[row]
        } else if pickerView == calendarPicker {
            return Array(self.calendar)[row].key
        } else {
            return "-1"
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == quantityDosisPicker {
            self.quantityDosisTextField.text = Array(self.quantityDosis)[row].key
        } else if pickerView == dosagePicker {
            self.dosageTextField.text = dosageList[row]
        } else if pickerView == calendarPicker {
            self.calendarTextField.text = Array(self.calendar)[row].key
        }
    }
}

extension PrescriptionFormMedViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == quantityDosisPicker {
            return quantityDosis.count
        } else if pickerView == dosagePicker {
            return dosageList.count
        } else if pickerView == calendarPicker {
            return calendar.count
        }
        return -1
    }
    
}
