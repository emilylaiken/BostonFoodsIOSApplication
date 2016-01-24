//
//  LocationsViewController.swift
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class LocationsViewController: UIViewController, MKMapViewDelegate {
    
    var nextDeliveryDateString = "" //Will contain the next delivery date for display (parsed from URL)
    @IBOutlet weak var blackstoneMap: MKMapView!
    @IBOutlet weak var blackstoneTextBox: UITextView!
    
    //Sets up view and map functions when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get next delivery date from URL
        var dateAsString = ""
        var dateRawText = ""
        //URL for next delivery date
        var urlString = "https://www.dropbox.com/sh/0p31gpjkb2ifu8p/AADls6G9Dbmi_pnjCWiAI5hva/date.txt?raw=1"
        let url = NSURL(string: urlString)!
        do {
            dateRawText = try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("Problem dowloading data for text from URL.")
        }
        //Parse date into NSDate
        nextDeliveryDateString = dateRawText as String
        let stringToDateFormatter = NSDateFormatter()
        stringToDateFormatter.dateFormat = "yyyy MM d"
        let dateAsNSDate = stringToDateFormatter.dateFromString(nextDeliveryDateString)!
        let dateToStringFormatter = NSDateFormatter()
        dateToStringFormatter.dateFormat = "EEEE MMMM d"
        dateAsString = dateToStringFormatter.stringFromDate(dateAsNSDate)
        //Set up text boxes
        if chosenLocation == "blackstone" {
            blackstoneTextBox.text = "City: Boston \n\n Address: 50 W Brookline Street \n\n Next Delivery: " + dateAsString + ", 4:00 - 6:00 pm"
        }
        else {
            blackstoneTextBox.text = "City: Cambridge \n\n Address: 5 Callendar Street \n\n Next Delivery: " + dateAsString + ", 5:00 - 7:00 pm"
        }
        blackstoneTextBox.font = UIFont(name: "Helvetica", size: 16)
        //Set up map
        blackstoneMap.delegate = self
        //Map is centered on Boston
        let initialLocation = CLLocation(latitude: 42.3627751, longitude: -71.093104)
        let regionRadius: CLLocationDistance = 3000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            blackstoneMap.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(initialLocation)
        //Locations array contains location information for the two drop-off locations
        let locations = [
            ["name" : "Blackstone Community Center", "latitude" : 42.3403500, "longitude" : -71.073104],
            ["name" : "Cambridge Community Center", "latitude" : 42.3653400,"longitude" : -71.1115720]
        ]
        var annotations = [MKPointAnnotation]()
        //Create MKPointAnnotation objects for each drop-off location and store them in the annotations array
        for dictionary in locations {
            let latitude = CLLocationDegrees(dictionary["latitude"] as! Double)
            let longitude = CLLocationDegrees(dictionary["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = dictionary["name"] as! String
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotations.append(annotation)
        }
        //Add annotations to map
        blackstoneMap.addAnnotations(annotations)
    }
    
    //Sets up info buttons on map pin callouts
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.enabled = true
            pin!.canShowCallout = true
            let btn = UIButton(type: UIButtonType.DetailDisclosure)
            pin!.rightCalloutAccessoryView = btn
        } else {
            pin!.annotation = annotation
        }
        return pin
    }
    
    //When the info button on a map pin callout is clicked, sends the user to the appropriate URL in Apple Maps
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            //Info button is clicked on Blackstone pin callout
            if (annotationView.annotation!.title! == "Blackstone Community Center") {
                app.openURL(NSURL(string: "http://maps.apple.com/?q=50+W+Brookline+Street+Boston+MA")!)
            }
            //Info button is clicked on Cambridge pin callout
            else {
                app.openURL(NSURL(string: "http://maps.apple.com/?q=5+Callender+Street+Cambridge+MA")!)
            }
        }
    }
    
    //"Add to calendar" button action for Blackstone Community Center
    @IBAction func onBlackstoneCalendarClick(sender: AnyObject) {
        let myTitle = "Boston Foods Delivery at Blackstone Community Center"
        //Start: December 11 at 4:00 pm
        let myStartDate = nextDeliveryDateString + " 16:00:00"
        //End: December 11 at 6:00 pm
        let myEndDate = nextDeliveryDateString + " 18:00:00"
        generateEvent(myTitle, myStartDate: myStartDate, myEndDate: myEndDate)
    }
    
    //"Add to calendar" button action for Cambridge Community Center
    @IBAction func onCambridgeCalendarClick(sender: AnyObject) {
        let myTitle = "Boston Foods Delivery at Cambridge Community Center"
        //Start: December 11 at 5:00 pm
        let myStartDate = nextDeliveryDateString + " 17:00:00"
        //End: December 11 at 7:00 pm
        let myEndDate = nextDeliveryDateString + " 19:00:00"
        generateEvent(myTitle, myStartDate: myStartDate, myEndDate: myEndDate)
    }
    
    //Sets up a calendar event
    func generateEvent(title: String, myStartDate: String, myEndDate: String) {
        let eventStore = EKEventStore()
        let dateFormatter = NSDateFormatter()
        //Date format with standard calendar set-up and 24-hour time
        dateFormatter.dateFormat = "yyyy MM d HH:mm:ss"
        //Use date formatter to generate NSDate objects from strings
        let startDate = dateFormatter.dateFromString(myStartDate)
        let endDate = dateFormatter.dateFromString(myEndDate)
        //Errror in setting up EKEvent object
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in self.createEvent(eventStore, title: title, startDate: startDate!, endDate: endDate!)
            })
        }
        //EKEvent object set up successfully, event can be created
        else {
            createEvent(eventStore, title: title, startDate: startDate!, endDate: endDate!)
        }
    }
    
    //Adds a calendar event to the iPhone's native calendar
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        //Strings that will be used in pop-up informing user of success or failure of adding event to calendar
        var alertMessage = ""
        var alertTitle = ""
        //Event successfuly added to calendar
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            //Set up pop-up informing user of success
            alertMessage = "Event was added to your calendar."
            alertTitle = "Success"
        }
        //Error while adding event to calendar
        catch {
            //Set up pop-up informing user of failure
            alertMessage = "Sorry, there was an error. Please try again."
            alertTitle = "Error"
        }
        //Generate pop-up informing user of success or failure of adding event to calendar
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
