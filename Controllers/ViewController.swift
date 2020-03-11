//
//  ViewController.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/25/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // array with suitable parameters
    private var notes: [Note] = [Note]()
    // key word for userDefault
    // just flag
    var flag: Bool = true
    
    
    var refreshControl: UIRefreshControl?
    
    
    let tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.masksToBounds = true
        table.backgroundColor = UIColor.white
        return table
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        refreshing()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
    
        
        title = "Tasks"
        self.navigationController?.navigationBar.tintColor = UIColor.black
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.init(name: "Quicksand-Bold", size: 40)!]
        
        let sortImage = UIImage(named: "sort")!
        let makeNoteImage = UIImage(named: "makeNote")!
        let sortButton = UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(sortStatuses))
        sortButton.tintColor = UIColor.black
        let createTaskButton = UIBarButtonItem(image: makeNoteImage, style: .plain, target: self, action: #selector(goToCreatePage))
        createTaskButton.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItems = [createTaskButton, sortButton]
        self.navigationController?.navigationBar.prefersLargeTitles = true
    
        setTableView()
    }
    
    //sort array
    @objc func sortStatuses() {
        if flag {
            notes.sort { (this, that) -> Bool in
                return this.status < that.status
            }
            flag = false
            tableView.reloadData();
        }
        else {
            notes.sort { (this, that) -> Bool in
                return this.status > that.status
            }
            flag = true
            tableView.reloadData();
        }
    }

    @objc func goToCreatePage() {
        let registration = CreateViewController()
        let transition = CATransition()
        
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(registration, animated: false)
    }
    
    // set up tool bar items
    func setToolBar() {
        let sortImage = UIImage(named: "sort")!
        self.navigationController?.isToolbarHidden = false
        
        self.toolbarItems = [UIBarButtonItem(image: sortImage, style: .plain, target: self, action: #selector(sortStatuses)),
                             UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                             UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreatePage))]
    }
    
    // set up all table view settings
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.lightGray
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableView)
  
        setupBounds()
        addRefreshView()
    }
    
    // function ti add refresh view
    func addRefreshView() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(refreshing), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        
    }
    
    // download elements after refresh
    @objc func refreshing() {
        if let kek = retrieveData() {
            for i in 0..<kek.count {
                updateData(fromIndex: kek.reversed()[i].id, index: i);
            }
            notes = (retrieveData()?.reversed())!
        }
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    // get status in order to know about task
    func GetStatusFromInt(intStatus: String) -> String {
        
        switch intStatus {
        case "0":
            return "new"
        case "1":
            return "in the process"
        case "2":
            return "done"
        default:
            return "error in View Controller"
        }
    }
    
    // set up constrains for main table view
    func setupBounds() {
        tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // settings for cell of table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {fatalError("тут какая-то дичь")}
        tableView.backgroundColor = UIColor.white
        cell.nameLabel.text = notes[indexPath.row].nameOfTask
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDateString: String = dateFormatter.string(from: Date())
        if currentDateString > notes[indexPath.row].currentDate {
            cell.dateOfCreation.text = String(notes[indexPath.row].currentDate)
        } else {
            cell.dateOfCreation.text = String(notes[indexPath.row].date)
        }
        
        cell.comments.text = notes[indexPath.row].comments
        cell.status.text = notes[indexPath.row].status
        return cell
    }
    
    
    // delete row
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let rateAction = UITableViewRowAction(style: .destructive, title: "Delete" , handler: { (action: UITableViewRowAction, indexPath:IndexPath) -> Void in
//            delete from notes
             self.notes.remove(at: indexPath.row)
            
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
             
             //We need to create a context from this container
             let managedContext = appDelegate.persistentContainer.viewContext
             
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            fetchRequest.predicate = NSPredicate(format: "id = %@", "\(indexPath.row)")
            
             do
             {
                 let test = try managedContext.fetch(fetchRequest)
                 let objectToDelete = test[0] as! NSManagedObject
                 managedContext.delete(objectToDelete)
                 
                 do{
                     try managedContext.save()
                        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    if let kek = self.retrieveData() {
                               for i in 0..<kek.count {
                                self.updateData(fromIndex: kek.reversed()[i].id, index: i);
                               }
                        self.notes = (self.retrieveData()?.reversed())!
                           }
                 }
                 catch
                 {
                     print(error)
                 }
                 
             }
             catch
             {
                 print(error)
             }
        })
        
        return [rateAction];
    }
    
    func retrieveData() -> [Note]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
    
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
    func updateData(fromIndex: Int, index: Int){

         //As we know that container is set up in the AppDelegates so we need to refer that container.
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

         let managedContext = appDelegate.persistentContainer.viewContext

         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Task")
         fetchRequest.predicate = NSPredicate(format: "id == \(fromIndex)")
         do
         {
             let test = try managedContext.fetch(fetchRequest)

                 let objectUpdate = test[0] as! NSManagedObject
                 objectUpdate.setValue(index, forKey: "id")
                 do{
                     try managedContext.save()
                 }
                 catch
                 {
                     print(error)
                 }
             }
         catch
         {
             print(error)
         }

     }

    
    // go to information about task
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let information = InformationViewController(with: notes[indexPath.row], index: String(notes[indexPath.row].id))
        self.navigationController?.pushViewController(information, animated: true)
    }
    
    // height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

