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
    var appoitnmentId: Int?
    var user: UserModel?
    var delegate: CancelAppointmentDelegate?
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

    func setupViews(appointment: AppointmentCellModel, user: UserModel) {
        self.dateLabel.text = appointment.appointmentDate
        self.patienNameLabel.text = appointment.patientName
        self.appoitnmentId = appointment.id
        self.user = user
    }
    @IBAction func deleteAppoitnment(_ sender: UIButton) {
        viewModel.deleteAppointment(doctorId: (user?.userId)!, appointmentId: appoitnmentId!, token: (user?.token)!, success: { (message) in
            print("Appointment deleted")
            self.delegate?.deleteAppointment()
        }) { (error) in
            print(error)
        }
    }
}
