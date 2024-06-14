//
//  String+.swift
//  ILikeShopping
//
//  Created by 김성민 on 6/14/24.
//

import Foundation

// MARK: - Edit HTML String

extension String {
  
  // MARK: Initializers
  
  init?(htmlEncodedString: String) {
    guard let data = htmlEncodedString.data(using: .utf8) else { return nil }
    
    let options: [NSAttributedString.DocumentReadingOptionKey:Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      return nil
    }
    self.init(attributedString.string)
  }
}
