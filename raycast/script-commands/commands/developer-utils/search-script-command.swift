/**
 *  Search Script Command - Raycast Script Command
 *  Copyright (c) Thiago Holanda 2021
 *  https://twitter.com/tholanda
 *
 *  Files related to this Script Command:
 *  - search-script-command.sh
 *  - search-script-command.swift (this file)
 *  - search-script-command (this binary file will be generated by swiftc)
 *
 *  MIT license
 *
 */

import Foundation

// MARK: - Typealiases

typealias Groups = [Group]
typealias ScriptCommands = [ScriptCommand]
typealias NSTextCheckingResults = [NSTextCheckingResult]

// MARK: - Regular Expression Helper

final class RegEx {
  static func checkingResults(for regex: String, in text: String) -> NSTextCheckingResults {
    do {
      let regex = try NSRegularExpression(
        pattern: regex,
        options: [
          .caseInsensitive,
          .anchorsMatchLines,
        ]
      )
      
      let range = NSRange(
        text.startIndex...,
        in: text
      )
      
      return regex.matches(
        in: text,
        range: range
      )
    }
    catch {
      print("Invalid regex: \(error.localizedDescription)")
      return []
    }
  }
}

// MARK: - Models

struct RaycastData: Codable {
  var updatedAt = Date()
  var groups = Groups()
  var totalScriptCommands: Int
}
struct Group: Codable {
  let name: String
  let path: String
  var scriptCommands: ScriptCommands = []
  var subGroups: Groups?
}
struct Icon: Codable {
  let light: String?
  let dark: String?
}
struct ScriptCommand: Codable {
  let identifier: String
  let createdAt: String
  let updatedAt: String
  let schemaVersion: Int
  let title: String
  var filename: String
  let mode: Mode?
  var packageName: String?
  let icon: Icon?
  let authors: [Author]?
  let details: String?
  let currentDirectoryPath: String?
  let needsConfirmation: Bool?
  let refreshTime: String?
  let path: String
  let language: String
  
  private(set) var leadingPath: String = ""
  
  private enum CodingKeys: String, CodingKey {
    case identifier
    case createdAt
    case updatedAt
    case schemaVersion
    case title
    case filename
    case mode
    case packageName
    case icon
    case authors
    case details = "description"
    case currentDirectoryPath
    case needsConfirmation
    case refreshTime
    case path
    case language
  }
  
  mutating func setLeadingPath(_ value: String) {
    self.leadingPath = value
  }
}
extension ScriptCommand {
  typealias Authors = [Author]
  
  struct Author: Codable, CustomStringConvertible {
    let name: String?
    let url: String?
    
    var description: String {
      if let name = name {
        return "\u{001B}[0;33m\(name.trimmedText)\u{001B}[0m"
      }
      else if let url = url {
        return url
      }
      
      return .empty
    }
  }
}
extension ScriptCommand {
  enum Mode: String, Codable {
    case fullOutput
    case compact
    case silent
    case inline
  }
}

// MARK: - Author Extension

extension Array where Element == ScriptCommand.Author {
  var authorDescription: String {
    var authors = String.empty
    
    for author in self {
      let separator = self.separator(for: author.name ?? .empty)
      authors += separator + author.description
    }
    
    return authors
  }
  
  func separator(for currentName: String) -> String {
    if let firstAuthor = first, currentName == firstAuthor.name {
      return .empty
    }
    else if let lastAuthor = last, currentName == lastAuthor.name {
      return Separator.and
    }
    
    return Separator.comma
  }
}

extension ScriptCommand.Authors {
  enum Separator {
    static let and = " and "
    static let comma = ", "
  }
}

// MARK: - Extensions

extension ScriptCommand {
  func contains(_ query: String) -> Bool {
    var description: String = .empty
    
    if let details = self.details {
      description = details
    }
    
    return title.lowercased().contains(query)
      || filename.lowercased().contains(query)
      || description.lowercased().contains(query)
      || language.lowercased().contains(query)
  }
}
extension ScriptCommand: Comparable {
  static func < (lhs: ScriptCommand, rhs: ScriptCommand) -> Bool {
    lhs.title < rhs.title
  }
  
  static func == (lhs: ScriptCommand, rhs: ScriptCommand) -> Bool {
    lhs.title == rhs.title
  }
}
extension Group: Comparable {
  static func < (lhs: Group, rhs: Group) -> Bool {
    lhs.name < rhs.name
  }
  
  static func == (lhs: Group, rhs: Group) -> Bool {
    lhs.name == rhs.name
  }
}

// MARK: - Int Extension

extension Int {
  enum Unit: Int {
    case units = 1
    case tens = 2
    case hundreds = 3
    case thousands = 4
  }
  
  var unitForTotal: Unit {
    switch self {
    case 0..<10:
      return .units
    case 10..<100:
      return .tens
    case 100..<1000:
      return .hundreds
    default:
      return .thousands
    }
  }
  
