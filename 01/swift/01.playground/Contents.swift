let max = 1000
let range = 1..<max
var sum = 0
for number in range where number % 3 == 0 || number % 5 == 0 {
    sum += number
}

print(sum)

// or
sum = range.filter{ $0 % 3 == 0 || $0 % 5 == 0 }.reduce(0, +)
print(sum)
