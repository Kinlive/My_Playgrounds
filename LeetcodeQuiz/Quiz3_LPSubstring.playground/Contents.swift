import UIKit
/*
 example 1:
 input: s = "babad" -----> [b, a, bab, aba, d ]
 output: "bab",   "aba" is also a valid answer
 
 example 2:
 input: s = "cbbd" -------> [ c, b, bb, d]
 output: "bb"
 
 example 3:
 input: s = "a"
 output: "a"
 
 example 4:
 input: s = "ac"
 output: "a"
 
 example 5:
 input: s = "aacabdkacaa" ------> [a, c, b, d, k, aa, aca]
 output: "aca"
 
 example 6:
 input: s = "abababab..........n"
 output: fail to time limit exceeded
 */

func measure(repeats: Int, label: String = "", block: () -> Void) {

    let start = Date()
    for _ in 0 ..< repeats { block() }
    let end = Date()

    print("\(label) \ntime spent: \(end.timeIntervalSince(start))")
}

/* 回文子串解析
 
    1. 只有一個字符時，如a，即為一個回文串
    2. 有兩個字符時，如aa，則字符串為[a, aa]，如ab，則字符串為[a, b]
    3. 如有3個以上字符時，比如 ababa本身為回文串1，去掉兩頭 a 為 bab 也是一個回文串2，只要串2 為一回文串，則串1只要兩數相同就必定也為一回文串。
 
 */

// Dynamic programming, time spent more.
func longestPalindrome(_ s: String) -> String {
    
    guard s.count > 0 else { return "" }
    
    let n = s.count
    let sArr = Array(s)//s.map { String($0) }
    
    var memo = Array(repeating: Array(repeating: false, count: n), count: n)
    
    var maxPalin = ""
    
    for j in 0 ..< n {
        for i in 0 ..< j + 1 { // 前述 n 已經減一了
            if sArr[i] == sArr[j] && ((j - i) < 2 || memo[i + 1][j - 1]) {
                memo[i][j] = true
                let newString = String(sArr[i ... j])
                maxPalin = newString.count > maxPalin.count ? newString : maxPalin
            }
        }
    }
    
    return maxPalin
}
longestPalindrome("babad")
longestPalindrome("cbbd")
longestPalindrome("a")
longestPalindrome("ac")
longestPalindrome("acabaca")
longestPalindrome("acabckacbca")

// expand around center, more fast
func expandAroundCenterLongestPalindrome(_ s: String) -> String {
    guard s.count > 0 else { return "" }
    
    let sArr: [Character] = Array(s)
    var maxString = ""
    
    for i in 0 ..< sArr.count {
        let oddMax = searchPalindrome(chars: sArr, l: i, r: i)
        let evenMax = searchPalindrome(chars: sArr, l: i, r: i + 1)
        let loopMax = oddMax.count >= evenMax.count ? oddMax : evenMax
        maxString = loopMax.count > maxString.count ? loopMax : maxString
    }
    
    return maxString
}

func searchPalindrome(chars: [Character], l: Int, r: Int) -> String {
    
    var left = l
    var right = r

    while left >= 0, right < chars.count, chars[left] == chars[right] {
        left -= 1
        right += 1
    }

    if (right - 1) >= (left + 1) { // 回推 right 與 left 的關係一定要為 right >= left
        return String(chars[(left + 1) ... (right - 1)])
    } else {
        // 當沒有 right 沒有大於 left時, 狀態一定為 還沒走過while 一次就超出界線, 因此直接回傳空值
        return ""
    }
}



let finalTestString1 = "ababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab"

measure(repeats: 1) {
    longestPalindrome(finalTestString1)
}

measure(repeats: 1) {
    expandAroundCenterLongestPalindrome(finalTestString1)
}
