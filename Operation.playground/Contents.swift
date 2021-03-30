import UIKit

struct Task {
    let function: String
    let runloop: String
    let task: String
    let threadDescription: String
}
func separateLine(label: String = #function) {
    print("\n==============\(label)===================")
}
@discardableResult
func taskNo(_ num: Int,
            subNum: Int? = nil,
            description: String = "",
            function: String = #function) -> Task {
    
    let aThread = Thread.current
    return Task(
        function: function,
        runloop: "\(subNum ?? 0)",
        task: "\(num)",
        threadDescription: aThread.description
    )
}

var start: String { "Start thread at \(Thread.current)" }
var end: String { "End thread at \(Thread.current)" }

// MARK: - 未加入 OperationQueue 以前， operation 都是執行在主執行緒上，也就是單純使用 operation 是不會開啟多執行緒作業。
func operation() {
    print("start at thread \(Thread.current)")
    
    let blockOp = BlockOperation()
    
    blockOp.addExecutionBlock {
        print("task1 at thread \(Thread.current)")
    }
    
    print("task2 at thread \(Thread.current)")
    
    blockOp.start()
    
    print("task3 at thread \(Thread.current)")
}

//operation()

class DemoOperation: Operation {
    
    var label: String
    init(label: String) {
        self.label = label
    }
    
    override func main() {
        super.main()
        print("Init with label \(label)===========================")
        if !isCancelled {
            for _ in 0 ..< 3 {
                print("On custom operation queue at thread \(Thread.current)")
            }
        }
    }
}

