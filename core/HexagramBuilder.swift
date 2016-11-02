//
//  HexagramBuilder.swift
//  core
//
//  Created by Li Shi Wei on 10/29/16.
//  Copyright © 2016 li. All rights reserved.
//

import Foundation

public class HexagramBuilder{
    
    public static func getHexagramBy(name:String) -> Hexagram?
    {
        for h in defaultHexagramList {
            if h.name == name {
                return Hexagram(defaultHexagram: h)
            }
        }
        
        return nil
    }
    
    public static func getHexagramBy(sourceName:String, targetName:String?) -> (Hexagram?,Hexagram?)
    {
        let hexagram = getHexagramBy(name: sourceName)!
    
        if let tn = targetName{
            
            let targetHexagram = defaultHexagramList.first { (h) -> Bool in
                return h.name == targetName!
                }!
            
            var targetLines = targetHexagram.lowerPart.lines
            targetLines.append(contentsOf: targetHexagram.upperPart.lines)

            for i in 0...5 {
                if hexagram.lines[i].lineType != targetLines[i] {
                    if targetLines[i] == EnumLineType.Yin
                    {
                        hexagram.lines[i].lineType = EnumLineType.LaoYang
                    }
                    else if targetLines[i] == EnumLineType.Yang
                    {
                        hexagram.lines[i].lineType = EnumLineType.LaoYin
                    }
                }
            }
            
             return (hexagram,Hexagram(defaultHexagram: targetHexagram, placeName: hexagram.defaultValue.place))
        }
        
        return (hexagram,nil)
    }
    
    public static func getHexagramBy(lines:[EnumLineType]) -> (Hexagram?,Hexagram?){
        
       return getHexagramBy(lines: lines[5],lines[4],lines[3],lines[2],lines[1],lines[0])
    }
    
    public static func getHexagramBy(lines:EnumLineType...) -> (Hexagram?,Hexagram?){
        if lines.count != 6 {
            return (nil,nil)
        }
        
        let hasChangedHexagram = lines.filter { (type) -> Bool in
            if type == EnumLineType.LaoYang || type == EnumLineType.LaoYin
            {
                return true
            }
            return false
            }.count > 0
        
        var hexagram : Hexagram? = nil
        var defaultHexagramChanged : DefaultHexagram? = nil
        
        for h in defaultHexagramList {
            var list = h.lowerPart.lines
            list.append(contentsOf: h.upperPart.lines)
            
            var count = 0
            var countChanged = 0
            for i in 0...5{
                let lineType = lines[i] == .LaoYin ? .Yin : (lines[i] == .LaoYang ? .Yang : lines[i])
                
                if lineType == list[i] {
                    count += 1
                }
                
                if hasChangedHexagram {
                    let lineType = lines[i] == .LaoYin ? .Yang : (lines[i] == .LaoYang ? .Yin : lines[i])
                    
                    if lineType == list[i] {
                        countChanged += 1
                    }
                }
            }
            
            if count == 6 {
                hexagram = Hexagram(defaultHexagram: h)
                
                for i in 0...5{
                    hexagram?.lines[i].lineType = lines[i]
                }
            }
            
            if countChanged == 6{
                defaultHexagramChanged = h
            }
        }
        
        if hasChangedHexagram
        {
            return (hexagram,Hexagram(defaultHexagram: defaultHexagramChanged!, placeName: (hexagram?.defaultValue.place)!))
        }
        else
        {
            return (hexagram,nil)
        }
    }
    
}

public class Hexagram
{
    public init (defaultHexagram: DefaultHexagram)
    {
        defaultValue = defaultHexagram
        placeName = defaultValue.place
    }
    
    private var placeName: String
    
    public init (defaultHexagram: DefaultHexagram, placeName:String)
    {
        defaultValue = defaultHexagram
        self.placeName = placeName
    }
    
    public var defaultValue: DefaultHexagram
    
    public lazy var fiveElement:EnumFiveElement? = {
        let value = defaultTrigramList.values.first(where:{ trigram -> Bool in
            return trigram.name == self.placeName
        })
        
        return value!.fiveElement
    }()
    
    public lazy var lines: Array<Line> = {
        
        var lines = Array<Line>()
        
        let lowerPart = self.defaultValue.lowerPart
        let naJiaLowerPart = lowerPart.naJia[0...2]
        
        for i in 0...2{
            lines.append(self.createLine(terrestrial: naJiaLowerPart[i], lineType: lowerPart.lines[i]))
        }
        
        let upperPart = self.defaultValue.upperPart
        let naJiaUpperPart = upperPart.naJia[3...5]
        for i in 3...5{
            lines.append(self.createLine(terrestrial: naJiaUpperPart[i], lineType: upperPart.lines[i-3]))
        }
        
        return lines
    }()
    
    public lazy var linesWithAttached: Array<Line> = {
        
        let lineList = self.lines
        
        var sixRelations = [EnumSixRelation.FuMu,.GuanGui,.QiCai,.XiongDi,.ZiSun]
        for l in lineList{
            if sixRelations.contains(l.sixRelation)
            {
                let index = sixRelations.index(of: l.sixRelation)!
                sixRelations.remove(at: index)
            }
        }
        
        if sixRelations.count > 0{
            
            //易林补遗
            let hexagram = defaultHexagramList.first(where:{ item -> Bool in
                return item.name == self.defaultValue.place
            })!
            
            let lowerPart = hexagram.lowerPart
            let naJiaLowerPart = lowerPart.naJia[0...2]
            
            for i in 0...2{
                let line = self.createLine(terrestrial: naJiaLowerPart[i], lineType: lowerPart.lines[i])
                if sixRelations.contains(line.sixRelation)
                {
                    lineList[i].attached = line
                }
            }
            
            let upperPart = hexagram.upperPart
            let naJiaUpperPart = upperPart.naJia[3...5]
            for i in 3...5{
                let line = self.createLine(terrestrial: naJiaUpperPart[i], lineType: upperPart.lines[i-3])
                if sixRelations.contains(line.sixRelation)
                {
                    lineList[i].attached = line
                }
            }
            
            return lineList
        }
        
        return self.lines
    }()
    
    private func createLine(terrestrial:String, lineType:EnumLineType) -> Line{
        
        let line = Line()
        line.terrestrial = terrestrial
        line.lineType = lineType
        
        let strFE = ApplicationResource.sharedInstance.getTerrestialPropertyBy(line.terrestrial)["FiveElement"]?.description
        line.fiveElement = EnumFiveElement(rawValue: strFE!)
        
        let fiveElementPlace = self.fiveElement!
        line.sixRelation = SixRelationHelper.parseSixRelationBy(hexagramFiveElement: fiveElementPlace, lineFiveElement: line.fiveElement)
        
        return line
    }
}

public class Line{
    
    public var lineType : EnumLineType!
    public var fiveElement: EnumFiveElement!
    public var sixRelation: EnumSixRelation!
    public var terrestrial: String!
    
    public var attached: Line!
}
