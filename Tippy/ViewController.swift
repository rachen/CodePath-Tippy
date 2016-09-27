//
//  ViewController.swift
//  Tippy
//
//  Created by Raymond Chen on 9/23/16.
//  Copyright © 2016 Raymond Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    let defaults = NSUserDefaults.standardUserDefaults()
    var tipPercentages = [0.15, 0.18, 0.20]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((defaults.objectForKey("customTipAmount")) != nil) {
            print("object for key custom tip amount is not null")
            insertCustomSegment()
        }
        
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (animated) {
            self.view.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                self.view.alpha = 1
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tipIndex = defaults.integerForKey("defaultPercentageIndex")
        tipControl.selectedSegmentIndex = tipIndex
        self.calculateTip(self)
        
        if (tipControl.numberOfSegments == 4) {
            if (defaults.integerForKey("customTipAmount") == 0) {
                if (tipPercentages.count == 4) {
                    tipPercentages.removeAtIndex(3)
                }
                tipControl.removeSegmentAtIndex(3, animated: false)
                return
            }
            
            
            tipControl.setTitle(String(defaults.integerForKey("customTipAmount")) + "%", forSegmentAtIndex: 3)
            if ((defaults.objectForKey("customTipAmount")) != nil) {
                if (tipPercentages.count != tipControl.numberOfSegments) {
                    tipPercentages.append(Double(defaults.integerForKey("customTipAmount")) * 0.01)
                }
                else {
                    tipPercentages[3] = Double(defaults.integerForKey("customTipAmount")) * 0.01
                }
            }
            
        }
        else {
            print("view did appear, inserting custom segment")
            insertCustomSegment()
        }
        
    }
    
    func insertCustomSegment() {
        tipControl.insertSegmentWithTitle(String(defaults.integerForKey("customTipAmount")) + "%", atIndex: 3, animated: true)
        tipPercentages.append(Double(defaults.integerForKey("customTipAmount")) * 0.01)
    }
    

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(sender: AnyObject) {
        let bill = Double(billField.text!) ?? 0
        
        // Number formatting shenanigans
        let numberFormatter = NSNumberFormatter()
        numberFormatter.locale = NSLocale.currentLocale()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        print(tipControl.selectedSegmentIndex)
        print("defaults")
        print(defaults.integerForKey("customTipAmount"))
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        if (animated) {
            UIView.animateWithDuration(0.5, animations: {
                self.view.alpha = 0
            })
            
        }
    }
}

