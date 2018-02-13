//
//  ComputerSolve.swift
//  three eight twenty four
//
//  Created by Jay Jayjay on 9/5/17.
//  Copyright © 2017 Jay Jayjay. All rights reserved.
//

import Foundation

class IntOp : Hashable {
    var num:Int;
    var op:String;
    var hashValue: Int {
        return self.num
    }
    init(_ num:Int, _ op:String) {
        self.num = num
        self.op = op
    }
    static func ==(lhs: IntOp, rhs: IntOp) -> Bool {
        return lhs.num == rhs.num
    }
}


func enumerate2(_ a:Set<IntOp>, _ b:Set<IntOp>) -> Set<IntOp>{
    var nums:Set<IntOp> = Set<IntOp>()
    for ia in a {
        for ib in b {
            nums = nums.union(enumerate2(ia, ib))
        }
    }
    return nums
}
func enumerate2(_ a:IntOp, _ b:Set<IntOp>) -> Set<IntOp>{
    var nums:Set<IntOp> = Set<IntOp>()
    for ib in b {
        nums = nums.union(enumerate2(a, ib))
    }
    return nums
}
func enumerate2(_ a:Set<IntOp>, _ b:IntOp) -> Set<IntOp>{
    return enumerate2(b, a)
}
func enumerate2(_ astr:IntOp, _ bstr:IntOp) -> Set<IntOp> {
    var nums:Set<IntOp> = Set<IntOp>()
    let a:Int = astr.num
    let b:Int = bstr.num
    let aa:String = astr.op
    let bb:String = bstr.op
    nums.insert(IntOp(a+b, "(\(aa)+\(bb))"))
    nums.insert(IntOp(a-b, "(\(aa)-\(bb))"))
    nums.insert(IntOp(b-a, "(\(bb)-\(aa))"))
    nums.insert(IntOp(a*b, "(\(aa)*\(bb))"))
    if a != 0 { if b % a == 0 { nums.insert(IntOp(b/a, "(\(bb)/\(aa))")) } }
    if b != 0 { if a % b == 0 { nums.insert(IntOp(a/b, "(\(aa)/\(bb))")) } }
    return nums
}
func enumerate3(_ a:IntOp, _ b:IntOp, _ c:IntOp) -> Set<IntOp> {
    var nums:Set<IntOp> = Set<IntOp>()
    nums = nums.union(enumerate2(a, enumerate2(b, c)))
    nums = nums.union(enumerate2(b, enumerate2(c, a)))
    nums = nums.union(enumerate2(c, enumerate2(a, b)))
    return nums
}
func enumerate4(_ ai:Int, _ bi:Int, _ ci:Int, _ di:Int) -> String {
    print("Solving \(ai), \(bi), \(ci), \(di)")
    var nums:Set<IntOp> = Set<IntOp>()
    let a:IntOp = IntOp(ai, "\(ai)")
    let b:IntOp = IntOp(bi, "\(bi)")
    let c:IntOp = IntOp(ci, "\(ci)")
    let d:IntOp = IntOp(di, "\(di)")
    nums = nums.union(enumerate2(enumerate2(a, b), enumerate2(c, d)))
    nums = nums.union(enumerate2(enumerate2(a, c), enumerate2(b, d)))
    nums = nums.union(enumerate2(enumerate2(a, d), enumerate2(b, c)))
    nums = nums.union(enumerate2(enumerate3(a, b, c), d))
    nums = nums.union(enumerate2(enumerate3(a, c, d), b))
    nums = nums.union(enumerate2(enumerate3(a, b, d), c))
    nums = nums.union(enumerate2(enumerate3(b, c, d), a))
    
    var answerfound = false
    var  ans : String = ""
    for i in nums {
        if i.num == 24 {
            answerfound = true
            print(i.op)
            ans = i.op
        }
    }
    if !answerfound {
        print("impossible")
    }
    if ans != "" && ans[0] == "(" {
        ans = ans.substring(1, ans.length - 1)
    }
    return ans
}


func solve(a:Int, b:Int, c:Int, d:Int) -> String {
    return enumerate4(a, b, c, d)
}



