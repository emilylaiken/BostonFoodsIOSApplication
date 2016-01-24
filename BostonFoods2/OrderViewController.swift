//
//  OrderViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit
import SystemConfiguration

class OrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    //Picker object for community center input
    @IBOutlet weak var myPicker: UIPickerView!
    //Data for picker
    var pickerData: [String] = [String]()
    //Segmented control object for payment method input
    @IBOutlet weak var paymentMethodControl: UISegmentedControl!
    @IBOutlet weak var paymentMethod: UISegmentedControl!
    //Text field objects for remaining inputs
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var classic: UITextField!
    @IBOutlet weak var protein: UITextField!
    @IBOutlet weak var produce: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var responseText: UITextField!
    //Submit button object
    @IBOutlet weak var submitButton: UIButton!
    
    //Upon loading of view, set up view, picker, and text fields
    override func viewDidLoad() {
        super.viewDidLoad()
        createEvent()
        //Set up picker
        self.myPicker.delegate = self
        self.myPicker.dataSource = self
        //Input data into picker
        pickerData = ["Blackstone", "Cambridge"]
        //Set up text fields
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.phoneNumber.delegate = self
        self.email.delegate = self
        self.classic.delegate = self
        self.protein.delegate = self
        self.produce.delegate = self
        self.notes.delegate = self
    }
    
    //Causes keyboard for text fields to dissapear when "done" button is clicked
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //Outputs number of columns of data for picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    //Outputs number of rows of data for picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent compnent: Int) -> Int {
        return pickerData.count
    }
    //Outputs the data to return for the row and component that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    /*When submit button is clicked, checks for user errors in input, then (if erros) alerts user of errors in their input or (if no errors) calls method to post data to server */
    @IBAction func onSubmitClick(sender: AnyObject) {
        var success = true;
        var alertMessage = ""
        //test for internet connection
        if !(isConnectedToNetwork()) {
            alertMessage = "Your device must be connected to the network to submit this form."
            success = false;
        }
        //test for empty required fields
        else if (firstName.text == "" || lastName.text == "" || phoneNumber.text == "" || email.text == "") {
            alertMessage = "Please fill out all fields."
            success = false;
        }
        //make sure at least one box has an order in it
        else if (classic.text == "" && protein.text == "" && produce.text == "") {
            alertMessage = "Please purchase at least one box."
            success = false;
        }
        //make sure email has an @ character and a . character
        else if (email.text!.characters.indexOf("@") == nil || email.text!.characters.indexOf(".") == nil) {
            alertMessage = "Please submit a valid email."
            success = false;
        }
        //make sure phone number has at least 10 digits
        else if (phoneNumber.text!.characters.count < 10) {
            alertMessage = "Please submit a valid phone number, with an area code."
            success = false;
        }
        else {
            let letters = NSCharacterSet.letterCharacterSet()
            let phoneNumberRange = phoneNumber.text!.rangeOfCharacterFromSet(letters)
            let classicRange = classic.text!.rangeOfCharacterFromSet(letters)
            let proteinRange = protein.text!.rangeOfCharacterFromSet(letters)
            let produceRange = produce.text!.rangeOfCharacterFromSet(letters)
            let ranges = [classicRange, proteinRange, produceRange]
            //make sure phone number has no letter characters
            if let test = phoneNumberRange {
                alertMessage = "Please submit a valid phone number."
                success = false;
            }
            //make sure number of boxes has no letter characters
            else {
                for (var i=0; i<3; i++) {
                    let range = ranges[i]
                    if let test = range {
                        alertMessage = "Please submit a valid number of boxes."
                        success = false;
                    }
                }
            }
        }
        //Upon failure, generate alert telling user their error
        if (success == false) {
            let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        //Upon sucess, post data to server
        else {
            postToServer()
            //create notifications
            var nextDeliveryDateString = ""
            var dateRawText = ""
            //URL of text file containing next delivery date
            let urlString = "https://www.dropbox.com/sh/0p31gpjkb2ifu8p/AADls6G9Dbmi_pnjCWiAI5hva/date.txt?raw=1"
            let url = NSURL(string: urlString)!
            do {
                dateRawText = try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            }
            catch {
                print("Problem dowloading data for text from URL.")
            }
            nextDeliveryDateString = dateRawText as String
            let stringToDateFormatter = NSDateFormatter()
            stringToDateFormatter.dateFormat = "yyyy MM d"
            let dateAsNSDate = stringToDateFormatter.dateFromString(nextDeliveryDateString)!
            let dateToDayOfWeekFormatter = NSDateFormatter()
            dateToDayOfWeekFormatter.dateFormat = "EEEE"
            let dayOfWeek = dateToDayOfWeekFormatter.stringFromDate(dateAsNSDate) //Word for day of week delivery is on
            
            //Create notification 1 week before delivery
            let beginningOfWeekDate = dateAsNSDate.dateByAddingTimeInterval(-7*24*60*60)
            let beginningOfWeekNotification = UILocalNotification()
            beginningOfWeekNotification.fireDate = beginningOfWeekDate
            beginningOfWeekNotification.alertBody = "Boston Foods delivery on " + dayOfWeek
            beginningOfWeekNotification.alertAction = "open"
            beginningOfWeekNotification.soundName = UILocalNotificationDefaultSoundName
            beginningOfWeekNotification.userInfo = ["CustomField1": "w00t"]
            UIApplication.sharedApplication().scheduleLocalNotification(beginningOfWeekNotification)
            
            //Create notification 1 day before delivery
            let dayBeforeDate = dateAsNSDate.dateByAddingTimeInterval(-1*24*60*60)
            let dayBeforeNotification = UILocalNotification()
            dayBeforeNotification.fireDate = dayBeforeDate
            dayBeforeNotification.alertBody = "Boston Foods delivery tomorrow"
            dayBeforeNotification.alertAction = "open"
            dayBeforeNotification.soundName = UILocalNotificationDefaultSoundName
            dayBeforeNotification.userInfo = ["CustomField1": "w00t"]
            UIApplication.sharedApplication().scheduleLocalNotification(dayBeforeNotification)
            
            //Create notification morning of delivery
            let morningDate = dateAsNSDate.dateByAddingTimeInterval(-1*3600)
            let morningNotification = UILocalNotification()
            morningNotification.fireDate = morningDate
            morningNotification.alertBody = "Boston Foods delivery this afternoon"
            morningNotification.alertAction = "open"
            morningNotification.soundName = UILocalNotificationDefaultSoundName
            morningNotification.userInfo = ["CustomField1": "w00t"]
            UIApplication.sharedApplication().scheduleLocalNotification(morningNotification)
        }
    }
    
    //Posts data to google doc located at given URL
    func postToServer() {
        let url: NSURL = NSURL(string: "https://docs.google.com/a/college.harvard.edu/forms/d/1PG-Hy_e4HEIT363WbvRtSTQZuXdfUD-G33dWuFsl2oU/formResponse")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        //extract community center response and pair it with entry ID
        let communityCenterData = "entry.1325520490=" + pickerData[myPicker.selectedRowInComponent(0)]
        //extract name response and pair it with entry ID
        let nameData = "entry.253468771=" + firstName.text! + " " + lastName.text!
        //extract phone number response and pair it with entry ID
        let phoneNumberData = "entry.152871700=" + phoneNumber.text!
        //extract email response and pair it with entry ID
        let emailData = "entry.919897530=" + email.text!
        //extract order response and pair it with entry ID
        var orderData = "entry.726427604="
        if (classic.text! != "") {
            orderData = orderData + " " + classic.text! + " Classic Boxes"
        }
        if (protein.text! != "") {
            orderData = orderData + " " + protein.text! + " Protein Boxes"
        }
        if (produce.text! != "") {
            orderData = orderData + " " + produce.text! + " Produce Boxes"
        }
        //extract payment method response and pair it with entry ID
        let paymentMethodData = "entry.1191027088=" + paymentMethodControl.titleForSegmentAtIndex(paymentMethodControl.selectedSegmentIndex)!
        //extract notes response and pair it with entry ID
        let notesData = "entry.235215105=" + notes.text!
        //generate body of HTTP request
        let bodyData = communityCenterData + "&" + nameData + "&" + phoneNumberData + "&" + emailData + "&" + orderData + "&" + paymentMethodData + "&" + notesData
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        //Send HTTP request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) in
        }
        
    }
    
    func createEvent() {
        let notification = UILocalNotification()
        notification.alertBody = "Title" // text that will be displayed in the notification
        //notification.alertAction = "Open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        let dateFormatter = NSDateFormatter()
        //Date format with standard calendar set-up and 24-hour time
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myStartDate = NSDate()
        //Use date formatter to generate NSDate objects from strings
        //let startDate = dateFormatter.dateFromString(myStartDate)
        notification.fireDate = myStartDate // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": 1] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    //Returns true if device is connected to network (wifi or cell), else false
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

