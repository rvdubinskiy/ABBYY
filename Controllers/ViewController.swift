//
//  ViewController.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/25/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // array with suitable parameters
    private var notes: [Note] = [Note]()
    // key word for userDefault
    var userKey = UserKey()
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
        self.navigationController?.navigationBar.prefersLargeTitles = true

        setToolBar()
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
        refreshing()
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
        notes = [Note]()
        var dates = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: userKey.key) as? [[String]]

        if(dates != nil) {
            let number = dates?.count
            for i in 0..<number! {
                var newStatus = String()
                newStatus = GetStatusFromInt(intStatus: dates![i][4])
                notes.append(Note(nameOfTask: dates![i][1], date: dates![i][3], status: newStatus, comments: dates![i][2], id: dates![i][0], currentDate: dates![i][5]))
            }
            notes = notes.reversed()
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
            return "nnnnew"
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

            var index = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: self.userKey.key) as? [[String]] ?? [["empty"]]
            index.reverse()
            index.remove(at: indexPath.row)
            index.reverse()
                
            self.notes.remove(at: indexPath.row)
            
            var arrayEl = [[String]]()
            
            
            for i in 0..<index.count {
                var temp = [String]()
                temp.append(index[i][0])
                temp.append(index[i][1])
                temp.append(index[i][2])
                temp.append(index[i][3])
                temp.append(index[i][4])
                temp.append(index[i][5])
                
                arrayEl.append(temp)
            }
            UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.set(arrayEl, forKey: self.userKey.key)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        })
        return [rateAction]
    }
    
    // go to information about task
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let information = InformationViewController(with: notes[indexPath.row], index: notes[indexPath.row].id)
        self.navigationController?.pushViewController(information, animated: true)
    }
    
    // height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

