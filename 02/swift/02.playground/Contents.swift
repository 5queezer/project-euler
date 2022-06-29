func generateFibonacci(threshold: Int = 4_000_000) -> [Int] {
    var fibSeq = [1, 2]
    while true {
        let fibSum = fibSeq.suffix(2).reduce(0,+)
        if fibSum > threshold {
            break
        }
        fibSeq.append(fibSum)
    }
    return fibSeq
}

let result = generateFibonacci().filter{$0 % 2 == 0}.reduce(0,+)
print(result)
