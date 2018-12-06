//
//  CalendarViewController.swift
//  SimpleCal
//
//  Created by Srivarshini Ananta on 11/24/18.
//  Copyright © 2018 Srivarshini Ananta. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, EditEventDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarListedEvents: UITableView!

    @IBOutlet weak var addEventButton: UIBarButtonItem!
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide add event for users
        if User.currentUser?.club == nil {
            addEventButton.isEnabled = false
            addEventButton.tintColor = UIColor.white
        }
        
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        
        calendarListedEvents.delegate = self
        calendarListedEvents.dataSource = self
        dateFormatter.dateFormat = "h:mm a"
        getEvents()
        self.calendar.reloadData()
    }
    
    var events: [Event]? = []
    var allEvents: [Event]? = []
    
    // Display the events for that particular date on the event board below the calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
        events = allEvents?.filter { event in
            Calendar.current.isDate(date, equalTo: event.startTime ?? Date(), toGranularity:.day)
        }
        
        calendarListedEvents.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return allEvents?.filter { event in
            Calendar.current.isDate(date, equalTo: event.startTime ?? Date(), toGranularity:.day)}.count ?? 0
    }
    
    @IBAction func addEvent(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "editEventViewController") as! EditEventViewController
        viewController.delegate = self
        viewController.event = nil
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func editEventCompleted(event: Event?) {
        getEvents()
    }
    
    func editEventStarted() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getEvents() {
        EventsApi.getEventsIDs(startDate: nil, limit: nil) { data, error in
            switch(data, error){
            case(nil, .some(let error)):
                print(error)
            case(.some(let data), nil):
                if let eventIds = data as? [String?] {
                    for id in eventIds {
                        EventsApi.getEvent(id: id ?? "") { data, error in
                            switch(data, error){
                            case(nil, .some(let error)):
                                print(error)
                            case(.some(let data), nil):
                                self.allEvents?.append(data as! Event)
                                self.calendar.reloadData()
                            default:
                                print("Error getting event \(id ?? "")")
                            }
                        }
                    }
                }
            default:
                print("Error getting events")
                
            }
        }
    }
    
}

// TableView funtions
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let events = self.events else {
            return UITableViewCell()
        }
        
        let event = events[indexPath.row]
        
        // the identifier is like the type of the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarEventCell", for: indexPath) as! EventCell
        
        cell.initEventCell(name: event.name, startTime: event.startTime, club: event.club, image: nil, dateFormat: "h:mm a")  //FIXME: debugging
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "eventDetailsViewController") as! EventDetailsViewController
        viewController.event = self.events.map { $0[indexPath.row] }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

