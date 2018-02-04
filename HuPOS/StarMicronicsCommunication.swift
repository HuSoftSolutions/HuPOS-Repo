//
//  StarMicronicsCommunication.swift
//  HuSoftPOS
//
//  Created by Cody Husek on 1/26/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import CoreBluetooth

final class BTCommunication {
    
    private init(){
        
    }
    
    private static func BTEnabled() -> Bool {
        if let pref = UserDefaults.standard.value(forKey: "BTDevicePreference") as? Bool{
            return pref
        }
        return true
    }
    
    public static func openDrawer(){
        if(BTEnabled()){
            let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let builder: ISCBBuilder = StarIoExt.createCommandBuilder(delegate.emulation)
            builder.beginDocument()
            builder.appendPeripheral(SCBPeripheralChannel.no1)
            builder.endDocument()
            
            let commands = builder.commands.copy() as! Data
            var commandsArray: [UInt8] = [UInt8](repeating: 0, count: commands.count)
            let port = SMPort.getPort(delegate.BTDevice, nil, 10000)
            
            commands.copyBytes(to: &commandsArray, count: commands.count)
            
            var error: NSError?
            var total: UInt32 = 0
            while total < UInt32(commands.count) {
                let written: UInt32 = port!.write(commandsArray, total, UInt32(commands.count) - total, &error)
                if error != nil { break }
                total += written
            }
            SMPort.release(port)
        }
    }
    
    public static func print(){
        if(BTEnabled()){
            let encoding: String.Encoding
            encoding = String.Encoding.utf8
            
            let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let builder: ISCBBuilder = StarIoExt.createCommandBuilder(delegate.emulation)
            builder.beginDocument()
            builder.appendAlignment(SCBAlignmentPosition.center)
            builder.append((
                "HuSoft Solutions\n" +
                "SUCCESSFUL PRINT\n"
                ).data(using: encoding))
            builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
            builder.endDocument()
            
            let commands = builder.commands.copy() as! Data
            var commandsArray: [UInt8] = [UInt8](repeating: 0, count: commands.count)
            let port = SMPort.getPort(delegate.BTDevice, nil, 10000)
            commands.copyBytes(to: &commandsArray, count: commands.count)
            
            var error: NSError?
            var total: UInt32 = 0
            while total < UInt32(commands.count) {
                let written: UInt32 = port!.write(commandsArray, total, UInt32(commands.count) - total, &error)
                if error != nil {
                    break
                }
                total += written
            }
            SMPort.release(port)
        }
    }
    
}
