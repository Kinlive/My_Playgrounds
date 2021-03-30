import UIKit

let serial = DispatchQueue(label: "serial queue", attributes: .concurrent)

let otherQueue = DispatchQueue(label: "second queue")
/*
serial.async {
    print("start")
    otherQueue.async {
        /*for i in 0 ..< 10 {
            print("i: \(i), aaaaaa")
            
        }
        
        for i in 0 ..< 10 {
            print("i: \(i), cccccc")
        }*/
        print("aaaaa")
        print("ccccc")
    }
    
    print("eeeeeee")
}

serial.async {
    for i in 0 ..< 10 {
        print("i: \(i), bbbbb")
    }
    
    for i in 0 ..< 10 {
        print("i: \(i), ddddd")
    }
}

class Messager {
    private var messages: [String] = []
    private let queue = DispatchQueue(label: "message.queue", attributes: .concurrent)
    
    var lastMessage: String? {
        return queue.sync {
            messages.last
        }
    }
    
    func postMessage(_ newMessage: String) {
        queue.sync(flags: .barrier) { // 被 barrier 的 block 會先延緩執行，並將並行隊列暫時轉為串行，直到先前提交的任務完成後再會執行block內暫緩的任務，並且完成後恢復原先的行為。
            
            messages.append(newMessage)
            
        }
    }
}

let messager = Messager()
print("============== Messager ==================")
//for i in 0 ..< 10 {
//    serial.async {
//        messager.postMessage("Hello: \(i)")
//        print(messager.lastMessage)
////        messager.postMessage("World!: \(i)")
////        messager.postMessage("Today: \(i)")
////        messager.postMessage("is: \(i)")
//        messager.postMessage("very hot: \(i)")
//        print(messager.lastMessage)
//    }
//}
//print(messager.lastMessage)
//messager.postMessage("Hello")
//print(messager.lastMessage)

*/


// MARK: - 串行隊列 ( Serial queue )

func serialQueue() {
    print("start")
    let queue = DispatchQueue(label: "sync.queue.com")
    queue.sync {
        print("task1, thread at: \(Thread.current)")
    }
    queue.sync {
        sleep(3)
        print("task2, thread at: \(Thread.current)")
    }
    queue.async { // 因為異步所以新建立一個線程來執行。
        print("task3, thread at: \(Thread.current)")
    }
    queue.sync {
        print("task4, thread at: \(Thread.current)")
    }
    print("end")
}

//serialQueue()

func asyncQueue() {
    print("start")
    let queue = DispatchQueue(label: "sync.queue.com")
    queue.async {
        print("task1, thread at: \(Thread.current)")
    }
    queue.async {
        print("task2, thread at: \(Thread.current)")
        
//        DispatchQueue.main.async {
//            print("task5, thread at: \(Thread.current)")
//        }
    }
    queue.async {
        print("task3, thread at: \(Thread.current)")
    }
    queue.async {
        print("task4, thread at: \(Thread.current)")
    }
    print("end")
}

//asyncQueue()

func deathLockQueue() {
    print("start, thread at \(Thread.current)")
    
    let queue = DispatchQueue.main
    
    queue.sync { // 形成 queue 死鎖狀態
        print("task 1, thread at: \(Thread.current)")
    }
    queue.sync {
        print("task 2, thread at: \(Thread.current)")
    }
    queue.sync {
        print("task 3, thread at: \(Thread.current)")
    }
    queue.sync {
        print("task 4, thread at: \(Thread.current)")
    }
    print("end")
}

//deathLockQueue()

// MARK: - 並行隊列 ( Concurrent queue)
func concurrentSync() {
    print("\n=============\(#function)================")
    print("Start at thread: \(Thread.current)")
    /*
     由於同步執行，因此即便是並行隊列，依然會阻塞主線程執行。
     */
    let queue = DispatchQueue(label: "concurrent.sync.com", attributes: .concurrent)
    
    queue.sync {
        print("Task 1 at thread: \(Thread.current)")
    }
    queue.sync {
        sleep(3)
        print("Task 2 at thread: \(Thread.current)")
    }
    queue.sync {
        print("Task 3 at thread: \(Thread.current)")
    }
    queue.sync {
        print("Task 4 at thread: \(Thread.current)")
    }
    print("end at thread: \(Thread.current)")
}
//concurrentSync()


