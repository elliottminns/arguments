
public protocol ArgumentType {
    var name: String { get }
    var flag: String? { get }
    var isRequired: Bool { get}
    var description: String? { get }
}

public class Arguments<T: ArgumentType> {
    
    let flagged: [String: String]

    static func argumentIsFlagType(argument argument: String) -> Bool {
        return argument[argument.startIndex] == "-"
    }

    static func parseArguments() -> [String: String] {

        var arguments = [String: String]()

        var index = 0

        for argument in Process.arguments {

            if index == 0 { index++; continue }
            
            if Arguments.argumentIsFlagType(argument: argument) {
                
                let flag = argument

                if Process.arguments.count > index + 1 {

                    let value = Process.arguments[index + 1]

                    if !Arguments.argumentIsFlagType(argument: value) {
                        arguments[flag] = value
                    } else {
                        arguments[flag] = ""
                    }
                } else {
                    arguments[flag] = ""
                }
            }

            index++
        }

        return arguments
    }

    public func printArguments() {
        for (key, value) in flagged {
            print("\(key): \(value)")
        }
    }

    public init() {
        flagged = Arguments.parseArguments()
    }
}
