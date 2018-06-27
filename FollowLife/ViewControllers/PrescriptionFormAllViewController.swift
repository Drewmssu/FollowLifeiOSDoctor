//
//  prescriptionFormAllViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import FollowLifeFramework
import SwiftyJSON

class PrescriptionFormAllViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    let patientId: String = Preference.retreiveData(key: "idPatient")
    let idDoctor: String = Preference.retreiveData(key: "idDoctor")
    let token: String = Preference.retreiveData(key: "token")
    let prescriptionType: Int = Preference.retreiveData(key: "prescriptionType")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToolbar(textView : descriptionTextView)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        savePrescription(idPatient: self.patientId)
    }
    
    func getCurrenttime() -> String {
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        
        return dateString
    }
    
    func addToolbar(textView : UITextView){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textView.inputAccessoryView = toolbar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func savePrescription(idPatient: String){
        
        let description = descriptionTextView.text
        
        let parameters = [
            "Frecuency": "",
            "Quantity": "",
            "DurationInDays": "",
            "Description": description,
            "StartedAt": getCurrenttime(),
            "PrescriptionTypeId": Int(prescriptionType)
            ] as [String : Any]
        
        
        Alamofire.request("\(FollowLifeApi.doctorsUrl)/\(self.idDoctor)/patients/\(idPatient)/prescriptions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["X-FLLWLF-TOKEN": self.token, "Content-Type": "application/json"]).responseJSON { (response) in
            
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                
            case .success(let value):
                
                let jsonObject: JSON = JSON(value)
                
                if statusCode == 200 {
                    print("save pres \(jsonObject)")
                    self.performSegue(withIdentifier: "showPrescriptionType", sender: nil)
                    //self.dismiss(animated: true, completion: nil)
                    //                    self.editSpecialtyButton.isEnabled = false
                    //                    self.specialtyTextField.isUserInteractionEnabled = false
                    
                }
                else {
                    
                    self.showErrorMessage()
                }
                
            }
        }
    }
    
    
    
    @objc func doneClicked() {
        
        if(descriptionTextView.isFirstResponder ==  true) {
            
            let name = descriptionTextView.text
            if name == "" {
                completeFieldsMessage()
            }
            descriptionTextView.resignFirstResponder()
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
        
        if(descriptionTextView.isFirstResponder ==  true) {
            descriptionTextView.text = ""
            descriptionTextView.resignFirstResponder()
        }
    }


}
