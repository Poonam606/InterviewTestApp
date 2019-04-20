//
//  DutiesViewController.swift
//  Test
//
//  Created by IMMANENT on 20/04/19.
//  Copyright © 2019 poonam. All rights reserved.
//

import UIKit
import BCryptSwift
struct Duty {
    var userAssigned : String?
    var userState : String?
    var userYpe  : String?
    
}
class DutiesViewController: UIViewController {

    @IBOutlet var labelType: UILabel!
    @IBOutlet var labelState: UILabel!
    @IBOutlet var labelAssigned: UILabel!
    @IBOutlet var buttonAction: UIButton!
    var SelectedCarID : Int?
     var action = String()
    override func viewDidLoad() {
        super.viewDidLoad()
       buttonAction.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        ProjectManager.sharedInstance.showActivityIndicator()
         DisplayAssignedDuty()
    }
    //MARk: Update UI
    func updateUI(duty : Duty)
    {
        labelAssigned.text = duty.userAssigned
        labelType.text = duty.userYpe
        labelState.text = duty.userState
        if labelState.text == "IN_PROGRESS"
        {
            buttonAction.isHidden = false
             action = "COMPLETE"
        }
        else if labelState.text == "PLANNED"
        {
          buttonAction.isHidden = false
            action = "IN_PROGRESS"
        }
        else
        {
            buttonAction.isHidden =  true
        }
    }
    //MARK: Get All Duties
    func DisplayAssignedDuty()
    {
        let urlString  =  BaseUrl + "duty/\(SelectedCarID!)"
        let  stringToBeHashed =  privateString + ",/api/v1/app/duty/\(SelectedCarID!)"
        let checksumValue = BCryptSwift.hashPassword(stringToBeHashed, withSalt: BCryptSwift.generateSalt())
        
         ProjectManager.sharedInstance.callApiWithParametersgetStatudOfDuties(urlStr: urlString, checksum:checksumValue!  , completion: { (responseDict, error) in
            
               if error == nil {
                 ProjectManager.sharedInstance.hideActivityIndicator()
                guard let status = responseDict  else{
                    return
                }
                print("array",status)
                let duty = Duty(userAssigned: status["assigned"] as? String, userState: status["state"] as? String, userYpe: status["type"] as? String)
                self.updateUI(duty: duty)
            }
            else
               {
                 ProjectManager.sharedInstance.hideActivityIndicator()
            }
        })
    }
    
    //MARK: Get All Duties
    func UpdaetDuty()
    {
        ProjectManager.sharedInstance.showActivityIndicator()
        var params = [String:Any]()
       
        let urlString  =  BaseUrl + "update/duty/\(SelectedCarID!)"
      
        let timestamp = NSDate().timeIntervalSince1970
        print(Int(timestamp))
        // use some static value for fetching data . after adding dynamic value not able to get response
      let  stringToBeHashed = "\(privateString),\(action),\(labelAssigned.text!),23.333,25.332,\(1496982995000),/api/v1/app/update/duty/\(SelectedCarID!),puneet"
       let checksumValue = BCryptSwift.hashPassword(stringToBeHashed, withSalt: BCryptSwift.generateSalt())
      
        params = ["action": action, "assigned": labelAssigned.text!, "timestamp":"1496982995000", "user": "puneet", "latitude": "23.333", "longitude": "25.332"]
        print("params",params)
        print("params",params)
        ProjectManager.sharedInstance.callApiWithParametersUpdateDuty(urlStr: urlString, params:params ,checksum:checksumValue!  , completion: { (responseDict, error) in
              if error == nil {
                ProjectManager.sharedInstance.hideActivityIndicator()
                 guard let status = responseDict  else{
                    return
                 }
                print("array",status)
                let duty = Duty(userAssigned: status["assigned"] as? String, userState: status["state"] as? String, userYpe: status["type"] as? String)
                self.updateUI(duty: duty)
            }
            else
              {
                ProjectManager.sharedInstance.hideActivityIndicator()
            }
        })
    }
   
    //MARK: Button Action Clicked
    @IBAction func buttonActionClicked(_ sender: Any) {
        if labelState.text == "IN_PROGRESS"
        {
           UpdaetDuty()
        }
        else if labelState.text == "PLANNED"
        {
           UpdaetDuty()
        }
    }
    
}
