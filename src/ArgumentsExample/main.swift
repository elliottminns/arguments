import Arguments

enum ExampleArguments: ArgumentType {
    case URL
    case Force

    var name: String {
        switch self {
        case .URL:
            return "URL"
        case .Force:
            return "Force"
        }
    }

    var flag: String? {
        switch self {
        case .Force:
            return "-f"
        default:
            return nil
        }
    }

    var isRequired: Bool {
        switch self {
            case .URL:
                return true
            case .Force:
                return false
        }
    }

    var description: String? {
        switch self {
            case .URL:
                return "The URL of the request"
            case .Force:
                return "Forces the request"
        }
    }
}

let arguments = Arguments<ExampleArguments>()
arguments.printArguments()
