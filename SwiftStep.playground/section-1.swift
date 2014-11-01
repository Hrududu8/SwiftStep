import UIKit
import QuartzCore


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

let colorTop = UIColor(red: 23.0/255.0, green: 93.0/255.0, blue: 25.0/255.0, alpha: 1.0).CGColor
let colorMiddle = UIColor.orangeColor().CGColor
let colorBottom = UIColor(red:192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).CGColor


var aView = UIView()
aView.frame = CGRect(x: 0,y: 0, width: 100, height: 200);
aView.bounds = CGRectMake(0,0, 100, 200);

var gLayer = CAGradientLayer()
gLayer.frame = aView.frame
let c:[AnyObject] = [colorTop,colorMiddle,colorBottom]
gLayer.colors = c
gLayer.locations = [0.0, 0.25, 0.8]

gLayer
aView.layer.insertSublayer(gLayer, atIndex: 1)
aView
