
import Foundation
import UIKit

//MARK: - SCREEN BOUNDS
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//MARK: - GET APPDELEGATE
let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate
let STORYBOARD = UIStoryboard.init(name: "Main", bundle: nil)

//MARK: - API HOST URL
let cWEBHOST = "http://52.15.115.12:9000/api/"

//MARK: - API NAMES
let cLOGIN = "login"

//MARK: - SOME COMMON THINGS
let kCHECK_INTERNET_CONNECTION   =  "Please check your Internet Connection"
let kPROBLEM_FROM_SERVER         =  "Problem receiving data from server"

//MARK:- Userdefault
let USERDEFAULTS = UserDefaults.standard

//MARK:- App Details
let DEVICE_ID = UIDevice.current.identifierForVendor!.uuidString

