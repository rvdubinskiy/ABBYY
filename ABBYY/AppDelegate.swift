//
//  AppDelegate.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/25/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        let viewController = ViewController()
        
        window?.makeKeyAndVisible()
        let attrs = [
            NSAttributedString.Key.font: UIFont.init(name: "Quicksand-Regular", size: 24)!
        ]

        UINavigationBar.appearance().titleTextAttributes = attrs
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        if url.scheme == "kek"
        {
            let taskID = Int(url.absoluteString.components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: ""))!;
            var dates = retrieveData()!
            dates = dates.reversed()
            
            let note = Note(nameOfTask: dates[taskID].nameOfTask, date: dates[taskID].date, status: GetStatusFromInt(intStatus: dates[taskID].status), comments: dates[taskID].comments, id: dates[taskID].id, currentDate: dates[taskID].currentDate);
            
            (self.window?.rootViewController as! UINavigationController).pushViewController(InformationViewController(with: note, index: String(dates[taskID].id) ), animated: true)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NewPS(name: "ABBYY");
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    MARK: - Core Data retrieveData
    
    func retrieveData() -> [Note]? {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        
        let managedContext = self.persistentContainer.viewContext
        
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let result = try managedContext.fetch(fetchRequest)
            var notes = [Note]();
            for data in result as! [NSManagedObject] {
                let note = Note(nameOfTask: data.value(forKey: "name") as! String, date: data.value(forKey: "time") as! String, status: GetStatusFromInt(intStatus: data.value(forKey: "status") as! String), comments: data.value(forKey: "comments") as! String, id: data.value(forKey: "id") as! Int, currentDate: data.value(forKey: "current_date") as! String);
                
                notes.append(note);
            }
            return notes;
        } catch {
            print("Failed")
        }
        return nil;
    }
    
    func GetStatusFromInt(intStatus: String) -> String {
        
        switch intStatus {
        case "0":
            return "new"
        case "1":
            return "in the process"
        case "2":
            return "done"
        default:
            return "\(intStatus)"
        }
    }
}

