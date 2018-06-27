//
//  AddAppointmentViewController.swift
//  FollowLife
//
//  Created by Jesus Cueto on 23/06/18.
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import FollowLifeFramework

protocol AddAppointmentDelegate {
    func reloadData()
}

class AddAppointmentViewController: UIViewController {
    
    let viewModel = AppointmentViewModel()
    var delegate: AddAppointmentDelegate?
    var appointmentId: Int?
    var user: UserModel!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var reasonTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        reasonTextField.layer.borderWidth = 1.0
        reasonTextField.layer.cornerRadius = 4.0
        reasonTextField.layer.borderColor = UIColor.cyan.cgColor
        let userDefaults = UserDefaults.standard
        let decoded = userDefaults.object(forKey: "user") as! Data
        user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        let params: [String : Any] = ["PatientId" : 7, "DoctorId" : user.userId, "AppointmentDate" : "2018-06-30T15:19:16.434Z", "Reason" : reasonTextField.text!, "AppointmentId" : appointmentId!, "Action" : 1, ]
        
        viewModel.addAppointment(params: params, method: .post, token: user.token, success: { (message) in
            print(message)
            self.delegate?.reloadData()
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print(error)
        }
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
