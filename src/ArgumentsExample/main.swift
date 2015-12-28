import Arguments

enum ExampleOptions {

    case Force

    case URL

    case Timeout

}

extension ExampleOptions: Options {

    var type: OptionType {

        switch self {

        case .Force:
            return .Flag(short: "f", long: "force", hasValue: false, required: false)

        case .URL:
            return .Indexed(index: 0, required: true)

        case .Timeout:
            return .Flag(short: "t", long: "timeout", hasValue: true, required: false)
        }
    }
}

let arguments = Arguments<ExampleOptions>(options: [.Force, .URL, .Timeout])
let value = arguments.valueForOption(.Timeout)
let URL = arguments.valueForOption(.URL)

print(value)
print(URL)
