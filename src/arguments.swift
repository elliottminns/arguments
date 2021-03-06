
public enum OptionType {
    case Indexed(index: UInt, required: Bool)
    case Flag(short: String, long: String?, hasValue: Bool, required: Bool)
}

public protocol Options: Hashable {
    var type: OptionType { get }
}

public protocol ArgumentConvertible {
    static func convertFromArgument(argument: String) -> Self?
}

extension Int: ArgumentConvertible {
    static public func convertFromArgument(argument: String) -> Int? {
        return Int(argument)
    }
}

extension String: ArgumentConvertible {
    static public func convertFromArgument(argument: String) -> String? {
        return argument
    }
}

public class Arguments<T: Options> {

    let options: [T]
    let arguments: [String]
    let availableOptions: Set<T>
    let flagValues: [T: String]
    let indexed: [String]

    public convenience init(options: [T]) {
        self.init(options: options, arguments: Process.arguments)
    }

    init(options: [T], arguments: [String]) {
        self.options = options
        self.arguments = arguments
        let parsed = OptionParser.parseArguments(arguments,
            withOptions: options)
        self.availableOptions = parsed.flags
        self.flagValues = parsed.flagValues
        self.indexed = parsed.indexValues
    }

    public func validate() -> Bool {
        return true
    }

    public func valueForOption<Y: ArgumentConvertible>(option: T) -> Y? {

        let value: String?

        switch option.type {
            
        case .Flag(_, _, _, _):
            value = flagValues[option]

        case .Indexed(let index, _):
            if Int(index) < indexed.count {
                value = indexed[Int(index)]
            } else {
                value = nil
            }
        }

        if let value = value {

            return Y.convertFromArgument(value)
        } else {

            return nil
        }

    }

    public func hasOption(option: T) -> Bool {
        return self.availableOptions.contains(option)
    }
}

class OptionParser<T: Options> {

    static func populateFlags(options options: [T]) -> [String: T] {
        var flags = [String: T]()

        for option in options {
            switch option.type {

            case .Flag(let short, let long, _, _):

                if !short.hasPrefix("-") {
                    flags["-" + short] = option
                } else {
                    flags[short] = option
                }

                if let long = long {
                    if long.hasPrefix("--") {
                        flags[long] = option
                    } else if long.hasPrefix("-") {
                        flags["-" + long] = option
                    } else {
                        flags["--" + long] = option
                    }
                }
            default:
                break
            }
        }

        return flags
    }

    static func parseArguments(arguments: [String], withOptions options: [T]) -> (flags: Set<T>, flagValues: [T: String], indexValues: [String]) {

        var indexed: [String?] = arguments.map { return $0 as String? }

        var foundFlags = Set<T>()
        var flagValues = [T: String]()

        var flags = populateFlags(options: options)

        var index = 0

        for argument in arguments {

            guard index > 0 else {
                indexed[index] = nil
                index = index.successor()
                continue
            }

            if argument[argument.startIndex] == "-" {

                indexed[index] = nil

                if let option = flags[argument] {

                    switch option.type {
                    case .Flag(_, _, let hasValue, _):
                        foundFlags.insert(option)

                        if hasValue {
                            if arguments.count > index + 1 {
                                flagValues[option] = arguments[index + 1]
                                indexed[index + 1] = nil
                            }
                        }
                    default:
                        break
                    }
                }
            }

            index++
        }

        let indexValues: [String] = indexed.filter {
            return $0 != nil
        }.map {
            return $0!
        }

        return (flags: foundFlags, flagValues: flagValues, indexValues: indexValues)
    }
}