  func prependZeros(for unit: Unit) -> String {
    let format = "%0\(unit.rawValue)d"
    let counter = String(format: format, self)
    
    return counter
  }
}

// MARK: - String Extension

extension String {
  static var newLine = "\n"
  static var empty = ""
  
  var trimmedText: String {
    trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  private func value(of range: NSRange) -> String? {
    var value: String?
    
    if range.location != NSNotFound, range.length > 0, let rangeString = Range<String.Index>(range, in: self) {
      value = String(self[rangeString])
    }
    
    return value
  }
  
  func clearMarkdownLink() -> String {
    var content = self
    
    let regex = #"\[(.+?)\]\((.+?)\)"#
    let results = RegEx.checkingResults(for: regex, in: content)
    
    results.compactMap { result -> [String]? in
      guard result.numberOfRanges == 3 else {
        return nil
      }
      
      guard
        let match = content.value(of: result.range(at: 0)),
        let value = content.value(of: result.range(at: 1))
      else {
        return nil
      }
      
      return [match, value]
    }
    .forEach { item in
      content = content.replacingOccurrences(of: item[0], with: item[1])
    }
    
    return content.trimmedText
  }
}

// MARK: - Store

final class ScriptCommandsStore {
  enum StoreError: Error {
    case emptyData
  }
  
  private var totalScriptCommands: Int = 0
  
  private var scriptCommands: ScriptCommands = []
  
  private let extensionsURL = URL(string: "https://raw.githubusercontent.com/raycast/script-commands/master/commands/extensions.json")
  
  private func githubURL(for path: String) -> String {
    "https://github.com/raycast/script-commands/blob/master/commands/\(path)"
  }
  
  private func loadData() throws -> RaycastData {
    let urlSession = URLSession.shared
    var data: Data?
    
    let semaphore = DispatchSemaphore(value: 0)
    
    guard let url = extensionsURL else {
      throw URLError(.badURL)
    }
    
    let task = urlSession.dataTask(with: url) { responseData, response, error in
      data = responseData
      
      semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()
    
    guard let unwrappedData = data else {
      throw StoreError.emptyData
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let raycastData = try decoder.decode(RaycastData.self, from: unwrappedData)
    
    return raycastData
  }
  
  func searchCommand(using query: String) {
    do {
      let data = try loadData()
      totalScriptCommands = data.totalScriptCommands
      
      search(for: query, in: data.groups)
      
      if scriptCommands.count > 0 {
        print(
          renderOutput(
            for: scriptCommands
          )
        )
      }
      else {
        print("No script command found with '\(query)'")
      }
    }
    catch {
      print(error)
      exit(1)
    }
  }
  
  private func search(for query: String, in groups: Groups) {
    for group in groups {
      search(
        for: query,
        in: group,
        leadingPath: group.path
      )
    }
    
    scriptCommands = scriptCommands.sorted()
  }
  
  private func search(for query: String, in group: Group, leadingPath: String = "") {
    if group.scriptCommands.count > 0 {
      for var scriptCommand in group.scriptCommands {
        
        if scriptCommand.contains(query) {
          scriptCommand.setLeadingPath(
            "\(leadingPath)/\(scriptCommand.filename)"
          )
          
          self.scriptCommands.append(scriptCommand)
        }
      }
    }
    
    if let subGroups = group.subGroups {
      for subGroup in subGroups {
        search(
          for: query,
          in: subGroup,
          leadingPath: "\(leadingPath)/\(subGroup.path)"
        )
      }
    }
  }
  
  private func renderOutput(for scriptCommands: ScriptCommands) -> String {
    let total = scriptCommands.count
    let unit = total.unitForTotal
    var contentString = "Script Commands found: \u{001B}[0;32m\(total)\u{001B}[0m in \u{001B}[0;32m\(totalScriptCommands)\u{001B}[0m"
    
    for (index, scriptCommand) in scriptCommands.enumerated() {
      var title = String.empty
      var author = String.empty
      
      if let value = scriptCommand.authors {
        author = "(by \(value.authorDescription))"
      }
      
      let position = Int(index + 1).prependZeros(for: unit)
      title = "\(position)) \u{001B}[0;31m\(scriptCommand.title.clearMarkdownLink())\u{001B}[0m \(author)"
      
      if contentString.count > 0 {
        contentString += .newLine + .newLine
      }
      
      contentString += title.trimmedText
      
      if let details = scriptCommand.details {
        contentString += .newLine
        contentString += details.clearMarkdownLink()
      }
      
      contentString += .newLine
      contentString += "Language: \u{001B}[0;31m\(scriptCommand.language.capitalized)\u{001B}[0m"
      
      contentString += .newLine
      contentString += githubURL(for: scriptCommand.leadingPath)
    }
    
    return contentString
  }
}

if CommandLine.arguments.count > 1 {
  let query = CommandLine.arguments[1].lowercased().trimmedText

  if query.isEmpty {
    print("Query must not be empty")
  }
  else {
    let store = ScriptCommandsStore()
    store.searchCommand(using: query)
  }
}