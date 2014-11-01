//
//  SwiftStepDataModel.swift
//  SwiftStep
//
//  Created by rukesh on 11/1/14.
//  Copyright (c) 2014 Rukesh. All rights reserved.
//

import Foundation

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
            self.listOfDates.append(newDay!)
            self.thisWeeksData[newDay!] = getData(newDay!)          }
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


