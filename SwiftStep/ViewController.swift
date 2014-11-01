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

extension UIViewController {
    func waitForOrientationChange(){
        var thisDevice = UIDevice.currentDevice()
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
            self.landscapeViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LandscapeViewController")
             as LandscapeViewController
            self.landscapeViewController.myData = self.myData
            self.navigationController!.pushViewController(self.landscapeViewController, animated: true)
            self.navigationController!.setNavigationBarHidden(true, animated: false)
        }
        if(UIDeviceOrientationIsPortrait(deviceOrientation) && (self.isViewLoaded())){
            self.navigationController!.popToRootViewControllerAnimated(false)
            println("popped")
            self.displayMyChart()
        }
    }
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtAtIndex index: UInt) -> CGFloat {
        return CGFloat(myData.stepValues[Int(index)])
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
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        let colorTop = UIColor(red:192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue:2.0/255.0, alpha:1.0).CGColor
        
        var aView = UIView()
        aView.frame = barChartView.bounds
        var gLayer = CAGradientLayer()
        gLayer.frame = aView.bounds
        let c:[AnyObject] = [colorTop,colorBottom]
        gLayer.colors = c
        gLayer.locations = [0.0, 1.0]
        aView.layer.insertSublayer(gLayer, atIndex: 1)
        return aView

}




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
            self.myData = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as SwiftStepDataModel
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
