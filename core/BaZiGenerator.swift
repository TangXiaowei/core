//
//  BaZiGenerator.swift
//  core
//
//  Created by Li Shi Wei on 9/24/16.
//  Copyright © 2016 li. All rights reserved.
//

import Foundation

public class BaZiGenerator
{
    public func getBeginDaYunAgeMonth(date:Date, isMale:Bool, yearEraIndex: Int) -> (age:Int, months:Int, days:Int)
    {
         //三天一岁，1天4个月，1个时辰10天
        let hoursQiYun = abs(BaZiGenerator.getBeginYunHours(date: date, isMale: isMale, yearEraIndex: yearEraIndex))
        let days = Double(hoursQiYun)/24
        let age = days/3
        let month = (Int(days)%3) * 4
        //*2是一个时辰，＊10是一个时辰10天
        let day = Int(days)%24/2 * 10
        
        return (Int(age),month,day)
    }
    
    //大运顺排逆排
    public class func isForward(yearEraIndex:Int, isMale:Bool) -> Bool {
    //"癸甲乙丙丁戊己庚辛壬",单数为阳
        return (yearEraIndex % 2 == 1 && isMale) || (yearEraIndex % 2 == 0 && !isMale)
    }
    
    public class func getPairJie(date:Date) -> (SolarTerm,SolarTerm) {
        let pairSolarTerm = LunarSolarTerm.getSolarTerm(date.year, month: date.month)
        var beginSolarTerm : SolarTerm! = nil
        var endSolarTerm : SolarTerm! = nil
        
        if date.isLessThan(pairSolarTerm.solarTerm1.date){
            endSolarTerm = pairSolarTerm.solarTerm1
        }
        else{
            beginSolarTerm = pairSolarTerm.solarTerm1
        }
        
        if endSolarTerm == nil {
            let st = LunarSolarTerm.getSolarTerm(date.year, month: date.month+1)
            endSolarTerm = st.solarTerm1
        }else{
            let st = LunarSolarTerm.getSolarTerm(date.year, month: date.month-1)
            beginSolarTerm = st.solarTerm1
        }
        
        return (beginSolarTerm,endSolarTerm)
    }
    
    public class func getBeginYunHours(date:Date, isMale:Bool, yearEraIndex: Int) -> Int {
        let pair = BaZiGenerator.getPairJie(date: date)
        if BaZiGenerator.isForward(yearEraIndex: yearEraIndex, isMale: isMale)
        {
            return Date.hoursBetween(date1: pair.1.date, date2: date)
        }
        else{
            return Date.hoursBetween(date1: date, date2: pair.0.date)
        }
    }
}
