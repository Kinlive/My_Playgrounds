import UIKit

func measure(repeats: Int, block: () -> Void) {

    let start = Date()
    for _ in 0 ..< repeats { block() }
    let end = Date()

    print("time spent: \(end.timeIntervalSince(start))")
}

/*
    Example 1
    input: [1, 8, 6, 2, 5, 4, 8, 3, 7]
    output: 49
    
    Example 2
    input: [1, 1]
    output: 1
 
    Example 3
    input: [4, 3, 2, 1, 4]
    ouput: 16
 
    Example 4
    input: [1, 2, 1]
    output: 2
 
 */
func maxArea(height: [Int]) -> Int {
    guard height.count > 1 else { return 0 }
    var maxArea: Int = 0
    let reverseHeight: [Int] = height.reversed()
      
    for i in 0 ..< height.count {
        
        let left = findMaxArea(height: height, left: i, right: height.count - 1)
        let right = findMaxArea(height: reverseHeight, left: i, right: height.count - 1)
        let loopMax = max(left, right)
        maxArea = max(loopMax, maxArea)
    }
    return maxArea
}

private func findMaxArea(height: [Int], left: Int, right: Int) -> Int {
    
    var maxArea = 0
    
    for movePoint in left ..< right + 1 {
        let height = min(height[movePoint], height[left])
        let distance = movePoint - left
        maxArea = max(maxArea, height * distance)
    }
    return maxArea
}

print(maxArea(height: [1, 8, 6, 2, 5, 4, 8, 3, 7]))
print(maxArea(height: [4, 3, 2, 1, 4]))
print(maxArea(height: [1, 2, 1]))
print(maxArea(height: [1, 1]))

// the fast answer
func twoPointerMaxArea(_ height: [Int]) -> Int {
    var maxArea = 0
    var leftPointer = 0
    var rightPoint = height.count - 1
    
    while leftPointer < rightPoint {
        let minHeight = min(height[leftPointer], height[rightPoint])
        maxArea = max(maxArea, minHeight * (rightPoint - leftPointer))
        
        if height[leftPointer] < height[rightPoint] {
            leftPointer += 1
        } else {
            rightPoint -= 1
        }
    }
    return maxArea
}

print(twoPointerMaxArea([1, 8, 6, 2, 5, 4, 8, 3, 7]))
print(twoPointerMaxArea([4, 3, 2, 1, 4]))
print(twoPointerMaxArea([1, 2, 1]))
print(twoPointerMaxArea([1, 1]))

let input = (0 ... 10000).map { $0 }
var reverseInput = Array(input.reversed())
reverseInput.removeFirst()
let total = input + reverseInput
//
measure(repeats: 1) {
    print(twoPointerMaxArea(total))
}

/*
    n = 8
    1 --> 1 < 7 , 1 * 8 = 8, move left pointer
    2 --> 8 > 7, 7 * 7 = 49, move right pointer
    3 --> 8 > 3, 3 * 6 = 18, move right pointer
    4 --> 8 == 8, 8 * 5 = 40, move left or right pointer
    5 --> 6 < 8,  6 * 4 = 24, move left pointer
    6 --> 2 < 8, 2 * 3 = 6, move left pointer
    7 --> 5 < 8, 5 * 2 = 10, move left pointer
    8 --> 4 < 8, 4 * 1 = 4, move left pointer
    9 --> left >= right pointer, end loop
 
    思路：
        開題從最寬距離開始計算並比較，由於先考慮最寬，因此假定最寬距離的面積為最大面積，再根據左右兩側 height 依照兩側較低的值做位移內縮寬度，因為面積計算一定是取兩點都有涵蓋的高度來計算，因此不論哪一側數值較高，對於數值低的點進行位移是會比較有效率的。
 */


func practiceContainer(_ height: [Int]) -> Int {
    
    var lIndex = 0
    var rIndex = height.count - 1
    
    var maxSize = 0
    
    while lIndex <= rIndex {
        let lHeight = height[lIndex]
        let rHeight = height[rIndex]
        
        // calculate
        let length = rIndex - lIndex
        let minHeight = min(lHeight, rHeight)
        
        maxSize = max(length * minHeight, maxSize)
        if lHeight > rHeight {
            rIndex -= 1
        } else {
            lIndex += 1
        }
    }
    
    
    return maxSize
}

print(practiceContainer([1, 8, 6, 2, 5, 4, 8, 3, 7]))
print(practiceContainer([4, 3, 2, 1, 4]))
print(practiceContainer([1, 2, 1]))
print(practiceContainer([1, 1]))
