//
//  ApplicationResource.swift
//  core
//
//  Created by Li Shi Wei on 9/29/16.
//  Copyright © 2016 li. All rights reserved.
//

import Foundation

let _SingletonSharedInstance = ApplicationResource()

public class ApplicationResource: NSObject {
    
    public class var sharedInstance : ApplicationResource {
        return _SingletonSharedInstance
    }
    
    internal fileprivate(set) var jsonSource : Dictionary<String,AnyObject>! = nil
    
    fileprivate(set) var defaultDataDic : Dictionary<String,AnyObject>! = nil
    
    override init() {
        
        super.init()
        
        let bundle : Bundle = Bundle.main
        let jsonPath = bundle.path(forResource: "core.framework/CelestialStem&Terrestrial.json", ofType: nil)
        let jsonData = try? Data.init(contentsOf: URL(fileURLWithPath: jsonPath!))
        
        do
        {
            jsonSource = try JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as! Dictionary<String,AnyObject>
        
            let defaultDataPath = bundle.path(forResource: "core.framework/DefaultData", ofType: "plist")
            defaultDataDic = NSMutableDictionary(contentsOfFile: defaultDataPath!) as! Dictionary<String,AnyObject>

        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    public var celestialStem : Dictionary<String,AnyObject>
        {
        get{
            return jsonSource["天干"] as! Dictionary<String,AnyObject>
        }
    }
    
    public var terrestialBranch : Dictionary<String,AnyObject>
        {
        get{
            return jsonSource["地支"] as! Dictionary<String,AnyObject>
        }
    }
    
    public func getCelestialPropertyBy(_ name: String) -> Dictionary<String,String> {
        return celestialStem[name] as! Dictionary<String,String>
    }
    
    public func getTerrestialPropertyBy(_ name: String) -> Dictionary<String,AnyObject> {
        return terrestialBranch[name] as! Dictionary<String,AnyObject>
    }
    
    public func getUIColorByCelestial(_ name:String) -> UIColor
    {
        let strColor = getCelestialPropertyBy(name)["Color"]
        return colorDictionary[strColor!]!
    }
    
    public func getUIColorByTerrestial(_ name:String) -> UIColor
    {
        let strColor = getTerrestialPropertyBy(name)["Color"]
        return colorDictionary[strColor as! String]!
    }
    
    public func getHiddenStemsByTerrestial(_ name:String) -> String
    {
        return getTerrestialPropertyBy(name)["HiddenSteam"] as! String
    }
    
    public let colorDictionary : Dictionary<String,UIColor> = [
        "Red":UIColor.red,
        "Yellow":UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1),
        "Brown":UIColor.brown,
        "Green":UIColor(red: 34/255, green: 193/255, blue: 34/255, alpha: 1),
        "Blue":UIColor.blue
    ]
    
    public func getSixRelationByRiZhu(_ riZhu:String, celestialStem:String) -> String
    {
        //阳，阴
        let riZhuInfo = getCelestialPropertyBy(riZhu)
        let riZhuYinYang = riZhuInfo["Property"]!
        let riZhuFiveElement=riZhuInfo["FiveElement"]!
        
        let csInfo = getCelestialPropertyBy(celestialStem)
        let csYinYang = csInfo["Property"]
        let csFiveElement = csInfo["FiveElement"]
        
        let dicEnhance = defaultDataDic["FiveElementEnhance"] as! Dictionary<String,AnyObject>
        let riZhuEhanceFiveElement = dicEnhance[riZhuFiveElement] as! String
        let riZhuConsumeFiveElement = dicEnhance[riZhuEhanceFiveElement] as! String
        
        let dicControl = defaultDataDic["FiveElementControl"] as! Dictionary<String,AnyObject>
        let riZhuControledFiveElement = dicControl[riZhuEhanceFiveElement] as! String
        
        let sixRelationDic = defaultDataDic["日主"] as! Dictionary<String,AnyObject>
        
        let flag = riZhuYinYang == csYinYang ? "同性":"异性"
        
        if riZhuFiveElement == csFiveElement {
           return sixRelationDic["equal"]![flag] as! String
        }else if csFiveElement == riZhuEhanceFiveElement{
            return sixRelationDic["enhance"]![flag] as! String
        }else if csFiveElement == riZhuConsumeFiveElement{
            return sixRelationDic["consume"]![flag] as! String
        }else if csFiveElement == riZhuControledFiveElement{
            return sixRelationDic["control"]![flag] as! String
        }else{
            return sixRelationDic["support"]![flag] as! String
        }

    }
}
