//
//  ProjectManager.swift
//  Test
//
//  Created by IMMANENT on 20/04/19.
//  Copyright © 2019 poonam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class ProjectManager: NSObject {
     static let sharedInstance = ProjectManager()
    func callApiWithParameterstoGetCarID(urlStr:String , checksum: String , completion:@escaping(NSArray? , Error?)->Void)  {
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
      
      
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(checksum, forHTTPHeaderField: "checksum")
        
       // urlRequest.httpBody = paramStr.data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                  
                    
                }
                return
            }
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                print("responseData",responseData)
                
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? NSArray else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                print(receivedTodo)
                DispatchQueue.main.async {
                    completion(receivedTodo  as! NSArray , nil)
                }
                
                
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
        
        
    }
    //MARK: Call API to get Statud of Duties
    func callApiWithParametersgetStatudOfDuties(urlStr:String , checksum: String , completion:@escaping(NSDictionary? , Error?)->Void)  {
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(checksum, forHTTPHeaderField: "checksum")
        
        // urlRequest.httpBody = paramStr.data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    
                    
                }
                return
            }
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                print("responseData3",responseData)
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? NSDictionary else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                print(receivedTodo)
                DispatchQueue.main.async {
                 completion(receivedTodo  as! NSDictionary , nil)
                }
                
                
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
        
        
    }
    // MARK:CallAPi to update Duty
 func callApiWithParametersUpdateDuty(urlStr:String , params:[String: Any], checksum: String , completion:@escaping(NSDictionary? , Error?)->Void)  {
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        
    
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        urlRequest.setValue(checksum, forHTTPHeaderField: "checksum")
        var paramStr = String()
        for items in params {
        paramStr = paramStr + "\(items.key)=\(items.value)&"
        }
    
         paramStr = paramStr.substring(to: paramStr.index(before: paramStr.endIndex))
       //  urlRequest.httpBody = paramStr.data(using: .utf8)
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
           urlRequest.httpBody = jsonData
        // urlRequest.httpBody = paramStr.data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    
                    
                }
                return
            }
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            print("response",response)
            // parse the result as JSON, since that's what the API provides
            do {
                print("responseData3",responseData)
                let json = String(data: responseData, encoding: .utf8)
                print("fdgfdg",json!)
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? NSDictionary else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                
                
                print("cvbnvn",receivedTodo)
                DispatchQueue.main.async {
                    completion(receivedTodo  as NSDictionary , nil)
                }
                
                
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
        
        
        
    }
    // MARk: Show activity indicator
    func showActivityIndicator() {
    DispatchQueue.main.async(){
      let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
      }
    }
    //MARK: - Hide Activity Indicator
    func hideActivityIndicator(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0){
             NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
        }
    //Get list of carID
    func getlistOfcarID(array :NSArray) -> [Int] {
        var carIDArray = [Int]()
        for i in array {
            
            carIDArray.append((i as? Int)!)
        }
        return carIDArray
    }
}



