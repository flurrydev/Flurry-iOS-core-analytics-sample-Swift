//
//  FlurryCoreConfiguration.swift
//  FlurryCoreAnalyticsSampleApp_Swift
//
//  Created by Yilun Xu on 9/28/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit

class FlurryCoreConfiguration: NSObject {
    let fileName = "/setting.plist"
    static let sharedInstance = FlurryCoreConfiguration()
    var info: NSMutableDictionary!
    var defaultInfo: NSMutableDictionary!
    
    override private init(){
        let defaultPath = Bundle.main.path(forResource: "FlurryCoreConfig", ofType: "plist")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths.object(at: 0) as! NSString
        let path = documentDirectory.appendingPathComponent(fileName)
        self.defaultInfo = NSMutableDictionary(contentsOfFile: defaultPath!);
        self.info = NSMutableDictionary(contentsOfFile: path)
    }
    
    func getDefaultValue(key: String) -> AnyObject {
        let output: AnyObject = defaultInfo.object(forKey: key)! as AnyObject
        print("get default value  key is \(key), value is \(output)")
        return output
    }
    
    func getValue(key: String) -> AnyObject {
        let output: AnyObject = info.object(forKey: key)! as AnyObject
        print("get value  key is \(key), value is \(output)")
        return output
    }
    
    func isKeyExist(key: String) -> Bool {
        return info[key] != nil
    }
    
    func removeKey(filePath: String ,key: String) -> (Void){
        self.info.removeObject(forKey: key)
        if info.write(toFile: filePath, atomically: true) {
            print("write succeess")
        } else {
            print("write failure")
        }
    }
    
    func setValue(filePath: String, key: String, data: AnyObject) {
        info.setObject(data, forKey: key as NSCopying)
        if info.write(toFile: filePath, atomically: true) {
            print("write succeess")
        } else {
            print("write failure")
        }
    }
    
}
