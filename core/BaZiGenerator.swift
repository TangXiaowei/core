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
    
    let birthday: Date
    let isMale : Bool
    
    var _allEraObjs: Dictionary<EraObject,Array<EraObject>>!
    
    public init(date: Date, isMale: Bool) {
        
        self.birthday = date
        self.isMale = isMale
        
    }
    
    public var allEraObjs: Dictionary<EraObject,Array<EraObject>>!
        {
        get {
            if _allEraObjs == nil {
                _allEraObjs = getYunFlowYears()
            }
            return _allEraObjs
        }
    }
    
    public func getSelectedYear(selectedYear:Int) -> (currentYearEraObj:EraObject, yunObjectObj:EraObject)!
    {
        for daYunObj in allEraObjs.keys {
            if daYunObj.year <= selectedYear && selectedYear < daYunObj.year+10 {
                for yearObj in allEraObjs[daYunObj]! {
                    if yearObj.year == selectedYear {
                        return (yearObj ,daYunObj)
                    }
                }
            }
        }
        return nil
        
    }
    
    public func getYunList() -> Array<EraObject>
    {
        return allEraObjs.keys.sorted(by: { $0.year < $1.year })
    }
    
    public func getYearListByYun(yunObjectObj:EraObject?) -> Array<EraObject>?
    {
        if let o = yunObjectObj{
            return allEraObjs[o]
        }
        return nil
    }
    
    public func getCurrentYear() -> (currentYearEraObj:EraObject, yunObjectObj:EraObject)!
    {
        let year = Date().year
        return getSelectedYear(selectedYear: year)
    }
    
    private func getYunFlowYears() -> Dictionary<EraObject,Array<EraObject>>
    {
        let solarDate = LunarSolarTerm(paramDate: self.birthday)
        
        let yearEraIndex = solarDate.getChineseEraOfYear()
        let monthEraIndex = solarDate.getChineseEraOfMonth()
        
        let isForward = BaZiGenerator.isForward(yearEraIndex: yearEraIndex, isMale: isMale)
        let daYunObj = BaZiGenerator.getBeginDaYunAgeMonth(date: self.birthday, isForward: isForward )
        
        var daYunList = Dictionary<EraObject,Array<EraObject>>()
        
        for i in 1...10{
            var tempInt = 0
            if isForward {
                tempInt = BaZiGenerator.fixEraIndex(index:monthEraIndex + i)
            }
            else{
                tempInt = BaZiGenerator.fixEraIndex(index:monthEraIndex - i)
            }
            
            let strYun = LunarSolarTerm.getEraText(tempInt)
            let beginYunYearIndex = daYunObj.months > 0 ? daYunObj.age+1 : daYunObj.age
            
            var flowYearList = Array<EraObject>()
            let birthdayYear = self.birthday.year
            
            let yearPreFix = (i-1)*10
            for j in 0...9
            {
                
                let flowYear = birthdayYear + beginYunYearIndex + j + yearPreFix
                let strFlowYearText = LunarSolarTerm.getEraText(yearEraIndex+j+beginYunYearIndex+yearPreFix)
                let result = EraObject(c: strFlowYearText.c, t: strFlowYearText.t, year: flowYear)
                flowYearList.append(result)
            }
            
            let result = EraObject(c:strYun.c, t:strYun.t, year: birthdayYear + beginYunYearIndex + yearPreFix)
            
            daYunList.updateValue(flowYearList, forKey: result)
        }
        
        return daYunList
    }
    
    public class func fixEraIndex(index:Int) -> Int{
        let yearIndex = 59
        return index < 0 ? (yearIndex + index) : index
    }
    
    public class func getBeginDaYunAgeMonth(date:Date, isForward:Bool) -> (age:Int, months:Int)
    {
        //三天一岁，1天4个月，1个时辰10天
        let hoursQiYun = abs(BaZiGenerator.getBeginYunHours(date: date, isForward: isForward))
        let days = Double(hoursQiYun)/24
        let age = days/3
        //3天没除尽的天，20天的话余2天
        let month = (Int(days)%3) * 4
        //天是除24来的，除24也有余数，余数按小时算
        let monthExt = hoursQiYun%24/2*10/30
        //*2是一个时辰，＊10是一个时辰10天
        
        return (Int(age),month+monthExt)
    }
    
    public class func isForward(isMale:Bool, isYangYearCelestialStem: Bool)->Bool{
        return (isYangYearCelestialStem && isMale) || (!isYangYearCelestialStem && !isMale)
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
            let tempDate = date.plusMonths(1)
            let st = LunarSolarTerm.getSolarTerm(tempDate.year, month: tempDate.month)
            endSolarTerm = st.solarTerm1
        }else{
            let tempDate = date.plusMonths(1)
            let st = LunarSolarTerm.getSolarTerm(tempDate.year, month: tempDate.month)
            beginSolarTerm = st.solarTerm1
        }
        
        return (beginSolarTerm,endSolarTerm)
    }
    
    public class func getBeginYunHours(date:Date, isForward: Bool) -> Int {
        let pair = BaZiGenerator.getPairJie(date: date)
        if isForward
        {
            return Date.hoursBetween(date1: date, date2: pair.1.date)
        }
        else{
            return Date.hoursBetween(date1: pair.0.date, date2: date)
        }
    }
    
    static let celestialStemName : String = "甲乙丙丁戊己庚辛壬癸"
    static let terrestialBranchName : String = "子丑寅卯辰巳午未申酉戌亥"
    
    public class func getXunAndKongByEraText(c:String,t:String) -> (xunT:String, kong1:String,kong2:String)
    {
        let ci = celestialStemName.firstIndexOf(str: c)
        var ti = terrestialBranchName.firstIndexOf(str: t)
        if(ci >= ti)
        {
            ti+=12;
        }
        
        let result = ti - ci;
        var xunTIndex = result
        if result == 12 {
            xunTIndex = 0
        }
        let xunT = terrestialBranchName.subString(beginIndex: xunTIndex, endIndex: xunTIndex+1)
        let kong1 = terrestialBranchName.subString(beginIndex: result-2, endIndex: result-1)
        let kong2 = terrestialBranchName.subString(beginIndex: result-1, endIndex: result)
        return (xunT,kong1,kong2)
    }
    
    public class func getRelationBetweenCandT(c:String, t:String) -> String! {
        
        let twelveGrows = ApplicationResource.sharedInstance.getTwelveGrows()
        
        let cInfo = ApplicationResource.sharedInstance.getCelestialPropertyBy(c)
        let cBeginT = cInfo["Grow"]!
        
        var cBeginIndex = terrestialBranchName.firstIndexOf(str: cBeginT)
        let tBeginIndex = terrestialBranchName.firstIndexOf(str: t)
        
        if cInfo["Property"] == "阳" {
            
            for s in twelveGrows{
                if cBeginIndex > 11 {
                    cBeginIndex = 0
                }
                if tBeginIndex == cBeginIndex {
                    return s.description
                }
                cBeginIndex += 1
            }
        }
        else{
            for s in twelveGrows{
                if cBeginIndex < 0 {
                    cBeginIndex = 11
                }
                if tBeginIndex == cBeginIndex {
                    return s.description
                }
                cBeginIndex -= 1
            }
        }
        
        return nil
    }
    
    private func getThreeSuitExceptName(t1:String, t2:String) -> String? {
        
        let instance = ApplicationResource.sharedInstance
        //取三合局
        let threeSuitNamesT1 = instance.getThreeSuitNamesByTerrestial(t1)
        let threeSuitNamesT2 = instance.getThreeSuitNamesByTerrestial(t2)
        
        //三合局里有没有第二个地支
        if threeSuitNamesT1.contains(t2)
        {
            //三合局里的剩的那个地支
            let exceptName = threeSuitNamesT1.filter({x in return (x != t1 && x != t2)})
            
            return exceptName[0]
        }
        
        return nil
    }
    
    private func is4Wang(t:String) -> Bool
    {
        let instance = ApplicationResource.sharedInstance
        let tArray = instance.get4WangTerrestrials()
        
        return tArray.contains(where: {x in
            let str = x.description
            return str! == t ? true : false
        })
    }
    
    public func getJiaGong(eraText1:String,eraText2:String) -> String {
        
        guard !eraText1.isEmpty && !eraText2.isEmpty else {
            return ""
        }
        
        let c1 = eraText1.subString(beginIndex: 0, endIndex:1)
        let t1 = eraText1.subString(beginIndex: 1)
        
        let c2 = eraText2.subString(beginIndex: 0, endIndex:1)
        let t2 = eraText2.subString(beginIndex: 1)
        
        if c1 == c2 && t1 != t2 {
            
            //三合局的夹拱
            if let suitT1 = getThreeSuitExceptName(t1: t1, t2: t2)
            {
                if is4Wang(t: suitT1) {
                    return suitT1
                }
            }
            
            //判断供的地支
            let indexT1 = LunarSolarTerm.terrestialBranchName.firstIndexOf(str: t1)
            let indexT2 = LunarSolarTerm.terrestialBranchName.firstIndexOf(str: t2)
            
            if indexT1 + 2 == indexT2 {
                return LunarSolarTerm.terrestialBranchName.subStringAt(indexOf: indexT1+1)
            }
            if indexT1 - 2 == indexT2 {
                return LunarSolarTerm.terrestialBranchName.subStringAt(indexOf: indexT2+1)
            }
            if (indexT1 == 11 && indexT2 == 1) || (indexT1==1 && indexT2 == 11) {
                return LunarSolarTerm.terrestialBranchName.subStringAt(indexOf: 0)
            }
            if (indexT1 == 10 && indexT2 == 0) || (indexT2==10 && indexT1 == 10) {
                return LunarSolarTerm.terrestialBranchName.subStringAt(indexOf: 11)
            }
        }
        
        return ""
    }
}

public class EraObject : NSObject {
    
    private override init()
    {
        super.init()
    }
    
    convenience init(c:String,t:String,year:Int)
    {
        self.init()
        self.c = c
        self.t = t
        self.year = year
    }
    
    public var c : String!
    public var t : String!
    public var year : Int!
}