func concurrentAsync() {
    print("\n=============\(#function)================")
    print("Start at thread: \(Thread.current)")
    let queue = DispatchQueue(label: "concurrent.async.com", attributes: .concurrent)
    
    queue.async {
        print("Task 1 at thread: \(Thread.current)")
    }
    queue.async {
        // 在這邊等待三秒後，因前一次run loop尚未結束，所以觀察記憶體位置其使用的線程是暫存在線程池裡再利用的
        sleep(3)
        print("Task 2 at thread: \(Thread.current)")
    }
    queue.async {
        print("Task 3 at thread: \(Thread.current)")
    }
    queue.async {
        print("Task 4 at thread: \(Thread.current)")
    }
    queue.async {
        print("Task 5 at thread: \(Thread.current)")
    }
    queue.async {
        print("Task 6 at thread: \(Thread.current)")
    }
    queue.async {
        print("Task 7 at thread: \(Thread.current)")
    }
    print("end at thread: \(Thread.current)")
}

//concurrentAsync()

// MARK: - 嵌套任務

func nestQueue() {
    print("start at thread \(Thread.current)")
    let queue = DispatchQueue.init(label: "serial.queue.com")
    queue.sync { // 注意，同步執行
        print("task1 thread at \(Thread.current)")
        queue.sync { // 此時再度呼叫同一隊列在同步執行block內，勢必會與外層 sync 互相等待行程鎖死
            print("task2 thread at \(Thread.current)")
        }
        print("task3 thread at \(Thread.current)")
    }
    print("end at thread \(Thread.current)")
}

func nestQueue2() {
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    let queue = DispatchQueue.init(label: "serial.queue2.com")
    queue.sync { // 注意，同步執行
        print("task1 thread at \(Thread.current)")
        queue.async { // 此時指定內部的任務異步執行，因此 queue 會另開一個子線程來執行 task2
            print("task2 thread at \(Thread.current)")
        }
        print("task3 thread at \(Thread.current)")
    } // 只是因為還是在同步執行的 block內，因此task2還是會先等待此 block 執行完後，其子線程的任務才會進行。
    print("end at thread \(Thread.current)")
}
//for _ in 0 ..< 5 {
//    nestQueue2()
//}


func nestQueue3() {
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    let queue = DispatchQueue.init(label: "serial.queue3.com")
    queue.async { // 異步執行，不會卡 Main thread
        print("task1 thread at \(Thread.current)")
        queue.sync { // 此時賦予一個同步執行的任務，形成鎖死。
            print("task2 thread at \(Thread.current)")
        }
        print("task3 thread at \(Thread.current)")
    }
    /*
     解析：
        因 queue 本身屬於 serial queue，即便先執行 async {} 開啟子線程，對於 queue 來說還是必須等待 async {} 任務完成，而此時又再添加 sync { }的任務到queue上， async {}會等待 task2 完成，而task2 必須等待 async 先加入到queue的任務完成造成鎖死。
     */
    print("end at thread \(Thread.current)")
}

func nestQueue4() { // 解決鎖死
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    
    let queue = DispatchQueue.init(label: "serial.queue4.com", attributes: .concurrent) // 指定 並行隊列
    queue.async { // 異步執行，不會卡 Main thread
        print("task1 thread at \(Thread.current)")
        queue.sync { //
            sleep(2)
            print("task2 thread at \(Thread.current)")
        }
        
        print("task3 thread at \(Thread.current)") // task3 必定等待 task2 執行完成才執行。
    }
    print("end at thread \(Thread.current)")
}

//for _ in 0 ..< 5 {
//    nestQueue4()
//}


func nestQueue5() {
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    
    let queue = DispatchQueue.init(label: "serial.queue5.com", attributes: .concurrent) // 指定 並行隊列
    queue.sync { // 異步執行，不會卡 Main thread
        print("task1 thread at \(Thread.current)")
        queue.async { // 因會有開創子線程的處理時間，因此也無法預期會是 task3 先執行完成還是task2先執行完成，因此也有可能在 end 後才執行 task2
            //sleep(2)
            print("task2 thread at \(Thread.current)")
        }
        
        print("task3 thread at \(Thread.current)")
    }
    print("end at thread \(Thread.current)")
}
//for _ in 0 ..< 5 {
//    nestQueue5()
//}

