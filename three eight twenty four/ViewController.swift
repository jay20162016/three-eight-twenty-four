//
//  ViewController.swift
//  three eight twenty four
//
//  Created by Jay Jayjay on 8/6/17.
//  Copyright © 2017 Jay Jayjay. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var num1: UIButton!
    @IBOutlet weak var num2: UIButton!
    @IBOutlet weak var num3: UIButton!
    @IBOutlet weak var num4: UIButton!
    @IBOutlet weak var correct: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var ans: UILabel!

    
    @IBAction func onAns(_ sender: Any) {
        let computed:Int = validate(Int(num1.titleLabel!.text!)!, Int(num2.titleLabel!.text!)!, Int(num3.titleLabel!.text!)!, Int(num4.titleLabel!.text!)!, ans.text!)
        
        if computed == 24 {
            correct.text! = "Correct"
        }
        else{
            correct.text! = "Try again"
        }
    }
    
    @IBAction func showAns(_ sender: Any) {
        correct.text! = solve(a: Int(num1.titleLabel!.text!)!, b: Int(num2.titleLabel!.text!)!, c: Int(num3.titleLabel!.text!)!, d: Int(num4.titleLabel!.text!)!)
    }
    
    @IBAction func onNext(_ sender: Any) {
        loadRandomNumbers()
        ans.text!=""
        correct.text! = ""
    }
    
    @IBAction func onPress(_ sender: Any) {
        ans.text!.append((sender as! UIButton).titleLabel!.text!)
    }
    
    
    @IBAction func onOperation(_ sender: Any) {
        switch (sender as! UIButton).titleLabel!.text! {
        case "+":
            ans.text!.append("+")
        case "-":
            ans.text!.append("-")
        case "*":
            ans.text!.append("*")
        case "/":
            ans.text!.append("/")
        case "delete":
            ans.text!=ans.text!.substring(0, ans.text!.length - 1)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadRandomNumbers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadRandomNumbers(){
        var nums = [Int(arc4random_uniform(8)+2),Int(arc4random_uniform(8)+2),Int(arc4random_uniform(8)+2),Int(arc4random_uniform(8)+2)]
       while solve(a: nums[1], b: nums[2], c: nums[3], d: nums[0]) == "" {
            nums = [Int(arc4random_uniform(8)+2),Int(arc4random_uniform(8)+2),Int(arc4random_uniform(8)+2),Int(arc4random_uniform(8)+2)]
    }

        
        num1.setTitle("\(nums[0])", for: .normal)
        num2.setTitle("\(nums[1])", for: .normal)
        num3.setTitle("\(nums[2])", for: .normal)
        num4.setTitle("\(nums[3])", for: .normal)
        num1.setTitle("\(nums[0])", for: .selected)
        num2.setTitle("\(nums[1])", for: .selected)
        num3.setTitle("\(nums[2])", for: .selected)
        num4.setTitle("\(nums[3])", for: .selected)
    }

}
