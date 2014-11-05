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
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        //initialize colors
        
        let colorBrightRed = UIColor(red: 0.647, green: 0.031, blue: 0.071, alpha: 1.0) /*#a50812*/
        let colorRed = UIColor(red: 0.800, green: 0.031, blue: 0.071, alpha: 1.0)
        let colorOrange = UIColor(red: 0.8, green: 0.306, blue: 0.114, alpha: 1.0) /*#cc4e1d*/
        let colorGreen = UIColor(red: 0.282, green: 0.404, blue: 0.129, alpha: 1.0) /*#486721*/
        
        var aView = UIView()
        aView.frame = barChartView.bounds
        
        var threshold = myData.weeklyAverage < 10000 ? myData.weeklyAverage : 10000
        
        switch myData.stepValues[Int(index)] {
        case 0...2000:
                aView.backgroundColor = colorBrightRed
        case 2001..<threshold:
            aView.backgroundColor = colorRed
        case threshold...10000:
            aView.backgroundColor = colorOrange
        default:
            aView.backgroundColor = colorGreen
        }

        return aView

}

    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        var color = UIColor()
        let threshold = myData.weeklyAverage < 10000 ? myData.weeklyAverage : 10000
        switch myData.stepValues[Int(index)] {
        case 0...2000:
            color = UIColor(red: 0.965, green: 0.224, blue: 0.086, alpha: 1.0)  /*#f63916*/
        case 2001..<threshold:
            color = UIColor(red: 0.647, green: 0.031, blue: 0.071, alpha: 1.0) /*#a50812*/
        case threshold...10000:
            color = UIColor(red: 0.8, green: 0.306, blue: 0.114, alpha: 1.0) /*#cc4e1d*/
        default:
            UIColor(red: 0.282, green: 0.404, blue: 0.129, alpha: 1.0) /*#486721*/
        }
        let tempColor = UIColor.redColor()
        return color
        
    }

 

    override func viewDidLoad() { //maybe we should move the initialization of the data structures to the app delegate code??
       super.viewDidLoad()
        
       myChart.dataSource = self
       myChart.delegate = self
        myChart.minimumValue = 100 //FIXME:  this is providing the user with fake data!
       let colorBackground = UIColor(red:0.341, green: 0.373, blue:0.369, alpha:1.0) /*#830b11*/
        
        let myNotificationCenter = NSNotificationCenter.defaultCenter()
        myNotificationCenter.addObserver(
            self,
            selector: "saveDataToDisk",  //Lessons learned:  you need a colon at the end of "orientationChanged:" if it takes a method!!
            name: UIApplicationWillResignActiveNotification,
            object: nil
        ) //need to add memory warning and terminate notifications
       myChart.backgroundColor = colorBackground
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
