//
//  CloudViewController.swift
//  Today I Learnt
//
//  Created by Nelson Iván González on 7/5/16.
//  Copyright © 2016 Nelson Iván González. All rights reserved.
//

import UIKit

class CloudViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var knowledgeCloud = [KnowledgeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCloud()
        table.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Load pieces of knowledge from the cloud. It also converts the json response to KnowledgeModel objects
     */
    func loadFromCloud() {
        KnowledgeInterface.getKnowledges({ data, response, error in
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knowledgeCloud.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CloudKnowledge"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! KnowledgeTableViewCell
        cell.label.text = knowledgeCloud[indexPath.item].text
        return cell
    }

}
