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
import SDWebImage

class Utils: NSObject {
    
    
    // MARK: - Check if user connected with Internet
    func connected() -> Bool {
        let reachability = Reachability.forInternetConnection()
        let status : NetworkStatus = reachability!.currentReachabilityStatus()
        if status == .NotReachable{
            return false
        }else{
            return true
        }
    }
    
    // MARK: - Make round corner to uiview
    func makeCircular(view : UIView) {
        view.layer.cornerRadius = view.frame.size.height/2
        view.layer.masksToBounds = true
    }
    
    // MARK: - Get AppDelegate instance
    func getAppDelegate() -> Any? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    // MARK: - Draw border in uiview
    func drawBorder(view: UIView?, color borderColor: UIColor?, width: Float, radius: Float) {
        view?.layer.borderColor = borderColor?.cgColor
        view?.layer.borderWidth = CGFloat(width)
        view?.layer.cornerRadius = CGFloat(radius)
        view?.layer.masksToBounds = true
    }
    
    // MARK: - add shadow to UIView
    func addShadowToView(view: UIView, radius : CGFloat, color : UIColor, shadowRadius : CGFloat, opacity : Float) {
        view.layer.cornerRadius = radius
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowOpacity = opacity
    }
    
    //MARK: - UserDefaults related Methods
    func setLatitude(latitude : String) {
        USERDEFAULTS.set(latitude, forKey: kCurrentLatitude)
    }
    func getLatitude() -> String {
        let latitude = USERDEFAULTS.value(forKey: kCurrentLatitude)as? String ?? "NA"
        return latitude
    }
    
    func setLongitude(longitude : String) {
        USERDEFAULTS.set(longitude, forKey: kCurrentLongitude)
    }
    func getLongitude() -> String {
        let longitude = USERDEFAULTS.value(forKey: kCurrentLongitude)as? String ?? "NA"
        return longitude
    }
    
    // MARK: - Get date formatted to specific format
    func getFormattedDate(date : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date!)
    }
    
    // MARK: - removing all UserDefaults
    func removeAllData() {
        
        //Need to manage the Device Token
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
    }
    
    //MARK: - SHOW HUD - Show loader view
    func ShowHUD(inView : UIView)  {
        MBProgressHUD.showAdded(to: inView, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(kNotificationDisableTab), object: nil)
    }
    
    //MARK: - Dismiss HUD - Hide loader view
    func dismissHUD(fromView : UIView ) {
        MBProgressHUD.hide(for: fromView, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(kNotificationEnableTab), object: nil)
    }
    
    
    
    //MARK:- add static gradient to uiview
    
    func addGradient(inView : UIView) {
        //inView.layer.sublayers = nil
        
        let color1 = UIColor.init(hexString: "F25B9D")!.cgColor
        let color2 = UIColor.init(hexString: "5E63F9")!.cgColor

        let gradient = CAGradientLayer()
        gradient.frame = inView.bounds
        gradient.startPoint = CGPoint(x:0, y:1)
        gradient.endPoint = CGPoint(x:1, y:0)
        gradient.colors = [color1, color2]
        inView.layer.addSublayer(gradient)
    }
    
    //MARK:- Animated Gradient
    func addAnimateGradient(inView : UIView) -> CAGradientLayer {
        
        let color1 = UIColor.init(hexString: "F25B9D")!.cgColor
        let color2 = UIColor.init(hexString: "5E63F9")!.cgColor
        
        let gradient = CAGradientLayer()
        gradient.frame = inView.bounds
        gradient.startPoint = CGPoint(x:0, y:1)
        gradient.endPoint = CGPoint(x:1, y:0)
        gradient.colors = [color1, color2]

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [color1, color2]
        animation.toValue = [color2, color1]
        animation.duration = 4.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        gradient.add(animation, forKey: nil)
        return gradient
    }
    
}

extension UIImage {
    //MARK: - method to add gradient
    static func gradientImage(with bounds: CGRect,
                              locations: [NSNumber]?) -> UIImage? {
        
        let color1 = UIColor.init(hexString: "F25B9D")!.cgColor
        let color2 = UIColor.init(hexString: "5E63F9")!.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color1, color2]
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    //MARK: - to convert Hexstrin color to UIColor
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}

extension Date {
    //MARK: - get current TimeStamp
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
}

//string to dictionary

extension String{
    //MARK: - convert the key value paired string to Dictionary
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension UIView{

    enum Points {
        case topLeft
        case topCenter
        case topRight
        case centerLeft
        case center
        case centerRight
        case bottomLeft
        case bottomCenter
        case bottomRight
    }
    
    //MARK: - set gradient to uiview in different direction
    func setGradientBackground(with colors: Array<UIColor>, startPoint: Points, endPoint: Points) {
        if colors.isEmpty || colors.count == 1 {
            return
        }
        
        //Convert Color To CGColor
        var cgColors: Array<CGColor> = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        
        self.layer.sublayers = nil
        
        //Setting GradientLayer
        
        var startingPoint = CGPoint()
        var endingPoint = CGPoint()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = cgColors
        
        switch startPoint {
        case .topLeft:
            startingPoint = CGPoint(x: 0.0, y: 0.0)
            
        case .topCenter:
            startingPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .topRight:
            startingPoint = CGPoint(x: 1.0, y: 0.0)
            
        case .centerLeft:
            startingPoint = CGPoint(x: 0.0, y: 0.5)
            
        case .center:
            startingPoint = CGPoint(x: 0.5, y: 0.5)
            
        case .centerRight:
            startingPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .bottomLeft:
            startingPoint = CGPoint(x: 0.0, y: 1.0)
            
        case .bottomCenter:
            startingPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomRight:
            startingPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        switch endPoint {
        case .topLeft:
            endingPoint = CGPoint(x: 0.0, y: 0.0)
            
        case .topCenter:
            endingPoint = CGPoint(x: 0.5, y: 0.0)
            
        case .topRight:
            endingPoint = CGPoint(x: 1.0, y: 0.0)
            
        case .centerLeft:
            endingPoint = CGPoint(x: 0.0, y: 0.5)
            
        case .center:
            endingPoint = CGPoint(x: 0.5, y: 0.5)
            
        case .centerRight:
            endingPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .bottomLeft:
            endingPoint = CGPoint(x: 0.0, y: 1.0)
            
        case .bottomCenter:
            endingPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .bottomRight:
            endingPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        gradientLayer.startPoint = startingPoint
        gradientLayer.endPoint = endingPoint
        
        
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension String {
    //MARK: - capitalize first letter
    func capitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
