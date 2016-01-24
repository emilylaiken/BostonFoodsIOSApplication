//
//  BoxDescriptionsViewController
//  BostonFoods
//
//  Created by Emily Aiken on 11/29/15.
//  Copyright © 2015 Boston Foods. All rights reserved.
//

import UIKit

class BoxDescriptionViewController: UIViewController {
    
    @IBOutlet weak var textBox: UITextView! //Blue text box containing contents of current box
    @IBOutlet weak var boxDescriptionTextBox: UITextView! //White text box containing generic box description
    
    //Sets up text boxes upon loading of view
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.contentOffset = CGPoint(x: -100, y: -100) //Sets offset for blue text box
        var urlString = "" //Will hold URL where info for blue textbox is located
        var boxContentsTextBox = "" //Will hold string for paragraph in blue text box
        var description = "" //Will hold string for paragraph in white text box
        //User has selected classic box
        if boxType == "classic" {
            urlString = "https://www.dropbox.com/sh/0p31gpjkb2ifu8p/AADHA24MiisXkZ563UBf63Kia/classic.txt?raw=1" //URL for classic box contents
            //Classic box generic description
            description = "Each Classic Box contains about 23 pounds of food including elements from both the Produce Box and Protein Box, around 10 pounds of meat and 13 pounds of produce.  We slightly modify the box each month, so that everyone gets to enjoy variety in their day to day meals. Boxes are also modified depending on what is in season and what is currently selling at the lowest price, so you know you are getting fresh food at the best price. A typical box includes items such as: marinated chicken, pork chops, beef, cucumbers, zucchini, carrots, tomatoes, broccoli, green beans, apples, bananas, oranges, and more."
        }
        //User has selected protein box
        else if boxType == "protein" {
            urlString = "https://www.dropbox.com/sh/0p31gpjkb2ifu8p/AADAQ99WOoUfmHH3tt1FlGB0a/protein.txt?raw=1" //URL for protein box contents
            // Protein box generic description
            description = "Perfect for the proud meat-eater, the Protein Box contains an assortment of meat including: chicken, beef, pork, and sausage, among other weekly specials. The Protein Box includes around 15 pounds of meat, plenty for a typical sized family."
        }
        //User has selected produce box
        else {
            urlString = "https://www.dropbox.com/sh/0p31gpjkb2ifu8p/AACRuRTcjczzIEBcFM17lKTba/produce.txt?raw=1" //URL for produce box contents
            //Produce box generic description
            description = "Each box contains an assortment of produce, always fresh and always healthy. We also keep in mind the shelf-life of the produce we include, so we know you and your family will have the time to enjoy each and every item. The Produce Box typically items such as apples, oranges, pears, bananas, broccoli, potatoes, carrots, green peppers, and cucumbers, among others.  Contents vary based on the season, but always include almost 30 pounds of produce."
        }
        //Read in contents from text file located at URL
        let url = NSURL(string: urlString)!
        do {
            boxContentsTextBox = try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("Problem dowloading data for text from URL.")
        }
        //Set text in blue box
        textBox.text = boxContentsTextBox
        textBox.font = UIFont(name: "Helvetica Bold", size: 17)
        //self.textBox.scrollRangeToVisible(NSMakeRange(0, 0))
        //Set text in white box
        boxDescriptionTextBox.text = description
        boxDescriptionTextBox.font = UIFont(name: "Helvetica", size: 15)
        ////////
        let fixedWidth = textBox.frame.size.width
        textBox.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textBox.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textBox.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textBox.frame = newFrame;
    }
    
    //Adjusts scroll views for blue and white text boxes so they start at the top
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textBox.setContentOffset(CGPointZero, animated: false)
        boxDescriptionTextBox.setContentOffset(CGPointZero, animated: false)
    }
    
}



