//
//  ViewController.swift
//  AppleCalanderEventManager
//
//  Created by Nilesh Vernekar on 18/11/21.
//

import UIKit
import EventKitUI
import EventKit
import Klendario

class ViewController: UIViewController {

    @IBOutlet weak var deleteAllBtn: UIButton!
    @IBOutlet weak var tableView: UITableView?
//    let events = EKEventStore()
    fileprivate var events = [EKEvent]()
    fileprivate static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.deleteAllBtn.addTarget(self, action: #selector(didtapdelete), for: .touchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didtapAdd))
    }

    fileprivate func setup() {
        getEvents()
    }
    fileprivate func getEvents() {
        // Getting events
        Klendario.getEvents(from: Date() -  60*60*360, to: Date() + 360*60) { (events, error) in
            guard let events = events else {
                print("error getting events: \(String(describing: error))")
                return
            }
            
            self.events = events
            self.tableView?.reloadData()
        }
    }
    @IBAction func reloadEvents(_ sender: UIButton) {
        getEvents()
    }
}

extension ViewController: EKEventViewDelegate , UINavigationControllerDelegate{
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
  @objc  func didtapdelete() {
      for event in events {
          event.delete()
      }
      getEvents()
    
    }
    
    
}
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = "\(ViewController.formatter.string(from: event.startDate)) - \(ViewController.formatter.string(from: event.endDate))"
        return cell
    }
}


extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
