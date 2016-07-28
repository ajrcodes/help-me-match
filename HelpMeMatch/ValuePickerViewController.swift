//
//  ValuePickerViewController.swift
//  HelpMeMatch
//
//  Created by Andrew Roberts on 6/29/16.
//  Copyright © 2016 ajrcodes. All rights reserved.
//

import UIKit

class ValuePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,
    UIPopoverPresentationControllerDelegate, ColorPickerDelegate {
    
    // MARK: - IBOutlets
    
    // labels
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var customColorLabel: UILabel!
    @IBOutlet weak var customColorSelection: UIButton!
    @IBOutlet weak var currentColor: UIView!
    
    // array of "neutral colors" buttons
    @IBOutlet var colorButtons: [UIButton]!
    
    
    // MARK: - Stored Properties
    
    // information for the view
    var categoryData: [[String : AnyObject]] = [[:]]
    var selectedCategory: ClothingCategory = ClothingCategory.Top
    var pickerChoices: [String] = []
    
    // user selected data
    var userItemSelection: String = ""
    var userSelectedColorCategory: ColorCategory = ColorCategory.Black  // what is displayed as the user-choice
    var userSelectedColor: UIColor = UIColor.blackColor()   // how the user-choice is categorized and stored
    
    
    // MARK: - Target/Action
    
    // store data from selected item and then unwind to main menu
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        // store the user selected information in the backend
        CurrentSelection.storeSelectionData(userItemSelection, selectedCategory: selectedCategory,
                                            categoryData: categoryData, currentColor: currentColor.backgroundColor!)
        
        // return back to the original menu and update the appropriate labels
        self.performSegueWithIdentifier("unwindToMenu", sender: self)
    }
    
    
    @IBAction func neutralColorTapped(sender: UIButton) {
        // each button's tag is set to the appropriate raw integer value of its ColorCategory representation
        // after setting the userSelectedColorCategory store property, reflect the user selection in the currentColor view
        userSelectedColorCategory = ColorCategory(rawValue: sender.tag)!
        currentColor.backgroundColor = sender.backgroundColor
        
        // reflect selection in the view
        highlightButton(sender)
    }
    
    // triggered when the "Pick a custom color" button is pressed
    @IBAction func pickColorButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("showColorPicker", sender: self)
    }
    
    
    // MARK: - View Setup Functions
    
    // populate the array of choices for the PickerView
    func setupPickerChoices() {
        // loop through each clothing item within the category and append its display name to the list
        for item in categoryData {
            pickerChoices.append(item["displayName"] as! String)
        }
    }
    
    // populate the buttons on the selection view
    func setupColorButtons() {
        // loop through the buttons and set their background colors appropriately
        var i = 0
        while i < 6 {
            colorButtons[i].backgroundColor = DefaultColors.color[i].getUIColor()
            i += 1  // based off their order in the "DefaultColors.color" array
        }
        
        // set the custom color button's color to gray
        customColorSelection.backgroundColor = UIColor.grayColor()
    }
    
    // highlights the pressed button in yellow, removing highlights from all other buttons
    func highlightButton(sender: UIButton) {
        // highlight the pressed button
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.yellowColor().CGColor
        
        // reset all other buttons to black
        for button in colorButtons {
            if button.tag != sender.tag {
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.blackColor().CGColor
            }
        }
    }
 
    // setup the view based on the current category selection
    func setupView() {
        // PickerView setup
        setupPickerChoices()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // front-end setup
        categoryLabel.text = selectedCategory.getString()
        setupColorButtons()
    }

    
    // MARK: - UIPickerViewDataSource
    
    // returns the number of columns to display
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the number of rows in each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerChoices.count
    }
    
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerChoices[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userItemSelection = pickerChoices[row]
        selectionLabel.text = userItemSelection
    }
    
    
    // MARK: - ColorPickerDelegate Functions
    
    // performed when a user selects a color button
    func passSelectedValue(category: ColorCategory, color: UIColor) {
        // reflect the userSelectedColor in the currentColor view and customColorSelection button
        customColorSelection.backgroundColor = color
        currentColor.backgroundColor = color
        
        // save the userSelectedColorCategory, then reflect the choice in the selectionLabel
        userSelectedColorCategory = category
        customColorLabel.text = userSelectedColorCategory.getStringForCategory()
        
        // highlight the customColorSelection button and unhighlight all the other buttons
        highlightButton(customColorSelection)
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate Functions
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil {
            
            // triggered when the confirm button is pressed
            if segue.identifier == "unwindToMenu" {
                let mainMenuVC = segue.destinationViewController as! MainMenuViewController
                // only update the category that was initially selected
                switch selectedCategory {
                case ClothingCategory.Top:
                    mainMenuVC.currentTop.text = CurrentSelection.currentTop.name
                    mainMenuVC.currentTopColor.backgroundColor = CurrentSelection.currentTop.color
                case ClothingCategory.Bottom:
                    mainMenuVC.currentBottoms.text = CurrentSelection.currentBottom.name
                    mainMenuVC.currentBottomsColor.backgroundColor = CurrentSelection.currentBottom.color
                case ClothingCategory.Shoe:
                    mainMenuVC.currentShoes.text = CurrentSelection.currentShoes.name
                    mainMenuVC.currentShoesColor.backgroundColor = CurrentSelection.currentShoes.color
                case ClothingCategory.Accessory:
                    if let accessory = CurrentSelection.currentAccessories["Dress Watch"]?.name {
                        mainMenuVC.currentAccessories.text = accessory
                    }
                }
            }
            
            // triggered when the "Pick a custom color" button is pressed
            if segue.identifier == "showColorPicker" {
                // setup the destination view
                let vc = segue.destinationViewController as! ColorPickViewController
                vc.delegate = self
                vc.preferredContentSize = CGSizeMake(336, 320)
                // prepare the destination view to be used as a popup presentation
                let controller = vc.popoverPresentationController
                if controller != nil {
                    controller?.delegate = self
                }
            }
            
        }
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load the appropriate category data in from the plist file
        categoryData = DataHelper.loadClothingData(selectedCategory)
        
        // setup the view
        setupView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

