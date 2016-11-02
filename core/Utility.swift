//
//  FiveElementHelper.swift
//  core
//
//  Created by Li Shi Wei on 10/29/16.
//  Copyright © 2016 li. All rights reserved.
//

import Foundation

public class FiveElementHelper
{
    public static func restrain(_ obj: EnumFiveElement) -> EnumFiveElement
    {
        switch obj
        {
        case .Metal:
            return EnumFiveElement.Fire
        case .Wood:
            return EnumFiveElement.Metal
        case .Water:
            return EnumFiveElement.Earth
        case .Fire:
            return EnumFiveElement.Water
        default:
            return EnumFiveElement.Wood
        }
    }
    
    public static func support(_ obj: EnumFiveElement) -> EnumFiveElement
    {
        switch (obj)
        {
        case .Metal:
            return EnumFiveElement.Earth
        case .Wood:
            return EnumFiveElement.Water
        case .Water:
            return EnumFiveElement.Metal
        case .Fire:
            return EnumFiveElement.Wood
        default:
            return EnumFiveElement.Fire
        }
    }
}

public class SixRelationHelper
{
    public static func parseSixRelationBy(hexagramFiveElement: EnumFiveElement, lineFiveElement: EnumFiveElement) -> EnumSixRelation
    {
        if hexagramFiveElement == lineFiveElement {
            return EnumSixRelation.XiongDi
        }
        else if FiveElementHelper.restrain(hexagramFiveElement) == lineFiveElement{
            return EnumSixRelation.GuanGui}
        else if FiveElementHelper.support(hexagramFiveElement) == lineFiveElement{
            return EnumSixRelation.FuMu}
        else if hexagramFiveElement == FiveElementHelper.restrain(lineFiveElement){
            return EnumSixRelation.QiCai}
            //if (guaProperty == WuXingSupport(yaoProperty))
        else{
            return EnumSixRelation.ZiSun
        }
    }
}

public class SixAnimalsHelper{
    
    public static func getSixAnimalsBy(c:String) ->[EnumSixAnimal]{
        let animal = EnumSixAnimal.getSixAnimalBy(c: c)
        if let a = animal{
            let index = EnumSixAnimal.list().index(of: a)!
            
            var array = Array<EnumSixAnimal>()
            for i in index...5{
                array.insert(EnumSixAnimal.list()[i], at: array.count)
            }
            if index > 0{
                for i in 0...index-1{
                    array.insert(EnumSixAnimal.list()[i], at: array.count)
                }
            }
            
            return array
        }
        
        return []
    }
}
