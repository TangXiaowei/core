//
//  HexagramBuilder.swift
//  core
//
//  Created by Li Shi Wei on 10/29/16.
//  Copyright © 2016 li. All rights reserved.
//

import Foundation

public enum EnumSixAnimal : String{
    case QingLong = "青龙"
    case ZhuQue = "朱雀"
    case GouChen = "勾陈"
    case TengShe = "腾蛇"
    case BaiHu = "白虎"
    case XuanWu = "玄武"
    
    public static func list() ->[EnumSixAnimal] {
        return [.QingLong,.ZhuQue,.GouChen,.TengShe,.BaiHu,.XuanWu]
    }
    
    public static func getSixAnimalBy(c:String) -> EnumSixAnimal?{
        switch c {
        case "甲","乙":
            return .QingLong
        case "丙","丁":
            return .ZhuQue
        case "戊":
            return .GouChen
        case "己":
            return .TengShe
        case "庚","辛":
            return .BaiHu
        case "壬","癸":
            return .XuanWu
        default:
            return nil
        }
    }
    
    public func intVal() -> Int{
        switch self {
        case .QingLong:
            return 1
        default:
            return 0
        }
    }
    
    public static func parse(value:Int) -> EnumSixAnimal?{
        switch value {
        case 1:
            return .QingLong
        default:
            return nil
        }
    }
}

public enum EnumLineType : Int{
    case Yin = 8
    case Yang = 7
    case LaoYang = 9
    case LaoYin = 6
}

public enum EnumFiveElement: String{
    case Metal = "金"
    case Wood = "木"
    case Water = "水"
    case Fire = "火"
    case Earth = "土"
}

public enum EnumSixRelation: String{
    case XiongDi = "兄弟"
    case FuMu="父母"
    case QiCai="妻财"
    case ZiSun="子孙"
    case GuanGui="官鬼"
}

public struct DefaultTrigram{
    public var name: String
    public var lines:[EnumLineType]
    public var naJia:[String]
    public var fiveElement: EnumFiveElement
}

public struct DefaultHexagram{
    public var id: Int
    public var name: String
    public var upperPart: DefaultTrigram
    public var lowerPart: DefaultTrigram
    public var side: Bool
    public var place: String
    public var selfIndex: Int
    public var targetIndex: Int
}

public let defaultTrigramList : Dictionary<String,DefaultTrigram> = [
    "天": DefaultTrigram(name: "乾", lines:[.Yang,.Yang,.Yang], naJia:["子", "寅", "辰", "午", "申", "戌"],fiveElement: .Metal),
    "地": DefaultTrigram(name: "坤", lines:[.Yin,.Yin,.Yin], naJia:["未", "巳", "卯", "丑", "亥", "酉"], fiveElement: .Earth),
    "水": DefaultTrigram(name: "坎", lines:[.Yin,.Yang,.Yin], naJia:["寅", "辰", "午", "申", "戌", "子"],fiveElement: .Water),
    "火": DefaultTrigram(name: "离", lines:[.Yang,.Yin,.Yang], naJia:["卯", "丑", "亥", "酉", "未", "巳"],fiveElement: .Fire),
    "风": DefaultTrigram(name: "巽", lines:[.Yin,.Yang,.Yang], naJia:["丑", "亥", "酉", "未", "巳", "卯"],fiveElement: .Wood),
    "雷": DefaultTrigram(name: "震", lines:[.Yang,.Yin,.Yin], naJia:["子", "寅", "辰", "午", "申", "戌"],fiveElement: .Wood),
    "山": DefaultTrigram(name: "艮", lines:[.Yin,.Yin,.Yang], naJia:["辰", "午", "申", "戌", "子", "寅"],fiveElement: .Earth),
    "泽": DefaultTrigram(name: "兑", lines:[.Yang,.Yang,.Yin], naJia:["巳", "卯", "丑", "亥", "酉", "未"],fiveElement: .Metal)
]

