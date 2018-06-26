//
//  CalendarTableViewController.swift
//  FollowLife
//
//  Copyright © 2018 Hillari Zorrilla Delgado. All rights reserved.
//

import UIKit
import FollowLifeFramework
class CalendarTableViewController: UITableViewController {

    @IBOutlet var appointmentTableView: UITableView!
    var viewModel = AppointmentViewModel()
    var appoitmentList: [AppointmentCellModel] = []
    var user: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let userDefaults = UserDefaults.standard
        let decoded = userDefaults.object(forKey: "user") as! Data
        user = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserModel
        
        self.appointmentTableView.delegate = self
        self.appointmentTableView.dataSource = self
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        return tableView.dequeueReusableCell(withIdentifier: "header")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }*/
    
    private func loadData() {
        self.viewModel.getAppointments(id: user.userId, token: user.token, success: { (data) in
            self.appoitmentList = data
            self.appointmentTableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    
    @IBAction func addAppointment(_ sender: UIBarButtonItem) {
        
        let addVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditAppointment") as! AddAppointmentViewController
        addVC.delegate = self
        self.present(addVC, animated: true, completion: nil)
    }
}

//MARK: - Datasource
extension CalendarTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appoitmentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AppointmentTableViewCell
        cell.delegate = self
        cell.setupViews(appointment: appoitmentList[indexPath.row], user: user)
        return cell
    }
}

//MARK: TableView Delegate
extension CalendarTableViewController {
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let appointmentDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "appointmentDetails") as! AppointmentDetailsTableViewController
        appointmentDetailVC.delegate = self
        /*appointmentDetailVC.dateLabel.text = self.appoitmentList[indexPath.row].appointmentDate
        appointmentDetailVC.nameLabel.text = self.appoitmentList[indexPath.row].patientName
        appointmentDetailVC.reasonLabel.text = self.appoitmentList[indexPath.row].reason*/
        self.present(appointmentDetailVC, animated: true, completion: nil)
     }
}

extension CalendarTableViewController: AddAppointmentDelegate {
    func reloadData() {
        self.loadData()
    }
}

extension CalendarTableViewController: CancelAppointmentDelegate {
    func deleteAppointment() {
        self.loadData()
    }
}
