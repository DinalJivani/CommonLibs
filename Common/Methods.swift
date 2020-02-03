
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
