//
//  Colorize.swift
//  MaciASL
//
//  Created by SkyrilHD on 24.12.23.
//

import Cocoa

class ColorTheme: NSObject {

    // The various colors assigned to the syntactic categories
    var text: NSColor
    var background: NSColor
    var string: NSColor
    var number: NSColor
    var comment: NSColor
    var `operator`: NSColor
    var opNoArg: NSColor
    var keyword: NSColor
    var resource: NSColor
    var predefined: NSColor

    // Returns a Dictionary containing the themes registered
    @objc class func allThemes() -> [String: ColorTheme] {
        let light = ColorTheme(colors: [
            NSColor.black,
            NSColor.white,
            NSColor(calibratedRed: 196.0/255.0, green: 26.0/255.0, blue: 22.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 28.0/255.0, green: 0, blue: 207.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 0, green: 116.0/255.0, blue: 0, alpha: 1.0),
            NSColor(calibratedRed: 92.0/255.0, green: 38.0/255.0, blue: 153.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 92.0/255.0, green: 38.0/255.0, blue: 153.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 170.0/255.0, green: 13.0/255.0, blue: 145.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 63.0/255.0, green: 110.0/255.0, blue: 116.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 100.0/255.0, green: 56.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        ])

        let dark = ColorTheme(colors: [
            NSColor.white,
            NSColor(calibratedRed: 30.0/255.0, green: 32.0/255.0, blue: 40.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 219.0/255.0, green: 44.0/255.0, blue: 56.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 120.0/255.0, green: 109.0/255.0, blue: 196.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 65.0/255.0, green: 182.0/255.0, blue: 69.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 0, green: 160.0/255.0, blue: 190.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 0, green: 160.0/255.0, blue: 190.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 178.0/255.0, green: 24.0/255.0, blue: 137.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 131.0/255.0, green: 192.0/255.0, blue: 87.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 198.0/255.0, green: 124.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        ])

        let sunset = ColorTheme(colors: [
            NSColor.black,
            NSColor(calibratedRed: 255.0/255.0, green: 255.0/255.0, blue: 224.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 226.0/255.0, green: 97.0/255.0, blue: 2.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 28.0/255.0, green: 0, blue: 208.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 61.0/255.0, green: 149.0/255.0, blue: 3.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 92.0/255.0, green: 38.0/255.0, blue: 153.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 92.0/255.0, green: 38.0/255.0, blue: 153.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 170.0/255.0, green: 13.0/255.0, blue: 145.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 63.0/255.0, green: 110.0/255.0, blue: 116.0/255.0, alpha: 1.0),
            NSColor(calibratedRed: 100.0/255.0, green: 56.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        ])

        var def = light
        if #available(macOS 10.9, *), NSAppearance.current.name != NSAppearance.Name.aqua {
            def = dark
        }

        let themes: [String: ColorTheme] = [
            "Default": def,
            "Light": light,
            "Dark": dark,
            "Sunset": sunset
        ]

        return themes
    }

    init(colors: [NSColor]) {
        text = colors[0]
        background = colors[1]
        string = colors[2]
        number = colors[3]
        comment = colors[4]
        `operator` = colors[5]
        opNoArg = colors[6]
        keyword = colors[7]
        resource = colors[8]
        predefined = colors[9]
        super.init()
    }
}

class Colorize: NSObject, NSTextStorageDelegate {
    private var view: NSTextView
    private var manager: NSLayoutManager
    private var theme: ColorTheme?

    private static var controls: [String] = [
        "External",
        "Include"
    ]

    private static var constants: [String] = [
        "One",
        "Ones",
        "Revision",
        "Zero"
    ]

