//
//  AppointmentTableViewCell.swift
//  FollowLife
//
//  Created by Jesus Cueto on 23/06/18.
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    var viewModel = AppointmentViewModel()
    @IBOutlet var patienNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupViews(appointment: AppointmentCellModel) {
        self.dateLabel.text = appointment.appointmentDate
        self.patienNameLabel.text = appointment.patientName
    }
    @IBAction func deleteAppoitnment(_ sender: UIButton) {
        //viewModel.deleteAppointment(doctorId: <#T##Int#>, appointmentId: <#T##Int#>, token: <#T##String#>, success: <#T##(String) -> Void#>, failure: <#T##(String) -> Void#>)
    }
}
