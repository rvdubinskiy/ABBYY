//
//  TodayViewController.swift
//  ABBYY ext
//
//  Created by Roman Dubinskiy on 6/4/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData


class TodayViewController: UIViewController, NCWidgetProviding {
    var taskId = 0;
    lazy var button: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(goToMainApp), for: .touchDown)
        return button
    }()
    // label which called up a name of task
    var nameOfTaskLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    
    
    // label which called up comments for task
    var commentsLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    // label which called up time
    var time: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    // label which called up a status
    var status: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(nameOfTaskLabel)
        view.addSubview(time)
        view.addSubview(commentsLabel)
        view.addSubview(status)
        view.addSubview(button)
        setupSettingsForElements()
        
        setupConstraints()
    }
    
    @objc func goToMainApp() {
        
        let url: URL? = URL(string: "kek://\(taskId)")!
        if let appurl = url { self.extensionContext!.open(appurl, completionHandler: nil) }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        view.addSubview(nameOfTaskLabel)
        view.addSubview(time)
        view.addSubview(commentsLabel)
        view.addSubview(status)
        view.addSubview(button)
        setupSettingsForElements()
        
        setupConstraints()
        
        completionHandler(NCUpdateResult.newData)
    }
    var persistentContainer: NSPersistentContainer = {

        let container = NewPS(name: "ABBYY");
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // set up settings main frame
    func setupSettingsForElements() {
        var note = Note(nameOfTask: "default", date: "default", status: "default", comments: "default", id: 0, currentDate: "default");
        nameOfTaskLabel.font = UIFont.boldSystemFont(ofSize: 25)
        time.font = UIFont.systemFont(ofSize: 15)
        commentsLabel.font = UIFont.systemFont(ofSize: 15)
        status.font = UIFont.systemFont(ofSize: 15)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDateString: String = dateFormatter.string(from: Date())
        var tempString = String()
        var timeForCompare = String()
        
        var dates = retrieveData();

        // тут сортировка для отображения ближайшей задачи, у которой не стоит статус "done"
        for item in 0..<dates!.count {
            // тут я сравниваю по дням + статус
            if dates![item].date >= tempString && dates![item].status == "new"{
                // тут сравниваю по времени(часы, минуты и секунды), чтобы получить свежий невыолненный таск
                if dates![item].currentDate > timeForCompare {
                    tempString = dates![item].date
                    timeForCompare = dates![item].currentDate
                    note = SetParameters(tempString: tempString, timeForCompare: timeForCompare, dates: dates!, item: item)
                }
            } else if dates![item].currentDate >= tempString && dates![item].status == "in the proccess" {
                // тут аналогично, но для другого статуса.
                if dates![item].date > timeForCompare {
                    tempString = dates![item].currentDate
                    timeForCompare = dates![item].date
                    note = SetParameters(tempString: tempString, timeForCompare: timeForCompare, dates: dates!, item: item)
                }
            } else {
                note = Note(nameOfTask: "default", date: "default", status: "default", comments: "default", id: 0, currentDate: "default");
            }
        }
        if dates!.count != 0 {

            if currentDateString > note.currentDate && note.status == "new"{
                nameOfTaskLabel.text = note.nameOfTask
                time.text = currentDateString
                commentsLabel.text = note.comments
                status.text = note.status
                taskId = note.id;
            } else if currentDateString > note.currentDate && note.status == "in the process" {
                nameOfTaskLabel.text = note.nameOfTask
                time.text = currentDateString
                commentsLabel.text = note.comments
                status.text = note.status
                taskId = note.id;
            } else if currentDateString == note.currentDate && (note.status == "new" || note.status == "in the process") {
                nameOfTaskLabel.text = note.nameOfTask
                time.text = note.date
                commentsLabel.text = note.comments
                status.text = note.status
                taskId = note.id;
            } else {
                nameOfTaskLabel.text = "dude"
                time.text = "trust"
                commentsLabel.text = "no"
                status.text = "one!"
                taskId = 0;
            }
        } else {
            nameOfTaskLabel.text = "dude"
            time.text = "trust"
            commentsLabel.text = "no"
            status.text = "oneры"
            taskId = 0;
        }

        
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func retrieveData() -> [Note]? {
        let managedContext = self.persistentContainer.viewContext;
        
    
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
    
    // тут считаю максимально подходящую
    func SetParameters(tempString: String, timeForCompare: String, dates: [Note],  item: Int) -> Note {
        let note = Note(nameOfTask: dates[item].nameOfTask, date: dates[item].date, status: dates[item].status, comments: dates[item].comments, id: dates[item].id, currentDate: dates[item].currentDate);
        return note
    }
    
    // get status from string format as int
    func GetStatusFromInt(intStatus: String) -> String {
        
        switch intStatus {
        case "0":
            return "new"
        case "1":
            return "in the process"
        case "2":
            return "done"
        default:
            return "error in Today Extension"
        }
    }
    
    func setupConstraints() {
        // bounds for button
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true

        // bounds for name of task label
        nameOfTaskLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        nameOfTaskLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        nameOfTaskLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameOfTaskLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 5/10).isActive = true


        // bounds for time label
        time.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10).isActive = true
        time.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        time.heightAnchor.constraint(equalToConstant: 30).isActive = true
        time.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 3/10).isActive = true

        // bounds for comments label
        commentsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        commentsLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        commentsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        commentsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true

        // bounds for status label
        status.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10).isActive = true
        status.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        status.heightAnchor.constraint(equalToConstant: 30).isActive = true
        status.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 3/10).isActive = true
    }

}
