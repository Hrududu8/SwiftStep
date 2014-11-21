//
//  SwiftStepDataModel.swift
//  SwiftStep
//
//  Created by rukesh on 11/1/14.
//  Copyright (c) 2014 Rukesh. All rights reserved.
//

import Foundation
import CoreMotion

//model class
class SwiftStepDataModel: NSObject, NSCoding { //Does this need to conform to NSObject in order to use NSCoding
    var operationQueue = NSOperationQueue()
    var stepCounter = CMPedometer()
    var thisWeeksData = [NSDate : Double]()
    var listOfDates = [NSDate]()
    var todayAtMidnight = NSDate()
    var stepData = [NSDate: Double]()
    var stepValues = [Double]()
    var weeklyAverage: Double {
        let totalStepsThisWeek = stepValues.reduce(0, +) //so fancy
        return totalStepsThisWeek/7
    }
    struct OneDay {
        var start: NSDate
        var end: NSDate
    }
    
    override init(){
        super.init()
        let now = NSDate()
        todayAtMidnight = getTodayAtMidnight(now)
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
        if let unwrappedDictionary: AnyObject = decoder.decodeObjectForKey("thisWeeksData") {
            self.thisWeeksData = unwrappedDictionary as Dictionary
        }
        if let unwrappedArrayOfDates: AnyObject = decoder.decodeObjectForKey("listOfDates") {
            self.listOfDates = unwrappedArrayOfDates as Array
        }
        
        if let unwrappedDate: AnyObject = decoder.decodeObjectForKey("todayAtMidnight") {
            self.todayAtMidnight = unwrappedDate as NSDate
        }
        
        if let anotherUnWrappedDictionary: AnyObject = decoder.decodeObjectForKey("stepData"){
            self.stepData = anotherUnWrappedDictionary as Dictionary
        }
        if let unwrappedArray: AnyObject = decoder.decodeObjectForKey("stepValues"){
            self.stepValues = unwrappedArray as Array
        }
        
        
    }
    func encodeWithCoder(coder: NSCoder){
        coder.encodeObject(self.thisWeeksData, forKey:"thisWeeksData")
        coder.encodeObject(self.listOfDates, forKey:"listOfDates")
        
        coder.encodeObject(self.todayAtMidnight, forKey:"todayAtMidnight")
        
        
        coder.encodeObject(self.stepData, forKey:"stepData")
        coder.encodeObject(self.stepValues, forKey:"stepValues")
    }
    
    func makeOneDayFromDate(theDay: NSDate)->OneDay{
        let myCalendar = NSCalendar.autoupdatingCurrentCalendar()
        let components = myCalendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: theDay)
        var midnight01Components = NSDateComponents()
        midnight01Components.year = components.year
        midnight01Components.month = components.month
        midnight01Components.day = components.day
        midnight01Components.hour = 0
        midnight01Components.minute = 1
        var midnightComponents = NSDateComponents()
        midnightComponents.year = components.year
        midnightComponents.month = components.month
        midnightComponents.day = components.day
        midnightComponents.hour = 0
        midnightComponents.minute = 0
        
        return OneDay(start: myCalendar.dateFromComponents(midnight01Components)!, end: myCalendar.dateFromComponents(midnightComponents)!)
    }
    
    func getThisWeeksDataStartingFrom(day: NSDate)->(){
        let myCalender = NSCalendar.autoupdatingCurrentCalendar()
        let components = myCalender.components(.CalendarUnitDay, fromDate: day) //the day of the month
        for i in stride(from: 6, through: 0, by: -1)
        {
            components.day--
            var newDay = myCalender.dateByAddingComponents(components, toDate: day , options: nil) // this is adding the date of the month (e.g., 18 on Nov. 18) to the current day and querrying for the step count on e.g., Dec. 5 (=Nov. 18 + 18)
            self.listOfDates.append(newDay!)
            self.thisWeeksData[newDay!] = getData(newDay!)
        }
    }
    
    
    
    
    func getTodayAtMidnight(day: NSDate)->(NSDate){
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
        var valueToReturn = 0.0
        let now = NSDate()
        stepCounter.queryPedometerDataFromDate(day, toDate: now, withHandler: {(myCMPedometerData, myNSError)->Void in
            if(myNSError != nil){
                println("there was an error \(myNSError)")
            }
            //valueToReturn = Double(myCMPedometerData.numberOfSteps) //is this returning nil because its on the simulator?
            })
            
        
         return Double(random()) % 20000
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





