//
//  AppDelegate.swift
//  FunctionAdventureGame
//
//  Created by Xuan Liu on 10/21/18.
//  Copyright © 2018 Xuan Liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var levelRecordDictionary: NSMutableDictionary = NSMutableDictionary()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/levelRecord.plist"

        /*
         Instantiate an NSMutableArray object and initialize it with the contents of the
         RecipesILike.plist file from the Document directory on the user's iOS device.
         */
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        /*
         IF the optional variable arrayFromFile has a value, THEN
         RecipesILike.plist exists in the Document directory and the array is successfully created
         ELSE
         read RecipesILike.plist from the application's main bundle.
         */
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            
            // CountryCities.plist exists in the Document directory
            levelRecordDictionary = dictionaryFromFileInDocumentDirectory
            
        } else {
            /******************************************************************************************
             RecipesILike.plist does not exist in the Document directory; Read it from the main bundle.
             
             This will be the case only when the app is launched for the very first time. Thereafter,
             RecipesILike.plist will be written to and read from the iOS device's Document directory.
             
             For readability purposes, the plist file contains " | " to separate the data values.
             Since URLs cannot have spaces and names should not begin or end with a space,
             we clean the RecipesILike.plist data by replacing all occurrences of " | " with "|"
             *****************************************************************************************/
            
            // Obtain the file path to the plist file in the main bundle (project folder)
            let plistFilePathInMainBundle: String? = Bundle.main.path(forResource: "levelRecord", ofType: "plist")
            
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            // Store the object reference into the instance variable
            levelRecordDictionary = dictionaryFromFileInMainBundle!
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // Define the file path to the CountryCities.plist file in the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/levelRecord.plist"
        
        // Write the NSMutableDictionary to the CountryCities.plist file in the Document directory
        levelRecordDictionary.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        print("write into list")
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/levelRecord.plist"
        
        // Write the NSMutableDictionary to the CountryCities.plist file in the Document directory
        levelRecordDictionary.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        print("write into list")
    }


}

