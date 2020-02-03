
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
    
    // MARK: - Get AppDelegate instance
    func getAppDelegate() -> Any? {
        return UIApplication.shared.delegate as? AppDelegate
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
