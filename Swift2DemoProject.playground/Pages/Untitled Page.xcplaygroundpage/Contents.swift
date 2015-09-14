
let regexString = "(?<=Regional\\().+(?=\\))"

let ressortString = "Regional(Kölle)"

if let cityRange = ressortString.rangeOfString(regexString, options: .RegularExpressionSearch) {
    print(ressortString.substringWithRange(cityRange))
} else {
    print("NotFound")
}



