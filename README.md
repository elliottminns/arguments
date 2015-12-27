Arguments
=========

A swift package for easily defining and retrieve command line arguments and values.

## Requirements
* Swift 2.2

## Installation

### SPM (Swift Package Manager)

To install via the swift package manager, add this line to your Package.swift file:

```
.Package(url: "https://github.com/elliott-minns/Arguments.git",
                 majorVersion: 1),
```

## Usage

To use arguments, first you need to define a set of options that you want your application to expect. 

To do this, it is recommended to use an enum to specify the various options.
For example: 

```
import Arguments

enum ExampleOptions {

    case Force
    
    case URL

    case Timeout
}

```

You then need to extend the Options type imported from the Arguments module and implement the required properties.

```
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
```

In the above example, the OptionTypes used are .Flag and .Indexed.

.Flag is used to describe a flag type argument. These usually follow the form of -f or --force and can either have a value afterwards or be a value themselves.

.Indexed is used to describe a parameter that must be passed in a certain order. They usually have no flag before them and tend to be the key point of the arguments.

Once you have set up the options you require, you then create an instance of Arguments and pass in the Option as the generic type, followed by the options you are looking for.

```
let arguments = Arguments<ExampleOptions>(options: [.Force, .URL, .Timeout])
```
