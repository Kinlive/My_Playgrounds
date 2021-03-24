import UIKit

// MARK: - Dynamic programming
// 乘階
func factorial() {
    /*
     int f = 1;
         for (int i=2; i<=N; ++i)
             f *= i;
     */
    let n = 10
    var f = 1
    for i in 2 ... n {
        print("sum f = \(f)")
        f *= i
        
    }
    print(f)
}
factorial()

// Fibonacci Freeze
/*
    (0, 1, 1, 2, 3, 5, 8, 13, 21)
 */
func recurrence_bottomUp(numbers: [Int]) {
    
    var calculated: [Int: Int] = [:]
    calculated[0] = 0
    calculated[1] = 1
    
    for n in numbers {
        if let nValue = calculated[n] {
            print("had value when n == \(n), value = \(nValue)")
        } else {
            for i in 2 ... n {
                calculated[i] = calculated[i - 1]! + calculated[i - 2]!
            }
            print("n == \(n), value = \(calculated[n])")
        }
    }
}

recurrence_bottomUp(numbers: [5, 7, 30, 8, 9, 10])
/*
 arr[0] = 0
 arr[1] = 1
 arr[2] = 0 + 1 = arr[0] + arr[1] > 1
 arr[3] = 1 + 1 = arr[1] + arr[2] > 2
 arr[4] = 1 + 2 = arr[2] + arr[3] > 3
 arr[5] = 2 + 3 = arr[3] + arr[4] > 5
 arr[6] = 3 + 5 = arr[4] + arr[5] > 8
 let sum = arr[0]
 */
func recurrence_bottomUp_improve(numbers: [Int]) {
    var calculated: [Int : Int] = [:]
    calculated[0] = 0
    calculated[1] = 1
    
    for n in numbers {
        let sum = (n + 1) * (n - 1) / 2
        print("n == \(n), value = \(sum)")
    }
}

recurrence_bottomUp_improve(numbers: [5, 7, 30 , 8, 9, 10])


func sumOfMostCloseValues(nums: [Int], target: Int) -> Int {
    let sorted = nums.sorted(by: <)
    
    var minValue = Int.max
    
    var finalSum = 0
    
    for i in 0 ..< sorted.count - 2 {
        var left = i + 1
        var right = sorted.count - 2
        let basic = sorted[i]
        
        while left < right {
            let sum = sorted[left] + sorted[right] + basic
            
            let diff = abs(sum - target)
            
            if diff < minValue {
                minValue = diff
                finalSum = sum
            }
            
            if sum < target {
                left += 1
            } else if sum > target {
                right -= 1
            } else {
                finalSum = sum
                break
            }
        }
    }
    return finalSum
}

//sumOfMostCloseValues(nums: [9, 3, 5, 7, 2, 9, 10, 12, 3, 2, 5], target: 7) // 17
