//
//  ManagerManagement.swift
//  Demo
//
//  Created by iMac on 30/04/20.
//  Copyright © 2020 iMac. All rights reserved.
//

import Foundation

@objc protocol ManagerManagementDelegate:NSObjectProtocol{
    func ManagerManagementSuccess(_ response: Any?, forTag tagname: String?)
    func ManagerManagementFailure(_ error: Error?, forTag tagname: String?)
}

class ManagerManagement: NSObject {

    var delegate:ManagerManagementDelegate?
    
    //MARK:- GET Service API Calling
    func GetAllManager(webpath: String?, withTag tagname: String?) {
                
        //SUCCESS
        if (self.delegate?.responds(to: #selector(self.delegate?.ManagerManagementSuccess(_:forTag:))))! {
            self.delegate?.ManagerManagementSuccess(nil, forTag: tagname)
        }
        
        //FAILURE
        if (self.delegate?.responds(to: #selector(self.delegate?.ManagerManagementFailure(_:forTag:))))! {
            self.delegate?.ManagerManagementFailure(nil, forTag: tagname)
        }
        
    }
    
}
