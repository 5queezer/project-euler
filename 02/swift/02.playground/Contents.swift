func generateFibonacci(_ threshold: Int) -> [Int] {
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

let result = generateFibonacci(4_000_000).filter{$0 % 2 == 0}.reduce(0,+)
print(result)