    private static var operators: [String] = [
        "AccessAs",
        "Acquire",
        "Add",
        "Alias",
        "And",
        "BankField",
        "Break",
        "BreakPoint",
        "Buffer",
        "Case",
        "Concatenate",
        "ConcatenateResTemplate",
        "CondRefOf",
        "Connection",
        "Continue",
        "CopyObject",
        "CreateBitField",
        "CreateByteField",
        "CreateDWordField",
        "CreateField",
        "CreateQWordField",
        "CreateWordField",
        "DataTableRegion",
        "Debug",
        "Decrement",
        "Default",
        "DefinitionBlock",
        "DeRefOf",
        "Device",
        "Divide",
        "Eisaid",
        "Else",
        "ElseIf",
        "Event",
        "Fatal",
        "Field",
        "FindSetLeftBit",
        "FindSetRightBit",
        "FromBcd",
        "Function",
        "If",
        "Increment",
        "Index",
        "IndexField",
        "LAnd",
        "LEqual",
        "LGreater",
        "LGreaterEqual",
        "LLess",
        "LLessEqual",
        "LNot",
        "LNotEqual",
        "Load",
        "LoadTable",
        "LOr",
        "Match",
        "Method",
        "Mid",
        "Mod",
        "Multiply",
        "Mutex",
        "Name",
        "NAnd",
        "Noop",
        "NOr",
        "Not",
        "Notify",
        "ObjectType",
        "Offset",
        "OperationRegion",
        "Or",
        "Package",
        "PowerResource",
        "Processor",
        "RefOf",
        "Release",
        "Reset",
        "Return",
        "Scope",
        "ShiftLeft",
        "ShiftRight",
        "Signal",
        "SizeOf",
        "Sleep",
        "Stall",
        "Store",
        "Subtract",
        "Switch",
        "ThermalZone",
        "Timer",
        "ToBcd",
        "ToBuffer",
        "ToDecimalString",
        "ToHexString",
        "ToInteger",
        "ToString",
        "ToUuid",
        "Unicode",
        "Unload",
        "Wait",
        "While",
        "XOr"
    ]

    private static var arguments: [String] = [
        "Arg0",
        "Arg1",
        "Arg2",
        "Arg3",
        "Arg4",
        "Arg5",
        "Arg6",
        "Local0",
        "Local1",
        "Local2",
        "Local3",
        "Local4",
        "Local5",
        "Local6",
        "Local7"
    ]

    private static var resources: [String] = [
        "ResourceTemplate",
        "RawDataBuffer",
        "DMA",
        "DWordIO",
        "DWordMemory",
        "DWordSpace",
        "EndDependentFn",
        "ExtendedIO",
        "ExtendedMemory",
        "ExtendedSpace",
        "FixedDma",
        "FixedIO",
        "GpioInt",
        "GpioIo",
        "I2cSerialBus",
        "Interrupt",
        "IO",
        "IRQ",
        "IRQNoFlags",
        "Memory24",
        "Memory32",
        "Memory32Fixed",
        "QWordIO",
        "QWordMemory",
        "QWordSpace",
        "Register",
        "SpiSerialBus",
        "StartDependentFn",
        "StartDependentFnNoPri",
        "UartSerialBus",
        "VendorLong",
        "VendorShort",
        "WordBusNumber",
        "WordIO",
        "WordSpace"
    ]

