import UIKit
let a: [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
let n: [Int] = [1,5,3,6,2,4,7,8,9,0,3,5,3,1,0,6,9,4,2,7,6,1,5,6,2,7,8,1,8,6]

func factorial<T: BinaryInteger>(_ n: T) -> T {
    guard n >= 0 else { return 0 } // Prevent negative factorials
    guard n > 1 else { return 1 }
    
    var result: T = 1
    for i in stride(from: n, through: 1, by: -1) {
        result *= i
    }
    return result
}

// MARK: - 1. GCD - Main Queue
DispatchQueue.main.async {
    print("Main Queue: \(a.joined(separator: ", "))")
}

// MARK: - 2. Custom Queues (Serial & Concurrent)
let serialQueue = DispatchQueue(label: "com.example.serialQueue")
let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)

// Serial Queue: Sorting
serialQueue.async {
    let sorted = n.sorted()
    print("Serial Queue Sorted: \(sorted)")
}

// Concurrent Queue: Factorials
concurrentQueue.async {
    print("Factorial of 20: \(factorial(20))")
}
concurrentQueue.async {
    print("Factorial of 5: \(factorial(5))")
}

// MARK: - 3. Global Queues (Background Task)
DispatchQueue.global(qos: .background).async {
    print("Background Queue: Reversed Array: \(a.reversed())")
}

// MARK: - 4. Sync vs Async Behavior
print("Before Sync Task")
serialQueue.sync {
    print("Sync Task Executing on Serial Queue")
}
print("After Sync Task") // This will execute only after sync block finishes

// MARK: - 5. OperationQueue
let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 2  // Limit to 2 concurrent operations

operationQueue.addOperation {
    print("OperationQueue Task 1: Factorial of 10 = \(factorial(10))")
}
operationQueue.addOperation {
    print("OperationQueue Task 2: Factorial of 15 = \(factorial(15))")
}

// MARK: - 6. DispatchGroups
let dispatchGroup = DispatchGroup()

dispatchGroup.enter()
concurrentQueue.async {
    print("Group Task 1: Sorting Numbers: \(n.sorted())")
    dispatchGroup.leave()
}
dispatchGroup.enter()
concurrentQueue.async {
    print("Group Task 2: Factorial of 20 = \(factorial(20))")
    dispatchGroup.leave()
}

dispatchGroup.notify(queue: DispatchQueue.main) {
    print("All Dispatch Group Tasks Completed")
}