public let defaultHexagramList : Array<DefaultHexagram> = [
    DefaultHexagram(id:1, name: "乾", upperPart: defaultTrigramList["天"]!, lowerPart: defaultTrigramList["天"]!, side: true, place: "乾", selfIndex: 6, targetIndex: 3),
    DefaultHexagram(id:2, name:"姤", upperPart: defaultTrigramList["天"]!, lowerPart:defaultTrigramList["风"]!,  side: true, place: "乾", selfIndex: 1, targetIndex: 4),
    DefaultHexagram(id:3, name:"遁", upperPart: defaultTrigramList["天"]!, lowerPart: defaultTrigramList["山"]!,side:true, place:"乾", selfIndex: 2,targetIndex: 5),
    DefaultHexagram(id:4, name:"否", upperPart: defaultTrigramList["天"]!, lowerPart: defaultTrigramList["地"]!,side:true, place:"乾", selfIndex: 3,targetIndex: 6),
    DefaultHexagram(id:5, name:"观", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["地"]!,side:true, place:"乾",selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:6, name:"剥", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["地"]!,side:true, place:"乾", selfIndex: 5, targetIndex:2),
    DefaultHexagram(id:7, name:"晋", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["地"]!,side:true, place:"乾",selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:8, name:"大有", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["天"]!,side:true, place:"乾", selfIndex:3,targetIndex: 6),
    DefaultHexagram(id:9, name:"坎", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["水"]!,side:true, place:"坎",selfIndex: 6, targetIndex:3),
    DefaultHexagram(id:10, name:"节", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["泽"]!,side:true, place:"坎",selfIndex: 1,targetIndex: 4),
    DefaultHexagram(id:11, name:"屯", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["雷"]!,side:true, place:"坎", selfIndex: 2, targetIndex:5),
    DefaultHexagram(id:12, name:"既济", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["火"]!,side:true, place:"坎", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:13, name:"革", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["火"]!,side:true, place:"坎", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:14, name:"丰", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["火"]!,side:true, place:"坎", selfIndex: 5, targetIndex:2),
    DefaultHexagram(id:15, name:"明夷", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["火"]!,side:true, place:"坎", selfIndex:4,targetIndex: 1),
    DefaultHexagram(id:16, name:"师", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["水"]!,side:true, place:"坎", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:17, name:"艮", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["山"]!,side:true, place:"艮", selfIndex: 6, targetIndex:3),
    DefaultHexagram(id:18, name:"贲", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["火"]!,side:true, place:"艮", selfIndex:1, targetIndex:4),
    DefaultHexagram(id:19, name:"大畜", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["天"]!,side:true,place: "艮", selfIndex: 2, targetIndex:5),
    DefaultHexagram(id:20, name:"损", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["泽"]!,side:true,place: "艮", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:21, name:"睽", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["泽"]!,side:true, place:"艮", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:22, name:"履", upperPart: defaultTrigramList["天"]!, lowerPart: defaultTrigramList["泽"]!,side:true, place:"艮", selfIndex: 5, targetIndex:2),
    DefaultHexagram(id:23, name:"中孚", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["泽"]!,side:true,place: "艮",selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:24, name:"渐", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["山"]!,side:true, place:"艮",selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:25, name:"震", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["雷"]!,side: true, place:"震",selfIndex: 6, targetIndex:3),
    DefaultHexagram(id:26, name:"豫", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["地"]!,side:true, place:"震", selfIndex:1, targetIndex:4),
    DefaultHexagram(id:27, name:"解", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["水"]!,side: true, place:"震", selfIndex: 2, targetIndex:5),
    DefaultHexagram(id:28, name:"恒", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["风"]!,side:true, place:"震",selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:29, name:"升", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["风"]!,side:true, place:"震", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:30, name:"井", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["风"]!,side:true, place:"震", selfIndex: 5, targetIndex:2),
    DefaultHexagram(id:31, name:"大过", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["风"]!,side: true, place:"震", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:32, name:"随", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["雷"]!,side:true, place:"震", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:33, name:"巽", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["风"]!,side:false, place:"巽", selfIndex: 6, targetIndex:3),
    DefaultHexagram(id:34, name:"小畜", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["天"]!,side:false,place: "巽", selfIndex:1, targetIndex:4),
    DefaultHexagram(id:35, name:"家人", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["火"]!,side:false, place:"巽", selfIndex: 2, targetIndex:5),
    DefaultHexagram(id:36, name:"益", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["雷"]!,side:false,place: "巽", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:37, name:"无妄", upperPart: defaultTrigramList["天"]!, lowerPart: defaultTrigramList["雷"]!,side:false, place:"巽",selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:38, name:"噬嗑", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["雷"]!,side:false, place:"巽", selfIndex:5, targetIndex:2),
    DefaultHexagram(id:39, name:"颐", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["雷"]!,side: false, place:"巽", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:40, name:"蛊", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["风"]!,side:false, place:"巽", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:41, name:"离", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["火"]!,side:false, place:"离", selfIndex:6, targetIndex:3),
    DefaultHexagram(id:42, name:"旅", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["山"]!,side:false, place:"离", selfIndex: 1,targetIndex: 4),
    DefaultHexagram(id:43, name:"鼎", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["风"]!,side:false, place:"离", selfIndex: 2, targetIndex:5),
    DefaultHexagram(id:44, name:"未济", upperPart: defaultTrigramList["火"]!, lowerPart: defaultTrigramList["水"]!,side:false,place: "离",selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:45, name:"蒙", upperPart: defaultTrigramList["山"]!, lowerPart: defaultTrigramList["水"]!,side:false,place: "离",selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:46, name:"涣", upperPart: defaultTrigramList["风"]!, lowerPart: defaultTrigramList["水"]!,side:false,place: "离",selfIndex: 5, targetIndex:2),
    DefaultHexagram(id:47, name:"讼", upperPart: defaultTrigramList["天"]!, lowerPart: defaultTrigramList["水"]!,side:false, place:"离",selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:48, name:"同人", upperPart: defaultTrigramList["天"]!, lowerPart: defaultTrigramList["火"]!,side:false, place:"离", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:49, name:"坤", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["地"]!,side: false, place:"坤", selfIndex: 6, targetIndex:3),
    DefaultHexagram(id:50, name:"复", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["雷"]!,side:false, place:"坤", selfIndex: 1, targetIndex:4),
    DefaultHexagram(id:51, name:"临", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["泽"]!,side:false, place:"坤",selfIndex: 2, targetIndex:5),
    DefaultHexagram(id:52, name:"泰", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["天"]!,side:false, place:"坤", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:53, name:"大壮", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["天"]!,side: false, place:"坤", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:54, name:"夬", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["天"]!,side: false, place:"坤", selfIndex: 5, targetIndex:2),
    DefaultHexagram(id:55, name:"需", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["天"]!,side: false,place: "坤", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:56, name:"比", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["地"]!,side: false, place:"坤", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:57, name:"兑", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["泽"]!,side: false, place:"兑", selfIndex: 6, targetIndex:3),
    DefaultHexagram(id:58, name:"困", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["水"]!,side: false, place:"兑", selfIndex:1, targetIndex:4),
    DefaultHexagram(id:59, name:"萃", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["地"]!,side: false, place:"兑", selfIndex: 2, targetIndex:5),
    DefaultHexagram(id:60, name:"咸", upperPart: defaultTrigramList["泽"]!, lowerPart: defaultTrigramList["山"]!,side: false, place:"兑", selfIndex: 3, targetIndex:6),
    DefaultHexagram(id:61, name:"蹇", upperPart: defaultTrigramList["水"]!, lowerPart: defaultTrigramList["山"]!,side: false, place:"兑", selfIndex:4, targetIndex:1),
    DefaultHexagram(id:62, name:"谦", upperPart: defaultTrigramList["地"]!, lowerPart: defaultTrigramList["山"]!,side: false, place:"兑", selfIndex: 5, targetIndex:2),
    DefaultHexagram(id:63, name:"小过", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["山"]!,side: false, place:"兑", selfIndex: 4, targetIndex:1),
    DefaultHexagram(id:64, name:"归妹", upperPart: defaultTrigramList["雷"]!, lowerPart: defaultTrigramList["泽"]!,side: false, place:"兑", selfIndex: 3, targetIndex:6),
]




