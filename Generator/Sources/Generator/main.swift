import Foundation

struct Icon {
    var name: String
    var unicode: String
    
    var free: [String]
    var pro: [String]
}


guard let path = Bundle.module.path(forResource: "icons", ofType: "json"),
      let jsonContent = try? String(contentsOfFile: path, encoding: .utf8) else {
    print("Missing file icons.json")
    exit(EXIT_FAILURE)
}

let icons = parseJSON(jsonContent)

var free: [String: [Icon]] = [:]
var pro: [String: [Icon]] = [:]

for icon in icons {
    var strippedIcon = icon
    strippedIcon.free = []
    strippedIcon.pro = []
    
    for style in icon.free {
        if free[style] == nil {
            free[style] = []
        }
        free[style]!.append(strippedIcon)
    }
    
    for style in icon.pro {
        if pro[style] == nil {
            pro[style] = []
        }
        pro[style]!.append(strippedIcon)
    }
}

print("Generating Awesome.swift")
let Awesome = buildEnum("Awesome", from: free)

print("Generating AwesomePro.swift")
let AwesomePro = buildEnum("AwesomePro", from: pro)

let AwesomeDestination = URL(fileURLWithPath: "./Output").appendingPathComponent("Awesome.swift")
let AwesomeProDestination = URL(fileURLWithPath: "./Output").appendingPathComponent("AwesomePro.swift")

do {
    try Awesome.write(to: AwesomeDestination, atomically: true, encoding: String.Encoding.utf8)
    try AwesomePro.write(to: AwesomeProDestination, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("Could not write enum files.")
    exit(EXIT_FAILURE)
}

exit(EXIT_SUCCESS)

RunLoop.main.run()
