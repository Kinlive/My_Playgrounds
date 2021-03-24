import UIKit

func measure(repeatRun: Int = 1, block: () -> Void) {
    let startDate = Date()
    
    for _ in 0 ..< repeatRun {
        block()
    }
    let endDate = Date()
    
    print("time spent: \(endDate.timeIntervalSince(startDate))")
}

/* 在給定的整數陣列中，排列三個數值一組相加為 0 的可能性，並且三位一組的結果不可重複。

Constraints with input:
 0 <= nums.length <= 3000
 -10^5 <= nums[i] <= 10^5
 
Example 1:
 Input: nums = [-1,0,1,2,-1,-4]
 Output: [[-1,-1,2],[-1,0,1]]
 
Example 2:
 Input: nums = []
 Output: []
 
Example 3:
 Input: nums = [0]
 Output: []
 
 */

/*
 1. 因不影響輸出結果，因此先對於帶入數值做排序
 2. 選用 hashMap 來作為單一儲存
 3. 迴圈內取得第一個數值與目標數值的差異值
 4. 定義另外兩數的 index，分別為下一個與最後一個(因為數值經過排序，勢必會先由最小數值加上最大數值，是否等於目標數。因此無須考慮其他數值與第一個left 或是最後一個right所指定的數值做結果計算。)
 5. 判斷 left 及 right 的數值與 3. 的差異值的關係
 6. 若小於差異值，則移動 left 指標，反之則移動 right 指標。
 7. 當等於差異值時，這邊尚未想通，(似乎條件可以不判斷，目前為判斷 right指標是否指在最後一位置，或是指標數值不等於 (right + 1) 指標的數值)
 8. 若以上判斷結果為是，則儲存數值陣列。並且 while 結束時同時移動 left及right的指標。
 */
func newThreeSum(_ nums: [Int]) -> [[Int]] {
    guard nums.count > 2 else { return [] }
    
    let sortedNums = nums.sorted(by: <)
    let target = 0
    var ans: [String: [Int]] = [:]
    
    for i in 0 ..< nums.count {
        
        let diff = target - sortedNums[i]
        
        var left = i + 1
        var right = nums.count - 1
        
        while left < right {
            
            if sortedNums[left] + sortedNums[right] < diff {
                left += 1
                
            } else if sortedNums[left] + sortedNums[right] > diff {
                right -= 1
                
            } else {
                //if (right == nums.count - 1) || sortedNums[right] != sortedNums[right + 1] {
                    
                    let value = [sortedNums[i], sortedNums[left], sortedNums[right]]
                    ans["\(value)"] = value
                //}
                
                left += 1
                right -= 1
            }
        }
    }
    
    var final: [[Int]] = []
    ans.values.forEach { eachValue in
        final.append(eachValue)
    }
    
    return final
}
print(newThreeSum([0, 0, 0, 0]))
print(newThreeSum([-1,0,1,2,-1,-4]))
