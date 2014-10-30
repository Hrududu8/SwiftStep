//
//  ViewController.swift
//  SwiftStep
//
//  Created by rukesh on 7/29/14.
//  Copyright (c) 2014 Rukesh. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore
import CoreMotion

let kNumberOfDaysToDisplayInPortraitView = 7
let kNumberOfDaysToDisplayInLandscapeView = 30

//model class
class SwiftStepDataModel: NSObject, NSCoding { //Does this need to conform to NSObject in order to use NSCoding
    var thisWeeksData = [NSDate : Double]()
    var listOfDates = [NSDate]()
    var todayAtMidnight = NSDate()
    var stepData = [NSDate: Double]()
    var stepValues = [Double]()
    var aWord = "Given"
    
    override init(){
        super.init()
        todayAtMidnight = getTodayAtMidnight()
        getThisWeeksDataStartingFrom(todayAtMidnight)
        for day in thisWeeksData.keys {
            stepData.updateValue(thisWeeksData[day]!, forKey: day)
        }
        for (index, val) in stepData {
            stepValues.append(val)
}
        
    }
    convenience required init(coder decoder: NSCoder){//lessons learned:  you have to restore all the data from the file because the convenience init calls self.init BEFORE any the data is restore and self.init is where the computed property -- in this case stepValues was first created.  
        self.init()
        println("convenience init called")
        self.aWord = decoder.decodeObjectForKey("aWord") as String
        if let unwrappedDictionary: AnyObject = decoder.decodeObjectForKey("thisWeeksData") {
            self.thisWeeksData = unwrappedDictionary as Dictionary
            println("decoder 1 ran")
                }
        if let unwrappedArrayOfDates: AnyObject = decoder.decodeObjectForKey("listOfDates") {
            self.listOfDates = unwrappedArrayOfDates as Array
                }

        if let unwrappedDate: AnyObject = decoder.decodeObjectForKey("todayAtMidnight") {
            self.todayAtMidnight = unwrappedDate as NSDate
            println("decoder 2 ran")
            }
        
        if let anotherUnWrappedDictionary: AnyObject = decoder.decodeObjectForKey("stepData"){
            self.stepData = anotherUnWrappedDictionary as Dictionary
            println("last decoder ran")
                }
        if let unwrappedArray: AnyObject = decoder.decodeObjectForKey("stepValues"){
            self.stepValues = unwrappedArray as Array
}

    
    }
    func encodeWithCoder(coder: NSCoder){
        coder.encodeObject(aWord, forKey:"aWord")
            coder.encodeObject(self.thisWeeksData, forKey:"thisWeeksData")
        coder.encodeObject(self.listOfDates, forKey:"listOfDates")
        
coder.encodeObject(self.todayAtMidnight, forKey:"todayAtMidnight")
        
        
        coder.encodeObject(self.stepData, forKey:"stepData")
    coder.encodeObject(self.stepValues, forKey:"stepValues")
    }
   
    

    func getThisWeeksDataStartingFrom(day: NSDate)->(){
        let myCalender = NSCalendar.autoupdatingCurrentCalendar()
        let components = myCalender.components(.CalendarUnitDay, fromDate: day)
        
        for i in 0...6 {
            
            components.day--
            var newDay = myCalender.dateByAddingComponents(components, toDate: day , options: nil)
            self.listOfDates.append(newDay)
            self.thisWeeksData[newDay] = getData(newDay)          }
    }
    func getTodayAtMidnight()->(NSDate){
        let myCalendar = NSCalendar.autoupdatingCurrentCalendar()
        let now  = NSDate()
        let components = myCalendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: now)
        var midnightComponents = NSDateComponents()
        midnightComponents.year = components.year
        midnightComponents.month = components.month
        midnightComponents.day = components.day
        midnightComponents.hour = 0
        midnightComponents.minute = 1
        return myCalendar.dateFromComponents(midnightComponents)!
    }
    func getData(day: NSDate)->(Double){
        //this will eventually be where the query to CoreMotion goes
        
        //this is a stub
        return Double(arc4random()) % 20000
    }
    func getNDaysOfDataAsArray(numberOfDays: Int)->[Double]{
        var dates = stepData.keys
        sorted(dates, isEarlier)
        var arrayOfData = [Double]()
        for day in dates {
            arrayOfData.append(stepData[day]!)
        }
        return arrayOfData
    }
    func isEarlier(startDate: NSDate, endDate: NSDate) -> (Bool){
        if(startDate.compare(endDate) == NSComparisonResult.OrderedAscending){
            return true
        }
        return false
}
}


