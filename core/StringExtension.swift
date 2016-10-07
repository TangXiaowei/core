//
//  StringExtension.swift
//  core
//
//  Created by Li Shi Wei on 9/30/16.
//  Copyright © 2016 li. All rights reserved.
//

import Foundation

public extension String{
    
    public func subString(beginIndex:Int) -> String
    {
        return self.substring(from: self.index(self.startIndex, offsetBy: beginIndex))
    }
    
    public func subStringAt(indexOf:Int) -> String{
        return self.subString(beginIndex: indexOf, endIndex: indexOf+1)
    }
    
    public func subString(beginIndex:Int,endIndex:Int) -> String
    {
        if endIndex > self.characters.count {
            return ""
        }else{
            return self.substring(with: Range<String.Index>(self.characters.index(self.startIndex, offsetBy: beginIndex) ..< self.characters.index(self.startIndex, offsetBy: endIndex)))
        }
    }
    
    public func firstIndexOf(str:String) -> Int
    {
        let cIndex = self.range(of: str)?.lowerBound
        return self.distance(from: self.startIndex, to: cIndex!)
    }
    
    public func lastIndexOf(str:String) -> Int
    {
        let cIndex = self.range(of: str)?.upperBound
        return self.distance(from: self.startIndex, to: cIndex!)
    }
}
