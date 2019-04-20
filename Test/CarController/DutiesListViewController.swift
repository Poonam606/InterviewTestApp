//
//  DutiesListViewController.swift
//  Test
//
//  Created by IMMANENT on 20/04/19.
//  Copyright © 2019 poonam. All rights reserved.
//

import UIKit
import BCryptSwift
class DutiesListViewController: UIViewController {
    @IBOutlet var tableCarListIDs: UITableView!
     var carIDArary = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
       getAllDuties()
        // Do any additional setup after loading the view.
    }
    //MARK: Get All Duties
    func getAllDuties()
    {
        ProjectManager.sharedInstance.showActivityIndicator()
        let urlString  =  BaseUrl + "dutyid/list"
        let  stringToBeHashed = privateString + ",/api/v1/app/dutyid/list"
        let checksumValue =    BCryptSwift.hashPassword(stringToBeHashed, withSalt: BCryptSwift.generateSalt())
        ProjectManager.sharedInstance.callApiWithParameterstoGetCarID(urlStr: urlString, checksum:checksumValue!  , completion: { (responseDict, error) in

            if error == nil {
                ProjectManager.sharedInstance.hideActivityIndicator()
                guard let status = responseDict  else{
                    return
                }
                   print("array",status)
                self.carIDArary = ProjectManager.sharedInstance.getlistOfcarID(array :status)
                self.tableCarListIDs.reloadData()
            }
            
        })
    }

}
extension DutiesListViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.carIDArary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let IdCell = tableCarListIDs.dequeueReusableCell(withIdentifier: "CarID", for: indexPath) as! CarIDTableViewCell
        IdCell.selectionStyle = .none
        IdCell.labelCarID.text = "Id :" + String(self.carIDArary[indexPath.row])
        return IdCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let duties = self.storyboard?.instantiateViewController(withIdentifier: "DutiesViewController") as! DutiesViewController
        duties.SelectedCarID = self.carIDArary[indexPath.row]
        self.navigationController?.pushViewController(duties, animated: true)
    }
    
}
