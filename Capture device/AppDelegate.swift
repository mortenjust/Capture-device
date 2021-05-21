//
//  AppDelegate.swift
//  Capture device
//
//  Created by Morten Just on 5/15/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        ViewController.prepareForDeviceMonitoring()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