extension UIViewController {
    func waitForOrientationChange(){
        var thisDevice = UIDevice.currentDevice()!
        thisDevice.beginGeneratingDeviceOrientationNotifications()
        let myNotificationCenter = NSNotificationCenter.defaultCenter()
        myNotificationCenter.addObserver(
            self,
            selector: "orientationChanged:",  //Lessons learned:  you need a colon at the end of "orientationChanged:" if it takes a method!!
            name: UIDeviceOrientationDidChangeNotification,
            object: nil
        )
    }
}

class ViewController: UIViewController, JBBarChartViewDataSource, JBBarChartViewDelegate { // todo:  make a new subclass of viewcontroller that has two subclasses:  portrait and landscapeViewController
    lazy var myData = SwiftStepDataModel()
    var landscapeViewController = LandscapeViewController()
    lazy var myChart: JBBarChartView = JBBarChartView(frame: CGRectMake(self.view.frame.minX+5, self.view.frame.midY-10, self.view.frame.width-10, self.view.frame.height/2)) //lessons learned:  you should let autocomplete fill in the method signature for you rather than trying to deduce what the correct syntax will be from dimly understand rules of converting objc to swift
    
    func swapControllersIfNeeded(){
        let deviceOrientation = UIDevice.currentDevice().orientation
        if(UIDeviceOrientationIsLandscape(deviceOrientation) && self.isViewLoaded()){
            self.landscapeViewController = self.storyboard.instantiateViewControllerWithIdentifier("LandscapeViewController")
             as LandscapeViewController
            self.landscapeViewController.myData = self.myData
            self.navigationController.pushViewController(self.landscapeViewController, animated: true)
            self.navigationController.setNavigationBarHidden(true, animated: false)
        }
        if(UIDeviceOrientationIsPortrait(deviceOrientation) && (self.isViewLoaded())){
            self.navigationController.popToRootViewControllerAnimated(false)
            println("popped")
            self.displayMyChart()
        }
    }
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtAtIndex index: UInt) -> CGFloat {
        // FIXME: RETURN TO NORMAL WHEN DONE
        //return CGFloat(myData.stepValues[Int(index)])
        var dataArray = [100.0, 5000.0, 5500.0, 9000.0, 12000.0, 19000.0, 2200.0]
        let someData = CGFloat(dataArray[Int(index)])
        return someData
    }
    override init(){
        super.init()
            }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if(self.checkIfFileExists()==true){ //what does this line of code do?  nothing apparently?
        }

    }

    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!)->UInt{
        if(myData.stepData.count<7){
            return UInt(myData.stepValues.count)
        } else {
            return UInt(kNumberOfDaysToDisplayInPortraitView)
        }
    }
    func orientationChanged(sender: AnyObject){
        swapControllersIfNeeded()
        println("print orientation changed")
        return
    }
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
            var barColor = UIColor()
            let totalSteps = myData.stepValues.reduce(0, combine: +)
            let counter = Float(myData.stepValues.count)
            let averageSteps = totalSteps/Double(counter)
            let halfAverage = averageSteps/2
            switch myData.stepValues[Int(index)] {
                case 0..<halfAverage:
                barColor = UIColor.redColor()
                case halfAverage..<averageSteps:
                barColor = UIColor.orangeColor()
                case averageSteps...15000:
                barColor = UIColor.greenColor()
                default:
                barColor = UIColor.blueColor()
}
            return barColor
}
//this is the problem function
// FIXME: this is the ->UIView function that breaks it
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        let colorTop = UIColor(red:192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue:2.0/255.0, alpha:1.0).CGColor
        
        var aView = UIView()
        aView.frame = barChartView.bounds
        aView.backgroundColor = UIColor.blueColor()
        var gLayer = CAGradientLayer()
        gLayer.frame = aView.bounds // is is this that is causing the problem?
        let c:[AnyObject] = [colorTop,colorBottom]
        gLayer.colors = c
        gLayer.locations = [0.0, 1.0]
        aView.layer.insertSublayer(gLayer, atIndex: 1)
        return aView

}

//- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index;



    override func viewDidLoad() { //maybe we should move the initialization of the data structures to the app delegate code??
       super.viewDidLoad()
        
       myChart.dataSource = self
       myChart.delegate = self
        myChart.minimumValue = 100 //FIXME:  this is providing the user with fake data!
       
        let myNotificationCenter = NSNotificationCenter.defaultCenter()
        myNotificationCenter.addObserver(
            self,
            selector: "saveDataToDisk",  //Lessons learned:  you need a colon at the end of "orientationChanged:" if it takes a method!!
            name: UIApplicationWillResignActiveNotification,
            object: nil
        ) //need to add memory warning and terminate notifications
       self.displayMyChart()
       self.view.addSubview(myChart)
       self.waitForOrientationChange()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMyChart() {
          myChart.reloadData()      //does this function ever actually return or does it just keep recursing?

    }
    func checkIfFileExists()->Bool{
        var documentDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as String
        let myFileManager = NSFileManager()
        var path = documentDir.stringByAppendingPathComponent("SwiftStep.archive")
        if(myFileManager.fileExistsAtPath(path)==true){
            println("the file exists")
            self.myData = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as SwiftStepDataModel
            println("the path is \(path)")
            println("the word is \(self.myData.aWord)")
            println("the array is \(self.myData.stepValues)")
            return true
        }
        return false
        
}
    func saveDataToDisk()->Bool{
        //Note that the line below is a concatention of two lines
        //1st get an array of the directories:  arrayOfDirs = NSSearchPathForDirectories ... which returns an array of AnyObjects
        //2d get element [0] of that array as a string
        var documentDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as String
        let myFileManager = NSFileManager()
        var err = NSErrorPointer()
        if(myFileManager.fileExistsAtPath(documentDir)==false){
            myFileManager.createDirectoryAtPath(documentDir, withIntermediateDirectories: false, attributes: nil, error: err)
            println("created new dir")
        }
        var path = documentDir.stringByAppendingPathComponent("SwiftStep.archive")
        var success = NSKeyedArchiver.archiveRootObject(myData, toFile: path) //you need to check if the directory exists and if not create it
        if(success) {
            println("Successfully save")
        } else {
            println("failed to save")
        }
        println("\(path)")
        return true
    }
}

class LandscapeViewController: UIViewController, JBBarChartViewDataSource, JBBarChartViewDelegate  {
    var myData = SwiftStepDataModel()
    lazy var myChart: JBBarChartView = JBBarChartView(frame: CGRectMake(self.view.frame.minX+5, self.view.frame.midY-10, self.view.frame.width-10, self.view.frame.height/2))
    override func  viewDidLoad() {
        super.viewDidLoad()
       myChart.dataSource = self
       myChart.delegate = self
        myChart.minimumValue = 100 //FIXME:  this is providing the user with fake data!
       self.displayMyChart()
       self.view.addSubview(myChart)
       self.waitForOrientationChange()

        
    }
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtAtIndex index: UInt) -> CGFloat {
        return CGFloat(myData.stepValues[Int(index)])
    }
    
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!)->UInt{
        if(myData.stepValues.count<30){
            return UInt(myData.stepValues.count)
        } else {
            return UInt(kNumberOfDaysToDisplayInLandscapeView)
        }
      }
    func displayMyChart() {
          myChart.reloadData()      //does this function ever actually return or does it just keep recursing?

    }
    func orientationChanged(sender: AnyObject){
        //do nothing the root view controller handles returning to portrait mode
        return
    }
    
}
