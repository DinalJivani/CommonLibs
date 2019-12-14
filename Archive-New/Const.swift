//
//  Const.swift
//  SwiftProjectStructure
//
//  Created by Dinal Jivani on 14/12/19.
//  Copyright © 2018 Dinal. All rights reserved.

import Foundation
import UIKit

//MARK: - SCREEN BOUNDS
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//MARK: - GET APPDELEGATE
let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate
let STORYBOARD = UIStoryboard.init(name: "Main", bundle: nil)

//MARK: - Google Vision API
var googleAPIKey = "AIzaSyBcrm6qSoskDd1Sj2oxbuBheuhQmFwJCBk"
var googleURL: URL {
    return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
}



//MARK: - API HOST URL
let cWEBHOST = "http://52.15.115.12:9000/api/"

//MARK: - API NAMES
let cLOGIN = "users/login"
let cCMS = "cms/getCms"
let cFORGOTPASSWORD = "users/forgotPassword"
let cCHECKISLOGGEDOUT = "users/checkLogin"
let cCHANGENUMBER = "users/editPhonenumber"
let cCHANGEEMAIL = "users/editEmailId"
let cCHANGEPASSWORD = "users/editPassword"
let cBALANCEINQUIRY = "transaction/balanceInquiry"//
let cTRANSFERHISTORY = "transaction/transferHistory"//
let cGETALLNOTIFICATION = "transaction/notificationHistory"//
let cGETALLEXPENSES = ""
let cGETALLREPORTS = ""
let cUPDATEPROFILEPIC = "users/updateProfilePic"
let cNOTIFICATIONONOFF = "users/notificationOnOff"
let cCLEARBADGE = "users/clearBadge"
let cSETPASSCODE = "users/setPasscode"
let cMATCHPASSCODE = "users/matchPasscode"
let cFORGOTPASSCODE = "users/forgotPasscode"
let cCLEARNOTIFICATION = "transaction/clearNotifications"
let cLOGOUT = "users/logout"


//For NotificationCenter
let kNotificationDisableTab = "DisableTabBar"
let kNotificationEnableTab = "EnableTabBar"


//MARK: - SOME COMMON THINGS
let kCHECK_INTERNET_CONNECTION   =  NSLocalizedString("noInternet", comment: "")
let kPROBLEM_FROM_SERVER         =  NSLocalizedString("problemReceiveingDataFromServer", comment: "")

//MARK:- Userdefault
let USERDEFAULTS = UserDefaults.standard
let kLogin = "isUserLogin"
let kIsPasscodeSet = "isPasscodeSet"
let kLoginData = "LoginData"
let kReturnToken = "ReturnedToken"
let kJWTToken = "JWTToken"
let kOtherReturnToken = "OtherReturnedToken"
let kLanguageChanged = "IsLanguageChanged"
let kCurrentLanguage = "CurrentLanguage"

let kDeviceToken = "device_token"
let kCurrentLatitude = "CurrentLatitude"
let kCurrentLongitude = "CurrentLongitude"
let kNotificationOnOff = "NotificationOnOff"

//MARK: - Static Color
let themeBlueColor = UIColor(red: 88.0/255.0, green: 99.0/255.0, blue: 252.0/255.0, alpha: 1.0)
let themePinkColor = UIColor(red: 250.0/255.0, green: 93.0/255.0, blue: 160.0/255.0, alpha: 1.0)

//MARK: - iTUNES URL for Share App
let iTunesURL = ""
let APPSTORE_APPID  = ""
var cISPORTRAIT = true

//MARK:- App Details
let DEVICE_ID = UIDevice.current.identifierForVendor!.uuidString
let cAPPNAME = "HUBUC"
let APPLOZIC_ID = "hubuc3942845b4271cd601e47cd9c3ab96da1"
var dictUserInfo = NSMutableDictionary()

