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
    var knowledge = [NSManagedObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Knowledge")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            knowledge = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knowledge.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "KnowledgeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! KnowledgeTableViewCell
        cell.label.text = (knowledge[indexPath.item].valueForKey("text") as! String)
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
            //knowledge.append(entityKnowledge)
            knowledge.insert(entityKnowledge, atIndex: 0)
            table.reloadData()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}