    private static var keywords: [String] = [
        "AttribQuick",
        "AttribSendReceive",
        "AttribByte",
        "AttribWord",
        "AttribBlock",
        "AttribProcessCall",
        "AttribBlockProcessCall",
        "SMBQuick",
        "SMBSendReceive",
        "SMBByte",
        "SMBWord",
        "SMBBlock",
        "SMBProcessCall",
        "SMBBlockProcessCall",
        "AnyAcc",
        "ByteAcc",
        "WordAcc",
        "DWordAcc",
        "QWordAcc",
        "BufferAcc",
        "AddressingMode7Bit",
        "AddressingMode10Bit",
        "AddressRangeMemory",
        "AddressRangeReserved",
        "AddressRangeNVS",
        "AddressRangeACPI",
        "BusMaster",
        "NotBusMaster",
        "DataBitsFive",
        "DataBitsSix",
        "DataBitsSeven",
        "DataBitsEight",
        "DataBitsNine",
        "ClockPhaseFirst",
        "ClockPhaseSecond",
        "ClockPolarityLow",
        "ClockPolarityHigh",
        "PosDecode",
        "SubDecode",
        "Compatibility",
        "TypeA",
        "TypeB",
        "TypeF",
        "LittleEndian",
        "BigEndian",
        "AttribBytes",
        "AttribRawBytes",
        "AttribRawProcessBytes",
        "FlowControlHardware",
        "FlowControlNone",
        "FlowControlXon",
        "ActiveBoth",
        "ActiveHigh",
        "ActiveLow",
        "Edge",
        "Level",
        "Decode10",
        "Decode16",
        "IoRestrictionNone",
        "IoRestrictionInputOnly",
        "IoRestrictionOutputOnly",
        "IoRestrictionNoneAndPreserve",
        "Lock",
        "NoLock",
        "MTR",
        "MEQ",
        "MLE",
        "MLT",
        "MGE",
        "MGT",
        "MaxFixed",
        "MaxNotFixed",
        "Cacheable",
        "WriteCombining",
        "Prefetchable",
        "NonCacheable",
        "MinFixed",
        "MinNotFixed",
        "UnknownObj",
        "IntObj",
        "StrObj",
        "BuffObj",
        "PkgObj",
        "FieldUnitObj",
        "DeviceObj",
        "EventObj",
        "MethodObj",
        "MutexObj",
        "OpRegionObj",
        "PowerResObj",
        "ProcessorObj",
        "ThermalZoneObj",
        "BuffFieldObj",
        "DDBHandleObj",
        "ParityTypeSpace",
        "ParityTypeMark",
        "ParityTypeOdd",
        "ParityTypeEven",
        "ParityTypeNone",
        "PullDefault",
        "PullUp",
        "PullDown",
        "PullNone",
        "PolarityLow",
        "PolarityHigh",
        "ISAOnlyRanges",
        "NonISAOnlyRanges",
        "EntireRange",
        "ReadWrite",
        "ReadOnly",
        "SystemIO",
        "SystemMemory",
        "PCI_Config",
        "EmbeddedControl",
        "SMBus",
        "SystemCMOS",
        "PciBarTarget",
        "IPMI",
        "GeneralPurposeIo",
        "GenericSerialBus",
        "PCC",
        "FFixedHW",
        "ResourceConsumer",
        "ResourceProducer",
        "Serialized",
        "NotSerialized",
        "Shared",
        "Exclusive",
        "SharedAndWake",
        "ExclusiveAndWake",
        "ControllerInitiated",
        "DeviceInitiated",
        "StopBitsOne",
        "StopBitsOnePlusHalf",
        "StopBitsTwo",
        "StopBitsZero",
        "Width8bit",
        "Width16bit",
        "Width32bit",
        "Width64bit",
        "Width128bit",
        "Width256bit",
        "SparseTranslation",
        "DenseTranslation",
        "TypeTranslation",
        "TypeStatic",
        "Preserve",
        "WriteAsOnes",
        "WriteAsZeros",
        "FourWireMode",
        "ThreeWireMode",
        "Transfer8",
        "Transfer8_16",
        "Transfer16"
    ]

    private static var predefined: [String] = [
        "__DATE__",
        "__FILE__",
        "__LINE__",
        "__PATH__"
    ]

    private static var regString = try? NSRegularExpression(pattern: "\"[^\"\n]*\"", options: [])
    private static var regNumber = try? NSRegularExpression(pattern: "(?<=\\W)(0x[0-9A-Fa-f]+|\\d+|\(constants.joined(separator: "|")))(?=\\W)", options: [])
    private static var regComment = try? NSRegularExpression(pattern: "//.*$", options: .anchorsMatchLines)
    private static var regOperator = try? NSRegularExpression(pattern: "(?<=\\W|^)(\(operators.joined(separator: "|")))\\s*\\(", options: .caseInsensitive)
    private static var regOpNoArg = try? NSRegularExpression(pattern: "\\W(\(operators[31]))\\W", options: [])
    private static var regKeywords = try? NSRegularExpression(pattern: "\\W(\(keywords.joined(separator: "|"))|\(arguments.joined(separator: "|")))\\W", options: [])
    private static var regResources = try? NSRegularExpression(pattern: "\\W(\(resources.joined(separator: "|")))\\W", options: [])
    private static var regPredefined = try? NSRegularExpression(pattern: "\\W(\(controls.joined(separator: "(?=\\s*\\()|") + "(?=\\s*\\()")|\(predefined.joined(separator: "|"))|\(constants[2]))\\W", options: [])

    // Initializes the receiver with the given TextView
    @objc init(textView: NSTextView) {
        view = textView
        manager = textView.textContainer!.layoutManager!
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: "style", options: [.initial], context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "colorize", options: [.initial], context: nil)
    }

    deinit {
        if UserDefaults.standard.bool(forKey: "colorize") {
            disarm()
        }
        UserDefaults.standard.removeObserver(self, forKeyPath: "colorize")
        UserDefaults.standard.removeObserver(self, forKeyPath: "style")
    }

    static var themes: [String: ColorTheme] = ColorTheme.allThemes()

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "colorize" {
            if UserDefaults.standard.bool(forKey: keyPath!) {
                arm()
                colorize()
            } else {
                disarm()
            }
        } else if keyPath == "style" {
            if let selectedTheme = UserDefaults.standard.string(forKey: keyPath!),
               let sTheme = Colorize.themes[selectedTheme] {
                theme = sTheme
                view.backgroundColor = theme!.background
                view.textColor = theme?.text
                view.insertionPointColor = theme?.text
            }
        }
    }

