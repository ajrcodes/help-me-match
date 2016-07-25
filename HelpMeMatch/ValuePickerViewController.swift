//
//  ValuePickerViewController.swift
//  HelpMeMatch
//
//  Created by Andrew Roberts on 6/29/16.
//  Copyright © 2016 ajrcodes. All rights reserved.
//

import UIKit

class ValuePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var currentColor: UIView!
    
    
    // MARK: - Stored Properties
    
    var categoryData: [[String : AnyObject]] = [[:]]
    var selectedCategory: ClothingCategory = ClothingCategory.Top
    var pickerSelection: [String] = []
    var userSelection: String = ""
    
    
    // MARK: - Custom Functions
    
    // populates the current datasource of the picker view with the appropriate category
    func setupPickerSelection() {
        // loop through each item within the category and append its display name to the list
        for item in categoryData {
            pickerSelection.append(item["displayName"] as! String)
        }
    }
    
    // sets up the view based on the current category selection
    func setupView() {
        setupPickerSelection()
        categoryLabel.text = selectedCategory.getString()
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    
    // MARK: - UIPickerViewDataSource
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerSelection.count
    }
    
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerSelection[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userSelection = pickerSelection[row]
        selectionLabel.text = userSelection
    }
    
    
    // MARK: - Target/Action
    
    // unwinds to main menu upon confirming the clothing selection
    @IBAction func confirmButtonTapped(sender: AnyObject) {
        CurrentSelection.storeSelectionData(userSelection, selectedCategory: selectedCategory,
                                            categoryData: categoryData, currentColor: currentColor.backgroundColor!)
        self.performSegueWithIdentifier("unwindToMenu", sender: self)
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier != nil {
            
            if segue.identifier == "unwindToMenu" {
                let mainMenuVC = segue.destinationViewController as! MainMenuViewController
                
                // only update the label that was pressed
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
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryData = DataHelper.loadClothingData(selectedCategory)
        setupView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

