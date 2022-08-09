@load "ordchr"
BEGIN {
    RS=","
}
{
    gsub(/^"|"$/, "")
    arr[NR]=$1
}
END {
    asort(arr, sorted)
    for (i=1; i<=length(sorted); i++) {
        val=0
        split(sorted[i], chars, "")
        for (y=1; y <= length(chars); y++) {
            char = chars[y]
            val += (ord(char) - ord("A") + 1)
        }
        sum += val * i
    }
    print sum
}