func customOperation() {
    let op = DemoOperation(label: #function)
    print("Task1 at \(Thread.current)")
    op.start()
    print("Task2 at \(Thread.current)")
}

//customOperation()

// MARK: - Operation Queue (使用隊列)
func useMainThread() {
    print("\n============\(#function)=============")
    print("Start thread at \(Thread.current)")
    let mainQueue = OperationQueue.main
    print("Task1 thread at \(Thread.current)")
    mainQueue.addOperation {
        print("Task2 thread at \(Thread.current)")
    }
    print("End thread at \(Thread.current)")
}
//useMainThread()

func useOtherQueueWithSerial() { // 其他 Operation 在加入隊列時，預設都是用異步執行，只是因為可並行最大數目設置為 1，因此還是串行隊列。
    print("\n============\(#function)=============")
    print("Start thread at \(Thread.current)")
    
    let otherQueue = OperationQueue()
    otherQueue.maxConcurrentOperationCount = 1 // serial queue, 不指定的情況下預設都是並行隊列。
    
    print("Task1 thread at \(Thread.current)")
    
    otherQueue.addOperation { // 自動開啟異步線程
        print("Task2 thread at \(Thread.current)")
    }
    
    print("End thread at \(Thread.current)")
}
//useOtherQueueWithSerial()

// MARK: - 實際應用過程
func onlyBlockOperationUse() {
    separateLine(label: #function)
    print(start)
    
    let block = BlockOperation() //{
//        for i in 0 ..< 2 {
//            print("Task-Block-\(i) thread at \(Thread.current)")
//        }
//        print("Task-Block2 thread at \(Thread.current)")
//    }
    
    // 增加多個操作
    block.addExecutionBlock {
        for i in 0 ..< 2 {
            print("Task1-\(i) thread at \(Thread.current)")
        }
        print("Task2 thread at \(Thread.current)")
    }
    
    block.addExecutionBlock { // 當大於一個操作在執行時，block變成並行隊列，並且每個操作都會開啟 thread 或重複使用 pool 裡的可用 thread
        for i in 0 ..< 2 {
            print("Task3-\(i) thread at \(Thread.current)")
        }
        print("Task4 thread at \(Thread.current)")
    }
    
    block.addExecutionBlock {
        for i in 0 ..< 2 {
            print("Task5-\(i) thread at \(Thread.current)")
        }
        print("Task6 thread at \(Thread.current)")
    }
    
    block.addExecutionBlock {
        for i in 0 ..< 2 {
            print("Task7-\(i) thread at \(Thread.current)")
        }
        print("Task8 thread at \(Thread.current)")
    }
    
    block.start()
    print(end)
    
}
//onlyBlockOperationUse()

func addOperationToQueueUse() {
    
    separateLine(label: #function)
    print(start)
    
    let queue = OperationQueue()
    // default: queue.maxConcurrentOperationCount = -1 預設就是並行執行
   queue.maxConcurrentOperationCount = 2
    
    let task1 = BlockOperation {
        for i in 0 ..< 2 {
            print(taskNo(1, subNum: i))
        }
    } // task1 non start
    
    let task2 = BlockOperation()
    task2.addExecutionBlock {
        for i in 0 ..< 2 {
            print(taskNo(2, subNum: i))
        }
    } // task2 non start
    
    let task3 = BlockOperation()
    task3.addExecutionBlock {
        for i in 0 ..< 2 {
            if i % 2 == 0 {
                sleep(2)
                print(taskNo(3, description: "Its slept for 2 second"))
            }
            print(taskNo(3, subNum: i))
        }
    } // task3 non start
    
    queue.addOperation { // 先定義，依然會所有任務並行執行。
        for i in 0 ..< 2 {
            print(taskNo(4, subNum: i))
        }
    }
    
    // add operation to queue
    queue.addOperation(task1) // operation start
    queue.addOperation(task2)
    queue.addOperation(task3)
    
    // 測試最大並行數量
    queue.addOperation {
        for i in 0 ..< 2 {
            sleep(1)
            print(taskNo(5, subNum: i))
        }
    }
    
    queue.addOperation {
        for i in 0 ..< 2 {
            sleep(1)
            print(taskNo(6, subNum: i))
        }
    }
    
    print(end)
}

//addOperationToQueueUse()
// MARK: - 暫停任務

// MARK: - 任務依賴
func addDependenciesToOperation() {
    separateLine(label: #function)
    print(start)
    
    let queue = OperationQueue()
    let task1 = BlockOperation {
        sleep(1)
        print(taskNo(1))
    }
    
    let task2DependencyOn1 = BlockOperation {
        sleep(1)
        print(taskNo(2, subNum: 0))
    }
    
    task2DependencyOn1.addDependency(task1) // 依賴於 task1 的完成後才會執行自身的任務，而自身任務為異步，所以先執行了 task 2-1 再執行 task 2-0
    
    task2DependencyOn1.addExecutionBlock {
        print(taskNo(2, subNum: 1))
    }
    
    let task3 = BlockOperation() // 沒有依賴關係，直接執行
    task3.addExecutionBlock {
        print(taskNo(3))
    }
    
    queue.addOperation(task1)
    queue.addOperation(task2DependencyOn1)
    queue.addOperation(task3)
    
    print(end)
}
//addDependenciesToOperation()

func addDependenciesWithSerialQueue() { // ans: task3 -> task1 -> task2-1 -> task2-0
    separateLine(label: #function)
    print(start)
    
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1 // Serial queue
    
    let task1 = BlockOperation {
        sleep(1)
        print(taskNo(1))
    }
    
    let task2 = BlockOperation {
        sleep(1)
        print(taskNo(2, subNum: 0))
    }
    
    task2.addDependency(task1) // 依賴於 task1 的完成後才會執行自身的任務，而自身任務為異步，所以先執行了 task 2-1 再執行 task 2-0
    
    task2.addExecutionBlock {
        print(taskNo(2, subNum: 1))
    }
    
    let task3 = BlockOperation() // 沒有依賴關係，直接執行
    task3.addExecutionBlock {
        sleep(3)
        print(taskNo(3))
    }
        
    queue.addOperation(task2)
    queue.addOperation(task3)// 測試當先添加 task2 到隊列中，但其自身又依賴 task1，這時隊列添加 task3 會先以 task3 的任務完成後，才執行 task1。
    queue.addOperation(task1)
    
    print(end)
}
//addDependenciesWithSerialQueue()

// MARK: - 任務優先級
/*
    刻意讓task1 優先度高於 task3並且task1最後加入隊列，但執行在並行隊列中，結果只有保證 task2 一定在 task3完成後才執行，而task1與task3表現沒有絕對 task1優先。
    結果可能為：3 -> 1 -> 2 or 3 -> 2 -> 1 or 1 -> 3 -> 2。
 
    若將方法內 queue的種類從並行改為串行，則結果恆為 3 -> 2 -> 1。
 */
func priorityOperation(loop: Int) -> [Task] {
    
    var task: [Task] = []
    
    separateLine()
    print(start)
    
    let queue = OperationQueue()
    let serialQueue = OperationQueue() // ****線程安全改善方式****
    serialQueue.maxConcurrentOperationCount = 1 // 使多線程操作的物件串行操作。
    
    let task1 = BlockOperation {
        // 若是在此直接操作 task 進行讀寫，就可能發生在多種線程同時操作單一物件，會有線程不安全的情形，會發生 task偶爾會漏掉任務的情況。
        serialQueue.addOperation {
            // 因此改善作法為增加 serialQueue 另外操作一個線程來對 task 進行讀寫。
            task.append(taskNo(1, subNum: loop))
        }
        
    }
    task1.queuePriority = .high
    
    let task2 = BlockOperation {
        serialQueue.addOperation {
            task.append(taskNo(2, subNum: loop))
        }
        
    }
    task2.queuePriority = .veryHigh
    
    let task3 = BlockOperation {
        serialQueue.addOperation {
            task.append(taskNo(3, subNum: loop))
        }
        
    }
    task3.queuePriority = .veryLow
    
    task2.addDependency(task3) // task2(high) -> task3(veryLow)

    queue.addOperation(task2) // wait for task3, not on ready status
    queue.addOperation(task3)
    queue.addOperation(task1) // last add task1
    queue.waitUntilAllOperationsAreFinished()
    serialQueue.waitUntilAllOperationsAreFinished()
    //queue.addOperations([task2, task3, task1], waitUntilFinished: true)
    print(end)
    
    return task
}
//for i in 0 ..< 10 {
//    let tasks = priorityOperation(loop: i).map { $0.task }
//    print(tasks)
//}


func testDependencyAndPriorityAndAddIntoQueue() {
    var tasks: [Task] = []
    let taskQueue = OperationQueue()

    let task1Operation = BlockOperation {
        tasks = (0 ..< 10)
            .map { priorityOperation(loop: $0) }
            .reduce([], +)
    }

    let task2Operation = BlockOperation {
        print(start)
        tasks.forEach {
            print("\n>>>>>>> new loop")
            print($0)
        }
    }

    task2Operation.addDependency(task1Operation)
    //taskQueue.addOperations([task1Operation, task2Operation], waitUntilFinished: true)
    taskQueue.addOperation(task1Operation)
    taskQueue.addOperation(task2Operation)
}

//testDependencyAndPriorityAndAddIntoQueue()

func samplePriority() {
    let queue = OperationQueue()
    // 1) 當為串行隊列
    queue.maxConcurrentOperationCount = 1
    
    let task1 = BlockOperation {
        print(taskNo(1))
    }
    
    task1.queuePriority = .veryLow
    
    let task2 = BlockOperation {
        //sleep(3)
        print(taskNo(2))
    }
    task2.queuePriority = .normal
    
    // 2) 並且使用這個方法一次指定 operations
    queue.addOperations([task1, task2], waitUntilFinished: true)
    
    // 3) 則結果會永遠參照優先級 task2 -> task1, 測試過迴圈10次的結果皆如此。
}
//samplePriority()


/* 只是測試一下task的 completionBlock 是夾在依賴關係間進行 */
func syncTask() -> [Task] {
    var tasks: [Task] = []
    
    // 保證線程安全
    let appendTaskQueue = OperationQueue()
    appendTaskQueue.maxConcurrentOperationCount = 1
    
    separateLine()
    print(start)
    let queue = OperationQueue()
    //queue.maxConcurrentOperationCount = 1
    let task1 = BlockOperation {
        appendTaskQueue.addOperation {
            tasks.append(taskNo(1))
        }
        
    }
    
    task1.completionBlock = {
        appendTaskQueue.addOperation {
            tasks.append(taskNo(2))
        }
        
    }
    
    let task2 = BlockOperation {
        appendTaskQueue.addOperation {
            tasks.append(taskNo(3))
        }
    }
    
    task2.addDependency(task1)
    
    queue.addOperations([task1, task2], waitUntilFinished: true)
    appendTaskQueue.waitUntilAllOperationsAreFinished()
    print(end)
    
    return tasks
}

//print(syncTask())

// MARK: - 線程安全
var ticketSurplusCount: Int = 0
var ticketThreadLock: NSLock!

func saleTicketNotSafe() {
    while ticketSurplusCount != 0 {
        // 加入線程安全的做法
        // ---> ticketThreadLock.lock()
        if ticketSurplusCount > 0 {
            ticketSurplusCount -= 1
            print("剩餘票數：\(ticketSurplusCount), 窗口：\(Thread.current)")
        }
        // ticketThreadLock.unlock() <---
    }
    
    print("所有票卷都已販售完畢。")
}

func saleStatus() {
    separateLine()
    print(start)
    
    ticketSurplusCount = 50
    ticketThreadLock = NSLock()
    
    let queue1 = OperationQueue()
    queue1.maxConcurrentOperationCount = 1
    let queue2 = OperationQueue()
    queue2.maxConcurrentOperationCount = 1
    
    let saleAction1 = BlockOperation {
        saleTicketNotSafe()
    }
    
    let saleAction2 = BlockOperation {
        saleTicketNotSafe()
    }
    
    queue1.addOperation(saleAction1)
    queue2.addOperation(saleAction2)
    
    print(end)
}
//saleStatus()

/* 示範一下，若是要每個窗口只會賣總張數一半的張數  */
func saleTicketByQueue(_ queue: OperationQueue) {
    var selfSalesTickets = 0
    
    while ticketSurplusCount != 0 {
        ticketThreadLock.lock()
        
        if selfSalesTickets >= 25 {
            ticketThreadLock.unlock()
            break
        }
        
        if ticketSurplusCount > 0 {
            ticketSurplusCount -= 1
            selfSalesTickets += 1
            print("剩餘票數：\(ticketSurplusCount), 窗口：\(Thread.current)")
        }
        
        ticketThreadLock.unlock()
    }
    
    print("銷售窗口：\(Thread.current) 的票券已完售。")
}

func saleTicketByBalance() {
    separateLine()
    print(start)
    
    ticketSurplusCount = 50
    ticketThreadLock = NSLock()
    
    print("開賣前，目前票數總共有：\(ticketSurplusCount)")
    
    let sales1 = OperationQueue()
    let sales2 = OperationQueue()
    
    let sale1Action = BlockOperation {
        saleTicketByQueue(sales1)
    }
    
    let sale2Action = BlockOperation {
        saleTicketByQueue(sales2)
    }
    
    sales1.addOperation(sale1Action)
    sales2.addOperation(sale2Action)
    
    print(end)
}

saleTicketByBalance()
