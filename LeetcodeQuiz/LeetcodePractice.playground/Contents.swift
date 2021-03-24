import UIKit

func measure(repeats: Int, label: String = "", block: () -> Void) {

    let start = Date()
    for _ in 0 ..< repeats { block() }
    let end = Date()

    print("\(label) \ntime spent: \(end.timeIntervalSince(start))")
}
// MARK: - =========== Question 1 ===========
/*
 53 / 53 test cases passed.
 Status: Accepted
 Runtime: 88 ms
 Memory Usage: 13.9 MB
 */
func twoSum(_ nums: [Int], target: Int) -> [Int] {
    var indexsDic: [Int : Int] = [:]

    var ans: [Int] = []

    for i in 0 ..< nums.count {
        // 1) 先找差異值是否有在dictionary裡
        // 2) 沒有 把當前值丟進dictionary
        // 3) 有, 表示前面已有數字與當前值的總和為 target
        //let num = nums[i]
        //let diff = target - num

        if let findIndex = indexsDic[target - nums[i]] {
            ans = [findIndex, i]
            break
        } else {
            indexsDic[nums[i]] = i
        }
    }

    return ans
}

/*
 53 / 53 test cases passed.
 Status: Accepted
 Runtime: 56 ms
 Memory Usage: 14.1 MB
 */
func twoSumForce(_ nums: [Int], target: Int) -> [Int] {

    var indexs: [Int] = []

    for i in 0 ..< nums.count {
        for j in 0 ..< nums.count {
            if i == j {
                continue
            }

            let sum = nums[i] + nums[j]

            if sum == target {
                indexs.append(i)
                indexs.append(j)
                return indexs
            }
        }
    }

    return indexs
}

// MARK: - =========== Question 2 ===========
/*
 Example 1:
 Input: s = "abcabcbb"
 Output: 3
 Explanation: The answer is "abc", with the length of 3.

 Example 2:
 Input: s = "bbbbb"
 Output: 1
 Explanation: The answer is "b", with the length of 1.

 Example 3:
 Input: s = "pwwkew"
 Output: 3
 Explanation: The answer is "wke", with the length of 3.
 Notice that the answer must be a substring, "pwke" is a subsequence and not a substring.

 Example 4:
 Input: s = ""
 Output: 0

 Example 5:
 Input: s = "dvdf"
 Output: 3
 */
func lengthOfLongestSubstring(_ s: String) -> Int {
    guard !s.isEmpty else { return 0 }

    var chars = ""
    var longestLength: Int = 0

    for char in s {
        if chars.count > 0, chars.last! == char {
            chars = String(char)

        } else if chars.contains(char) {

            // more fast
            var notStop = true
            while notStop {
                let firstChar = chars.first
                if firstChar == char {
                    chars.removeFirst()
                    notStop = false
                } else {
                    chars.removeFirst()
                }
            }

            chars += String(char)

            // slow version
//            let start = chars
//                .enumerated()
//                .filter { $0.element == char }
//                .map { $0.offset }
//                .last ?? 0
//
//            let suffixLength = chars.count - start - 1
//            chars = String(chars.suffix(suffixLength)) + String(char)
            
        } else {
            chars += String(char)
        }

        longestLength = max(longestLength, chars.count)
    }

    return max(longestLength, chars.count)
}

// MARK: - =========== Question 3 ===========

// MARK: - =========== Question 2 ===========
/*
 
 */

// MARK: - =========== Question 2 ===========
/*
 
 */

// MARK: - =========== Question 2 ===========
/*
 
 */

func longestNotRepeatSubstring(_ s: String) -> Int {
    guard s.count > 1 else { return s.count }
    
    let sArr: [Character] = Array(s)
    var maxLength = Int.min
    
    for i in 0 ..< sArr.count {
        let first = searchLongest(chars: sArr, left: i, right: i + 1)
        let second = searchLongest(chars: sArr.reversed(), left: i, right: i + 1)
        maxLength = max(max(first, second), maxLength)
    }

    
    return maxLength
}

private func searchLongest(chars: [Character], left: Int, right: Int) -> Int {
    let l = left
    var r = right
    
    var someChars: [Character] = [chars[l]]
    
    while l >= 0, r < chars.count, !someChars.contains(chars[r]) {
        someChars.append(chars[r])
        r += 1
    }
    
    return someChars.count
}

longestNotRepeatSubstring("abcabcbb")
longestNotRepeatSubstring("bbbbb")
longestNotRepeatSubstring("kknewxdd")
longestNotRepeatSubstring("a")
longestNotRepeatSubstring("dvdf")
longestNotRepeatSubstring("pwwkew")

//: Sliding window (use hash map) 速度幾乎等同於 原先的寫法。
func newOfLongestSubstring(_ s: String) -> Int {
    guard s.count > 1 else { return s.count }

    let chars: [Character] = Array(s)
    var maxLength = 0
    
    var charKeys: [Character : Int] = [:]
    var i = 0
    for j in 0 ..< s.count {
        let currentChar = chars[j]
        
        if charKeys.keys.contains(currentChar) {
            i = max(charKeys[currentChar] ?? 0, i)
        }
        maxLength = max(maxLength, j - i + 1)
        charKeys[chars[j]] = j + 1
    }
    
    return maxLength
}

let finalTestLongerString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"


measure(repeats: 1, label: "origin") {
    lengthOfLongestSubstring(finalTestLongerString)
}

measure(repeats: 1, label: "new") {
    newOfLongestSubstring(finalTestLongerString)
}
