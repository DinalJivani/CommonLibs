//
//  Utils.swift
//  SwiftProjectStructure
//
//  Created by Dinal Jivani on 14/12/19.
//  Copyright © 2018 Dinal. All rights reserved.
//

import UIKit
import MBProgressHUD
import Reachability

class Utils: NSObject {
    // MARK: - Common
    func connected() -> Bool {
        let reachability = Reachability.forInternetConnection()
        let status : NetworkStatus = reachability!.currentReachabilityStatus()
        if status == .NotReachable{
            return false
        }else{
            return true
        }
    }
    
    func makeCircular(view : UIView) {
        view.layer.cornerRadius = view.frame.size.height/2
        view.layer.masksToBounds = true
    }
    
    func getAppDelegate() -> Any? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func drawBorder(view: UIView?, color borderColor: UIColor?, width: Float, radius: Float) {
        view?.layer.borderColor = borderColor?.cgColor
        view?.layer.borderWidth = CGFloat(width)
        view?.layer.cornerRadius = CGFloat(radius)
        view?.layer.masksToBounds = true
    }
    func getThemeColor() -> UIColor {
        return UIColor(hexString: THEME_COLOR)
    }
    
    //MARK:- Current Lat Long
    func setCurrentLat(currentLat : String) {
        UserDefaults.standard.set(currentLat, forKey: sCURRENT_LAT)
    }
    func getCurrentLat() -> String! {
        //return "21.195748" //Ebizz
        return "-37.81568327615751" //Melbourne
        //return UserDefaults.standard.value(forKey: sCURRENT_LAT) as! String
    }
    
    func setCurrentLong(currentLong : String) {
        UserDefaults.standard.set(currentLong, forKey: sCURRENT_LONG)
    }
    func getCurrentLong() -> String! {
        //return "72.808509" //Ebizz
        return "144.96110430988648" //Melbourne
        //return UserDefaults.standard.value(forKey: sCURRENT_LONG) as! String
    }

    func GetAppname() -> String! {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
        return appName
    }
    
    //MARK: - SHOW HUD
    func ShowHUD(inView : UIView)  {
        MBProgressHUD.showAdded(to: inView, animated: true)
    }
    
    func dismissHUD(fromView : UIView ) {
        MBProgressHUD.hide(for: fromView, animated: true)
    }
    
    func createBlankFooterView() -> UIView? {
        let blankFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
        blankFooterView.backgroundColor = UIColor.clear
        return blankFooterView
    }
    
    func createFooterView() -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30.0))
        footerView.backgroundColor = UIColor.clear
        let actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        actInd.tag = 10
        actInd.color = getThemeColor()
        actInd.tintColor = getThemeColor()
        actInd.frame = CGRect(x: UIScreen.main.bounds.size.width / 2, y: 0, width: 10.0, height: 10.0)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        return footerView
    }
    
}
