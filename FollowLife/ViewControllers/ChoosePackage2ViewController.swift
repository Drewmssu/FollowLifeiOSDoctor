//
//  ChoosePackage2ViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit

class ChoosePackage2ViewController: UIViewController {
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var previousPlanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red:0.30, green:0.69, blue:0.76, alpha:1.0).cgColor, UIColor(red:0.42, green:0.80, blue:0.99, alpha:1.0).cgColor]
        
        self.view.layer.addSublayer(gradient)
        
        optionButton.layer.cornerRadius = 5
        optionButton.layer.borderWidth = 1
        optionButton.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func optionAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showHomeScene", sender: self)
    }
    
    @IBAction func previousPlanAction(_ sender: UIButton) {
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
