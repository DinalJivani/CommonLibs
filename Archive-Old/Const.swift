//
//  Const.swift
//  SwiftProjectStructure
//
//  Created by Dinal Jivani on 14/12/19.
//  Copyright © 2018 Dinal. All rights reserved.
//

import Foundation
import UIKit

//MARK: - CHECK FOR DEVICE
let IS_IPHONE4 = (UIScreen.main.bounds.size.height - 480) != 0.0 ? false : true
let IS_IPAD = UI_USER_INTERFACE_IDIOM() != .phone
let IS_IPHONE5s = UIScreen.main.bounds.size.height <= 568 ? true : false
let IS_IPHONEX = UIScreen.main.bounds.size.height == 812 ? true : false

//MARK: - SCREEN BOUNDS
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//MARK: - GET APPDELEGATE
let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate

//MARK: - API HOST URL
//let cWEBHOST = "http://ec2-13-211-130-148.ap-southeast-2.compute.amazonaws.com/APIs/"
let cWEBHOST = "http://www.vouchapp.com.au/APIs/"

//https://eventit.app

//MARK: - API NAMES
let cSEARCH  = "category_search.php"
let cCATEGORYLIST = "category_list.php"
let cUSERDETAIL = "user_detail.php"
//let cLOCALUSERDETAIL = "user_detail.php"
let cLOCALUSERDETAIL = "place_detail.php"
let cREDEEMCOUPON = "redeem_coupon.php"
let cADDSPINWIN = "add_spin_win.php"

let sCURRENT_LAT          = "CURRENT_LAT"
let sCURRENT_LONG          = "CURRENT_LONG"


//AIzaSyCj7_HH_GJgl2WAsWrjeN7eahFa8PII82A


//AIzaSyB8CYzeZE9AYfWNYOap6_KOidyFdu1ZUuY

//MARK:- Google Palce API key

//OLD
//let keyGoogleMap = "AIzaSyCPH1XAN6ADusOif4ns4eq8t3YpLCu9-L0"

//New
//let keyGoogleMap = "AIzaSyCj7_HH_GJgl2WAsWrjeN7eahFa8PII82A"

//
//let keyGoogleMap = "AIzaSyB8CYzeZE9AYfWNYOap6_KOidyFdu1ZUuY"
let keyGoogleMap = "AIzaSyB8CYzeZE9AYfWNYOap6_KOidyFdu1ZUuY"

//"AIzaSyBmPV13KMALYMdt0ALDObRZJ07K-GcuQ6U"
// old-key : AIzaSyAO5Znw7FbGdsQyHiT7RyCHRoRHM0b_qaM"

let keyPlaceDetails = "AIzaSyCPH1XAN6ADusOif4ns4eq8t3YpLCu9-L0"

//"AIzaSyBmPV13KMALYMdt0ALDObRZJ07K-GcuQ6U"

//parth new = AIzaSyCj7_HH_GJgl2WAsWrjeN7eahFa8PII82A
//"AIzaSyCtrdQZblQ2tnWP5smILZyLgRie1GwnAdQ"



//Party Place API Key - AIzaSyBo87SwMxVkEOhAepvQUxVQfJlvv1fG6e4

//MARK: - NOTIFICATION NAMES
let nNOTIFICATION_LOGOUT   =    "logoutNotification"

//MARK: - SOME COMMON THINGS
let kCHECK_INTERNET_CONNECTION   =  "Check your internet connection"
let kPROBLEM_FROM_SERVER         =  "Problem Receiving Data From Server"


//MARK: - SET APP THEME COLOR
let THEME_COLOR        = "3C69B2"

func showAlert(Title : String, Msg: String, view : UIViewController) -> Void {
    
    let alert = UIAlertController(title: Title, message: Msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    view.present(alert, animated: true)
    
}

func checkLocation(selff: UIViewController) -> Void {
    let alert = UIAlertController(title: "Allow location access", message: "Please allow location to get your current location", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (handler) in
        
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            //UIApplication.shared.openURL(settingsUrl)
            UIApplication.shared.openURL(settingsUrl)
        }
    }))
    selff.present(alert, animated: true)
    return
}


func noInternetAlert(selff: UIViewController) -> Void {
    
    let alert = UIAlertController(title: "Allow network access", message: "Please enable internet connection", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (handler) in
        
        if let url = URL(string: "App-Prefs:root") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }))
    selff.present(alert, animated: true)
    return
}


public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return "iPod Touch 5"
                case "iPod7,1":                                 return "iPod Touch 6"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhoneXs"
                case "iPhone11,4", "iPhone11,6":                return "iPhoneXsMax"
                case "iPhone11,8":                              return "iPhoneXr"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad6,11", "iPad6,12":                    return "iPad 5"
                case "iPad7,5", "iPad7,6":                      return "iPad 6"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
                }
            #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
