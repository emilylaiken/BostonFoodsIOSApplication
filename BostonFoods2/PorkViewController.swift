//
//  PorkViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit

class PorkViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Picker object for number of servings
    @IBOutlet weak var myPicker: UIPickerView!
    //Data for picker object
    var pickerData: [String] = [String]()
    //Text field objects for ingredient quantities
    @IBOutlet weak var groundPorkOutput: UITextField!
    @IBOutlet weak var hamburgerBunsOutput: UITextField!

    //Sets up view and picker object upon loading of view
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up picker
        self.myPicker.delegate = self
        self.myPicker.dataSource = self
        //Input data into picker
        pickerData = ["1", "2", "3", "4", "5", "6", "7", "8"]
        //Default number of servings is 4
        let defaultRowIndex = pickerData.indexOf("4")
        myPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
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
    
    //When a new picker row (i.e. a new number of servings) is selected, sets the ingredient quantity text fields to reflect the new quantities
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let servingsString = pickerData[row]
        let servingsNum: Double? = Double(servingsString)
        //calculate quantity of ground pork
        let groundPorkQuantity = servingsNum! / 4
        groundPorkOutput.text = String(groundPorkQuantity)
        //calculate quantity of hamburger buns
        hamburgerBunsOutput.text = servingsString

    }
    
}

