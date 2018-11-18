//
//  EventsTableViewController.swift
//  CompSciClubs
//
//  Created by Lindsey Gray on 11/13/18.
//  Copyright © 2018 Lindsey Gray. All rights reserved.
//
// Displays a list of all events

import UIKit

class EventsTableViewController: UITableViewController, EventCellDelegate {
    
    var events: [Event]?
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewInit()
    }
        
    func viewInit() {
        // format appearence of dates
        dateFormatter.dateFormat = "EE MMM dd, yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        
        tableView.register(EventCell.self, forCellReuseIdentifier: "eventCell")
        tableView.rowHeight = 150

        EventsApi.getEvents() { data, error in
            switch(data, error){
            case(nil, .some(let error)):
                print(error)
            case(.some(let data), nil):
                self.events = data as? [Event]
                self.tableView.reloadData()
            default:
                print("Error getting events")
                
            }
        }
        
        // Provided code
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func saveEventTapped(_ sender: EventCell) {
        print("Save Tapped!")
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        events?[indexPath.row].printEvent()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let events = self.events else {
            return UITableViewCell()
        }
        
        let event = events[indexPath.row]
        
        // the identifier is like the type of the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        
        cell.delegate = self
        cell.name = event.name
        cell.eventImage = event.mainPhoto ?? UIImage(named: "testImage")
        cell.startTime = event.startTime
        
        return cell
    }

 /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let events = self.events else {
            return UITableViewCell()
        }
        
        let event = events[indexPath.row]
        
        // the identifier is like the type of the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCall") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "eventCell")
        
        // Set cell values
        cell.textLabel?.text = event.name ?? ""
        cell.detailTextLabel?.text = "Start Time: \(event.startTime.map{self.dateFormatter.string(from: $0)} ?? "")"
/*
            "End Time: \(event.endTime.map{self.dateFormatter.string(from: $0)} ?? "") \n"
            "Location: \(event.location ?? "")\n"
        
            "Club: \(event.club ?? "")\n"
            "Description: \(event.details ?? "")"
 */
        
        event.printEvent()
        
        return cell
    }
 */
    

    // Other provided functions to override
    
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }
     */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
