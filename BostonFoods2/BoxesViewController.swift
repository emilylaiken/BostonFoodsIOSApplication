//
//  BoxesViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit
import SystemConfiguration
var boxType = "" //Once user selects a box by clicking on a button, will identify that box

class BoxesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //User clicks on "classic" button
    @IBAction func onClassicClicked(sender: AnyObject) {
        if !isConnectedToNetwork() {
            displayNoConnectionAlert()
        }
        else {
            boxType = "classic"
        }
    }
    
    //User clicks on "protein" button
    @IBAction func onProteinClicked(sender: AnyObject) {
        if !isConnectedToNetwork() {
            displayNoConnectionAlert()
        }
        else {
            boxType = "protein"
        }
    }
    
    //User clicks on "produce" button
    @IBAction func onProduceClicked(sender: AnyObject) {
        if !isConnectedToNetwork() {
            displayNoConnectionAlert()
        }
        else {
            boxType = "produce"
        }
    }
    
    //Displays no-connection alert
    func displayNoConnectionAlert() {
        let alertMessage = "Your device must be connected to the network to access this page."
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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




