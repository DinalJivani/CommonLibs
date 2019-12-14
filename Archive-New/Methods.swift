//
//  Methods.swift
//  HUBUC
//
//  Created by Dinal Jivani on 14/12/19.
//  Copyright © 2018 Dinal. All rights reserved.
//

import Foundation
import UIKit
import libPhoneNumber_iOS

//MARK:- Shadow to the view
func shadowToView(view : UIView){
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowOpacity = 0.6
    view.layer.shadowRadius = 2.0
    view.layer.shadowColor = UIColor.lightGray.cgColor
}

//MARK:- to make the circular
func makeCircular(view : UIView, cornerRadius : Float) {
    view.layer.cornerRadius = CGFloat(cornerRadius)
    view.layer.masksToBounds = true
    view.clipsToBounds = true
}

//MARK:- Add shadow with corner radius
func addShadowToView(view: UIView, radius : CGFloat, color : UIColor, shadowRadius : CGFloat, opacity : Float) {
    view.layer.cornerRadius = radius
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = shadowRadius
    view.layer.shadowOpacity = opacity
}

//MARK:- Common Functions
func EmailValidation(string :String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: string)
}

//MARK:- to draw a border and apply the corner radius
func drawBorder(view: UIView?, color borderColor: UIColor?, width: Float, radius: Float) {
    view?.layer.borderColor = borderColor?.cgColor
    view?.layer.borderWidth = CGFloat(width)
    view?.layer.cornerRadius = CGFloat(radius)
    view?.layer.masksToBounds = true
}

//MARK:- Phone number validation

func phoneNumberValidation(number: String, countryCodeStr: String, view: UIView) -> Bool{
    let phoneUtil = NBPhoneNumberUtil()
    
    do {
        let phoneNumber: NBPhoneNumber = try phoneUtil.parse(number, defaultRegion: countryCodeStr)
        let value = phoneUtil.isValidNumber(phoneNumber)
        if(value == true){
            return true
        }
        else{
            return false
        }
    }
    catch let _ as NSError {
        //showToast(message: "Not a valid number", view: view)
        //print(error.localizedDescription)
        return false
    }
}


//MARK:- Current Time Stamp in Millis
func currentTimeMillis() -> String{
    let nowDouble = NSDate().timeIntervalSince1970
    return String(Int64(nowDouble*1000))
}

//MARK:- Show Alert
func showAlert(message : String, controller: UIViewController) {
    let alert = UIAlertController(title: cAPPNAME, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}

//MARK:- Show Alert without button
func showAlertWithoutHeader(message : String, controller: UIViewController) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
    controller.present(alert, animated: true, completion: nil)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Function to allow location
func allowlocation(){
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
        
        UIApplication.shared.openURL(settingsUrl)
        
    }
}

extension String {
    //MARK: - Convert HTML to string or attributed string
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UIView {    
    //MARK: - Drop shadow to uiview
    func dropShadow(scale: Bool = true, color: UIColor) {
        DispatchQueue.main.async {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = 1.0
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = self.layer.cornerRadius
            
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    }
}

//MARK:- Each side corner radius
extension UIView {
    //MARK:- for num of different button view
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0)
    {
        //(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension UIBezierPath
{
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero)
    {
        //MARK: - Create modified Bezier path
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension NSMutableAttributedString {
    //MARK: - to make attributed string bold
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Lato-Bold", size: 11)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    //MARK: - to make attributed string normal
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Lato-Regular", size: 11)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
}


private var associatedLanguageBundle:Character = "0"

class PrivateBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let bundle: Bundle? = objc_getAssociatedObject(self, &associatedLanguageBundle) as? Bundle
        return (bundle != nil) ? (bundle!.localizedString(forKey: key, value: value, table: tableName)) : (super.localizedString(forKey: key, value: value, table: tableName))
        
    }
}

extension Bundle {
    class func setLanguage(_ new: String?) {
        
        var language = new
        if(language != "es"){
            language = "en"
        }
        
        var onceToken: Int = 0
        
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            object_setClass(Bundle.main, PrivateBundle.self)
        }
        onceToken = 1
        objc_setAssociatedObject(Bundle.main, &associatedLanguageBundle, (language != nil) ? Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? "") : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}
