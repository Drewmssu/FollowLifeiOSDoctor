//
//  PrescriptionTypeViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import Alamofire
import FollowLifeFramework
import SwiftyJSON


class ChoosePrescriptionTypeViewController: UIViewController {

    @IBOutlet weak var chooseMedicineButton: UIButton!
    @IBOutlet weak var chooseExerciseButton: UIButton!
    @IBOutlet weak var chooseFoodButton: UIButton!
    @IBOutlet weak var chooseOtherTreatment: UIButton!
    
    
    var regPrescription:PrescriptionFormAllViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseMedicineButton.layer.cornerRadius = 5
        chooseMedicineButton.layer.borderWidth = 1
        chooseMedicineButton.layer.borderColor = UIColor.lightGray.cgColor
        
        chooseExerciseButton.layer.cornerRadius = 5
        chooseExerciseButton.layer.borderWidth = 1
        chooseExerciseButton.layer.borderColor = UIColor.lightGray.cgColor
        
        chooseFoodButton.layer.cornerRadius = 5
            chooseFoodButton.layer.borderWidth = 1
            chooseFoodButton.layer.borderColor = UIColor.lightGray.cgColor
        
        chooseOtherTreatment.layer.cornerRadius = 5
        chooseOtherTreatment.layer.borderWidth = 1
        chooseOtherTreatment.layer.borderColor = UIColor.lightGray.cgColor
  
    }
    
    @IBAction func chooseExercisePrescription(_ sender: UIButton) {
        
        Preference.saveData(key: "prescriptionType", value: "2")
    }
    
    @IBAction func chooseFoodPrescription(_ sender: UIButton) {
         Preference.saveData(key: "prescriptionType", value: "3")
    }
    
    @IBAction func chooseOtherPrescription(_ sender: UIButton) {
         Preference.saveData(key: "prescriptionType", value: "4")
    }
    
    

}