    override func textStorageDidProcessEditing(_ notification: Notification) {
        if !UserDefaults.standard.bool(forKey: "colorize") {
            return
        }

        Colorize.cancelPreviousPerformRequests(withTarget: self, selector: #selector(colorize), object: nil)
        self.perform(#selector(colorize), with: nil, afterDelay: 0.15)
    }

    @objc private func colorize() {
        var range: NSRange = manager.characterRange(forGlyphRange: manager.glyphRange(forBoundingRect: view.visibleRect, in: view.textContainer!), actualGlyphRange: nil)

        manager.removeTemporaryAttribute(.foregroundColor, forCharacterRange: range)

        Colorize.regNumber!.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range(at: 1) {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.number, forCharacterRange: range)
            }
        }

        Colorize.regPredefined?.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range(at: 1) {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.predefined, forCharacterRange: range)
            }
        }

        Colorize.regKeywords!.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range(at: 1) {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.keyword, forCharacterRange: range)
            }
        }

        Colorize.regResources!.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range(at: 1) {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.resource, forCharacterRange: range)
            }
        }

        Colorize.regOperator!.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range(at: 1) {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.operator, forCharacterRange: range)
            }
        }

        Colorize.regOpNoArg!.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range(at: 1) {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.opNoArg, forCharacterRange: range)
            }
        }

        Colorize.regString!.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.string, forCharacterRange: range)
            }
        }

        Colorize.regComment!.enumerateMatches(in: manager.attributedString().string, options: [], range: range) { result, _, _ in
            if let range = result?.range {
                manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.comment, forCharacterRange: range)
            }
        }

        let open = (manager.attributedString().string as NSString).range(of: "/*", options: [], range: range).location
        var close = (manager.attributedString().string as NSString).range(of: "*/", options: [], range: range).location


        if open == close {
            return
        }

        let comments = Scanner(string: manager.attributedString().string)
        comments.scanLocation = range.location

        if open < close {
            comments.scanUpTo("/*", into: nil)
        }

        close = NSMaxRange(range)

        while comments.scanLocation < close {
            range.location = comments.scanLocation
            comments.scanString("/*", into: nil)
            comments.scanUpTo("*/", into: nil)
            comments.scanString("*/", into: nil)
            range.length = comments.scanLocation - range.location
            manager.addTemporaryAttribute(.foregroundColor, value: self.theme!.comment, forCharacterRange: range)
            comments.scanUpTo("/*", into: nil)
        }
    }

    private func arm() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(textStorageDidProcessEditing), name: NSView.boundsDidChangeNotification, object: view.superview)
        notificationCenter.addObserver(self, selector: #selector(textStorageDidProcessEditing), name: NSView.frameDidChangeNotification, object: view.superview)
    }

    private func disarm() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSView.boundsDidChangeNotification, object: view.superview)
        notificationCenter.removeObserver(self, name: NSView.frameDidChangeNotification, object: view.superview)
        manager.removeTemporaryAttribute(.foregroundColor, forCharacterRange: NSRange(location: 0, length: view.string.count))
    }
}
