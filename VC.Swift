//
//  ViewController.swift
//  Demo
//
//  Created by iMac on 30/04/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ManagerManagementDelegate {
    

    var managerMgt = ManagerManagement()
    var GetManager = "GETALLMANAGER"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        managerMgt.delegate = self
    }

    func parseGetAllManager(response : Any?) {
        let arrMgr = response as! NSArray
    }
    
}

extension ViewController{
    func ManagerManagementSuccess(_ response: Any?, forTag tagname: String?) {
        if(response != nil){
            if(tagname == self.GetManager){
                self.parseGetAllManager(response: response)
            }
        }
    }
    
    func ManagerManagementFailure(_ error: Error?, forTag tagname: String?) {
        <#code#>
    }
    
    
}
