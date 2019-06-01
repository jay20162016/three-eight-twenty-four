//
//  main.swift
//  cmd_test
//
//  Created by Jay Jayjay on 9/3/17.
//  Copyright © 2017 Jay Jayjay. All rights reserved.
//

import Foundation

enum MyError : Error {
    case E(String)
    
}

extension String {
    var length: Int {
        return self.characters.count
    }
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    func substring(_ from:Int, _ to:Int) -> String {
        return self[Range(min(from, length)..<max(0, to))]
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[start ..< end]
    }
}

func isOp(_ s:String) -> Bool {
    return ["+", "-", "*", "/"].contains(s)
}
func isBracket(_ s:String) -> Bool {
    return ["(", ")"].contains(s)
}
func hasBracket(_ s:String) -> Bool {
    return s.contains("(") || s.contains(")")
}
func isOpOrBracket(_ s:String) -> Bool {
    return isOp(s) || isBracket(s)
}
func isStrongOp(_ s:String) -> Bool {
    return ["*", "/"].contains(s)
}
func isWeakOp(_ s:String) -> Bool {
    return ["+", "-"].contains(s)
}
func letterIsDigit(_ s:String) -> Bool {
    return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(s);
}
func operating(_ left:Int, _ op:String, _ right:Int) -> Int {
    if left == -999 || right == -999 { return -999 }
    switch op {
    case "+":
        return left + right
    case "-":
        return left - right
    case "*":
        return left * right
    case "/":
        if left % right == 0 {return left / right}
        fallthrough
    default:
        return -999
    }
}
func isValidNumber(_ s:String) -> Bool {
    if s.length == 0 { return false }
    if s[0] == "-" || s[0] == "+" {
        if s.length == 1 { return false }
    }
    for i in 0..<s.length {
        if i == 0 && (s[i] == "-" || s[i] == "+") { continue }
        if !letterIsDigit(s[i]) {
            return false
        }
    }
    return true
}
//assert(isValidNumber("") == false)
//assert(isValidNumber("123"))
//assert(isValidNumber("-123"))
//assert(isValidNumber("1*2") == false)

func extractFirstNum(_ s:String) throws -> Int {
    print("extractFirstNum: s=", s)
    for i in 0..<s.length {
        if i == 0 && s[i] == "-" { continue }
        if !letterIsDigit(s[i]) {
            return Int(s.substring(0, i))!
        }
    }
    throw MyError.E("extractFirstNum")
}
func breakdownLeftOpRight(_ s:String) throws -> [String] {
    for i in 0..<s.length {
        if i == 0 && (s[i] == "-" || s[i] == "+") { continue }
        if !letterIsDigit(s[i]) {
            let leftstr = s.substring(0, i)
            if !isValidNumber(leftstr) { throw MyError.E("leftstr is invalid: " + leftstr) }
            return [leftstr, s[i], s.substring(i+1, s.length)]
        }
    }
    throw MyError.E("breakdownLeftOpRight")
}

func evalNoBracket(_ ins:String) throws -> Int {
    print("evalNoBracket on", ins)
    if ins.length == 0 { throw MyError.E("evalNoBracket: s is empty") }
    // trimming front +
    var s:String = ins
    s = s.replacingOccurrences(of: "--", with: "+")
    s = s.replacingOccurrences(of: "-+", with: "-")
    s = s.replacingOccurrences(of: "+-", with: "-")
    s = s.replacingOccurrences(of: "++", with: "+")
    
    if isValidNumber(s) { return Int(s)! }
    var items:[String] = try breakdownLeftOpRight(s)
    let leftnum:Int = Int(items[0])!
    let op:String = items[1]
    let rightstr:String = items[2]
    if isWeakOp(op) {
        let rightnum:Int = try evalNoBracket(op + rightstr)
        return leftnum + rightnum
    }
    else if isStrongOp(op) {
        if isValidNumber(rightstr) {
            let rightnum = Int(rightstr)!
            return operating(leftnum, op, rightnum)
        }
        let rightitems:[String] = try breakdownLeftOpRight(rightstr)
        let rightnum:Int = Int(rightitems[0])!
        let nextop:String = rightitems[1]
        let nextstr:String = rightitems[2]
        let calc:Int = operating(leftnum, op, rightnum)
        return try evalNoBracket("\(calc)" + nextop + nextstr)
    }
    else { return -999 }
}
func findFirstBracket(_ s:String) -> Int {
    for i in 0..<s.length {
        if s[i] == "(" {
            return i
        }
    }
    return -1
}
func findClosingBracket(_ s:String, _ k:Int) -> Int {
    var openbrackets:Int = 1
    for i in (k+1)..<s.length {
        if s[i] == "(" { openbrackets += 1 }
        else if s[i] == ")" {
            openbrackets -= 1
            if openbrackets == 0 { return i }
        }
    }
    return -1
}
func bracketsAreValid(_ s:String) -> Bool {
    var openbrackets:Int = 0
    for i in 0..<s.length {
        if s[i] == "(" { openbrackets += 1 }
        else if s[i] == ")" { openbrackets -= 1 }
        if (openbrackets < 0) { return false}
    }
    return openbrackets == 0
}
func evalString(_ s:String) throws -> Int {
    var line:String = s
    while hasBracket(line) {
        if bracketsAreValid(s) == false { throw MyError.E("ill-formed brackets") }
        line = try debracket(line)
    }
    return try evalNoBracket(line);
}
func compute(_ s:String) -> Int {
    var ans = 0
    do {
        ans = try evalString(s)
    } catch MyError.E {
        ans = 0
    } catch {
        ans = 0
    }
    return ans
}
func debracket(_ s:String) throws -> String {
    for i in 0..<s.length {
        if s[i] == "(" {
            if i >= 1 && isOp(s[i-1]) == false {
                throw MyError.E("no operator before bracket")
            }
            var out:String = ""
            out.append(s.substring(0, i))
            let j = findClosingBracket(s, i)
            if j == -1 {
                print("cannot find closing bracket")
                throw MyError.E("debracket")
            }
            if j < s.length - 1 && isOp(s[j+1]) == false {
                throw MyError.E("no operator after bracket")
            }
            let inside = s.substring(i + 1, j)
            let num = try evalString(inside)
            out.append("\(num)")
            out.append(s.substring(j + 1, s.length))
            return out
        }
    }
    return s
}

func validate(_ n1:Int,_ n2:Int,_ n3:Int,_ n4:Int,_ answer:String) -> Int {
    var numbers = Array<String>()
    var num_start = 0
    var num_this = 0
    var ans = answer.replacingOccurrences(of: " ", with: "")
    let original_ans:String = ans
    ans = ans.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    for i in ans.characters {
        if i=="+" || i=="-" || i=="*" || i=="/" {
            let num = ans.substring(num_start, num_this)
            numbers.append(num)
            num_start = num_this+1
        }
        
        num_this += 1
    }
    numbers.append(ans.substring(num_start, num_this))
    numbers.sort()
    
    let expected:[String] = ["\(n1)", "\(n2)", "\(n3)", "\(n4)"].sorted()

    if numbers == expected {
        return compute(original_ans)
    }
    return 0
}




