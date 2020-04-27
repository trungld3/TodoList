//
//  AppDelegate.swift
//  TodoList
//
//  Created by TrungLD on 4/22/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit

import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          //  print(Realm.Configuration.defaultConfiguration.fileURL)
         
            
            
            do {
                _    = try Realm()
               
                }
         catch {
                print("error appDelegate \(error)")
            }
          
            
            
              return true
    //        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
           
          
        }
    
}