func nestQueue6() {
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    
    let queue = DispatchQueue.init(label: "serial.queue6.com", attributes: .concurrent) // 指定 並行隊列
    queue.sync { // 同步執行，都會用到 main thread 即卡主線程
        print("task1 thread at \(Thread.current)")
        queue.sync { // 未造成鎖死，原因在於 並行隊列，雖然同步執行，但並行隊列特性使得第一個任務已經先執行，而後task2 的同步執行加入到隊列中時，也會立即執行，因此不會造成鎖死，並且同步執行的緣故使得結果有序。
            sleep(2)
            print("task2 thread at \(Thread.current)")
        }
        
        print("task3 thread at \(Thread.current)")
    }
    print("end at thread \(Thread.current)")
}

//for _ in 0 ..< 5 {
//    nestQueue6()
//}

func nestQueue7() {
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    
    let queue = DispatchQueue.main
    queue.sync { // 因方法本身就是執行在主執行緒上，而又自行呼叫主執行緒進行同步執行，導致sync的任務排在方法執行完後，造成互相等待鎖死。
        print("task1 thread at \(Thread.current)")
        queue.async { // 外部先鎖死，因此task1 也不會執行。
            //sleep(2)
            print("task2 thread at \(Thread.current)")
        }
        
        print("task3 thread at \(Thread.current)")
    }
    print("end at thread \(Thread.current)")
}
//nestQueue7()
func nestQueue8() {
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    
    let queue = DispatchQueue.main
    queue.sync { // 同 nestQueue7的狀況，直接在此先鎖死。
        print("task1 thread at \(Thread.current)")
        queue.sync {
            //sleep(2)
            print("task2 thread at \(Thread.current)")
        }
        
        print("task3 thread at \(Thread.current)")
    }
    print("end at thread \(Thread.current)")
}
//nestQueue8()
func nestQueue9() { // 任務順序為： start -> end -> task1 -> interrupted
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    
    let queue = DispatchQueue.main
    queue.async { // 雖異步，但仍然是使用主執行緒，因為主執行緒上不會額外開啟線程。
        print("\(#function) task1 thread at \(Thread.current)")
        queue.sync { // 會等待方法執行完成，才會執行，在執行完 task1 就停止往下執行，也沒發生error(?)，
            // 實際應該是有鎖死，當同時執行 nestQueue9 及 nestQueue10 時，nestQueue10就會因為9中斷在task1 執行而不會執行後續任務。
            //sleep(2)。
            print("task2 thread at \(Thread.current)")
        }
        
        print("task3 thread at \(Thread.current)")
    }
    // 這邊也執行到，推估是因為前次任務為異步，因此不會阻塞任務進行。
    print("end at thread \(Thread.current)")
}
nestQueue9()

func nestQueue10() { // 完成任務順序為： start -> end -> task1 -> task3 -> task2
    print("\n=============\(#function)================")
    print("start at thread \(Thread.current)")
    
    let queue = DispatchQueue.main
    queue.async { // 執行異步不阻塞主執行緒，會等待方法完成才執行
        print("task1 thread at \(Thread.current)")
        queue.async { // 執行異步不阻塞主執行緒，會等待外層異步完成才執行
            //sleep(2)
            print("task2 thread at \(Thread.current)")
        }
        
        print("task3 thread at \(Thread.current)")
    }
    print("end at thread \(Thread.current)")
}
nestQueue10()

// MARK: - 自行擴充 swift 的 dispatch_once 功能
extension DispatchQueue {
    
    private static var tokenTracker: [String] = []
    class func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if tokenTracker.contains(token) {
            return
        }
        
        tokenTracker.append(token)
        block()
    }
}

func doSomthingOnce() {
    
    var anArray: [Int] = []
    
    for i in 0 ..< 5 {
        DispatchQueue.once {
            anArray.append(i)
        }
    }
    print(anArray)
}

doSomthingOnce()

// MARK: - 簡易實現 objc 中的 @synchronized 效果
// 自定義一個方法
func synchronized(lock object: AnyObject, closure: () -> Void) {
    objc_sync_enter(object)
    closure()
    objc_sync_exit(object)
}

// MARK: - 藉由並行隊列執行快速迭代，會使用到主線程以及其他線程，並且無順序去遍歷陣列裡的元素
let iterationArr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
DispatchQueue.concurrentPerform(iterations: iterationArr.count) { index in
    print("iterations index: \(iterationArr[index]) at thread \(Thread.current)")
}
print("central iterations")
DispatchQueue.concurrentPerform(iterations: iterationArr.count) { index in
    print("iterations index: \(iterationArr[index]) at thread \(Thread.current)")
}


