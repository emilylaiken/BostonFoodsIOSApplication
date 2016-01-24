//
//  SelectLocationViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit
import SystemConfiguration

class AboutViewController: UIViewController {
    
    @IBOutlet weak var textBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Adjusts scroll view for text box so it starts at the top
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textBox.setContentOffset(CGPointZero, animated: false)
        textBox.setContentOffset(CGPointZero, animated: false)
    }
    
}



