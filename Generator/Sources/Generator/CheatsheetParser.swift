import Foundation
import SwiftyJSON

func parseJSON(_ content: String) -> [Icon] {
    guard let dataFromString = content.data(using: .utf8, allowLossyConversion: false) else {
        exit(EXIT_FAILURE)
    }
    do {
        let json = try JSON(data: dataFromString)
        return json.dictionaryValue.map {
            return Icon(
                name: $0.key,
                unicode: $0.value["unicode"].stringValue,
                free: $0.value["free"].arrayValue.map { $0.stringValue },
                pro: $0.value["styles"].arrayValue.map { $0.stringValue }
            )
        }.sorted(by: { $0.name < $1.name })
    } catch {
        print(error.localizedDescription)
        exit(EXIT_FAILURE)
    }
}
