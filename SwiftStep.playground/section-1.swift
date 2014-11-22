import UIKit
import QuartzCore

/*
let circle = UIView();

circle.bounds = CGRect(x: 0,y: 0, width: 100, height: 100);
circle.frame = CGRectMake(0,0, 100, 100);

circle.layoutIfNeeded()

var progressCircle = CAShapeLayer();

let centerPoint = CGPoint (x: circle.bounds.width / 2, y: circle.bounds.width / 2);
let circleRadius : CGFloat = circle.bounds.width / 2 * 0.83;

var circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat(1.5 * M_PI), clockwise: true    );

//progressCircle = CAShapeLayer ();
progressCircle.path = circlePath.CGPath;
progressCircle.strokeColor = UIColor.greenColor().CGColor;
progressCircle.fillColor = UIColor.clearColor().CGColor;
progressCircle.lineWidth = 1.5;
progressCircle.strokeStart = 0;
progressCircle.strokeEnd = 0.22;

circle.layer.addSublayer(progressCircle);

circle // before stroke extended

progressCircle.strokeEnd = 0.83;

circle // after stroke end extended
*/
/*
class stepBars: UIView {
    
    let colorBrightRed = UIColor(red: 0.965, green: 0.224, blue: 0.086, alpha: 1.0).CGColor  /*#f63916*/
    let colorRed = UIColor(red: 0.647, green: 0.031, blue: 0.071, alpha: 1.0).CGColor /*#a50812*/
    let colorOrange = UIColor(red: 0.8, green: 0.306, blue: 0.114, alpha: 1.0).CGColor /*#cc4e1d*/
    let colorGreen = UIColor(red: 0.282, green: 0.404, blue: 0.129, alpha: 1.0).CGColor /*#486721*/
    let colorBackground = UIColor(red:0.415, green: 0.055, blue:0.078, alpha:1.0) /*#6a0e14*/
    
    override init(frame: CGRect){
        super.init(frame:frame)
        self.backgroundColor = colorBackground
        var gLayer = CAGradientLayer()
        let layerRect = CGRect(x: 20, y: 20, width: 200, height: 500)
        gLayer.frame = layerRect
        let c:[AnyObject] = [colorGreen, colorOrange, colorRed, colorBrightRed]
        gLayer.colors = c
        gLayer.locations = [0.2, 0.4, 0.6, 0.8]
      
        let path = UIBezierPath(roundedRect: layerRect, byRoundingCorners:  .TopRight | .TopLeft, cornerRadii: CGSize(width: 50, height: 50))
        var mask = CAShapeLayer()
        mask.path = path.CGPath
        mask.fillColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).CGColor
        mask.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).CGColor
        self.layer.insertSublayer(gLayer, atIndex: 1)
        self.layer.insertSublayer(mask, atIndex: 2)
        
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

}

//RK  you can make the path from two rects -- one bigger and one smaller using the odd even rule




var aView = stepBars(frame: CGRect(x: 0,y: 0, width: 300, height: 600))



let layerRect = CGRect(x: 0, y: 0, width: 200, height: 500)
var thisView = UIView(frame: layerRect)

let path = UIBezierPath(roundedRect: layerRect, byRoundingCorners: .BottomRight | .BottomLeft | .TopRight | .TopLeft, cornerRadii: CGSize(width: 50, height: 50))
var mask = CAShapeLayer()
mask.path = path.CGPath
thisView.layer.insertSublayer(mask, atIndex: 1)
thisView

*/


var aView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
aView.backgroundColor = UIColor.greenColor()


aView.layer.cornerRadius = 10
aView.layer.backgroundColor = UIColor.blueColor().CGColor
aView.layer.masksToBounds = true
aView

extension NSDate {
    func start()->NSDate{
        let myCalendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = myCalendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self)
        var midnightComponents = NSDateComponents()
        midnightComponents.year = components.year
        midnightComponents.month = components.month
        midnightComponents.day = components.day
        midnightComponents.hour = 0
        midnightComponents.minute = 0
        midnightComponents.second = 0
        return myCalendar.dateFromComponents(midnightComponents)!
    }
    func end()->NSDate{
        let myCalendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = myCalendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: self)
        var twentyThreeFiftyNine = NSDateComponents()
        twentyThreeFiftyNine.year = components.year
        twentyThreeFiftyNine.month = components.month
        twentyThreeFiftyNine.day = components.day
        twentyThreeFiftyNine.hour = 23
        twentyThreeFiftyNine.minute = 59
        twentyThreeFiftyNine.second = 59
        return myCalendar.dateFromComponents(twentyThreeFiftyNine)!
    }
}
let now = NSDate()
now.start()
now.end()
let interval = now.end().timeIntervalSinceDate(now.start())

let dayInSecs = 86400


















