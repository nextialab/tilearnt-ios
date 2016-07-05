//
//  ViewController.swift
//  Today I Learnt
//
//  Created by Nelson Iván González on 4/18/16.
//  Copyright © 2016 Nelson Iván González. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var edit: UITextField!
    var knowledgeDisk = [NSManagedObject]()
    var knowledgeCloud = [KnowledgeModel]()
    var fromDisk = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadFromDisk()
    }
    
    func loadFromDisk() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Knowledge")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            knowledgeDisk = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func loadFromCloud(sender: AnyObject) {
        KnowledgeInterface.getKnowledges({ data, response, error in
            self.fromDisk = false
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 200 {
                if let receivedData = data {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(receivedData, options: NSJSONReadingOptions()) as? NSArray
                        if let results = json {
                            for result in results {
                                if let dict = (result as? NSDictionary) {
                                    let knowledge = KnowledgeModel(text: dict["knowledge"] as? String, published: true)
                                    self.knowledgeCloud.append(knowledge)
                                } else {
                                    print("Not a dictionary")
                                }
                            }
                        }
                    } catch let error as NSError {
                        print("Could not convert \(error), \(error.userInfo)")
                    }
                }
            } else {
                print("Error getting: \(response)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.table.reloadData()
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        table.delegate = self
        edit.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            addKnowledge(text)
        }
        textField.text = ""
        textField.resignFirstResponder()
        return false
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (fromDisk) {
            let published = knowledgeDisk[indexPath.item].valueForKey("global") as! Bool
            return !published
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .Default, title: "Publish", handler: { action, indexPath in
            let globalKnowledge = self.knowledgeDisk[indexPath.item].valueForKey("text") as! String
            KnowledgeInterface.postKnowledge(globalKnowledge, handler: { data, response, error in
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 200 {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    self.knowledgeDisk[indexPath.item].setValue(true, forKey: "global")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                } else {
                    print("Error posting: \(response)")
                }
                dispatch_async(dispatch_get_main_queue(), {
                    tableView.editing = false
                    tableView.reloadData()
                })
            })
            
        })]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fromDisk ? knowledgeDisk.count : knowledgeCloud.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "KnowledgeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! KnowledgeTableViewCell
        if (fromDisk) {
            cell.label.text = (knowledgeDisk[indexPath.item].valueForKey("text") as! String)
            let published = knowledgeDisk[indexPath.item].valueForKey("global") as! Bool
            cell.published.alpha = published ? 1.0 : 0.0
        } else {
            cell.label.text = knowledgeCloud[indexPath.item].text
            cell.published.alpha = 0.0
        }
        return cell
    }

    func addKnowledge(newKnowledge: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Knowledge", inManagedObjectContext: managedContext)
        let entityKnowledge = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        let today = NSDate()
        entityKnowledge.setValue(newKnowledge, forKey: "text")
        entityKnowledge.setValue(today, forKey: "date")
        entityKnowledge.setValue(false, forKey: "global")
        do {
            try managedContext.save()
            knowledgeDisk.insert(entityKnowledge, atIndex: 0)
            table.reloadData()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}

