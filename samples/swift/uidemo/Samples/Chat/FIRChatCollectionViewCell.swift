//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Firebase

/// Displays an individual chat message inside of a FIRChatViewController.
class FIRChatCollectionViewCell: UICollectionViewCell {
  @IBOutlet private(set) var textLabel: UILabel! {
    didSet {
      textLabel.font = FIRChatCollectionViewCell.messageFont
    }
  }
  
  static func boundingRectForText(text: String, maxWidth: CGFloat) -> CGRect {
    let attributes = [NSFontAttributeName: FIRChatCollectionViewCell.messageFont]
    let rect = text.boundingRectWithSize(CGSize(width: maxWidth, height: CGFloat.max),
                                         options: [.UsesLineFragmentOrigin],
                                         attributes: attributes,
                                         context: nil)
    return rect
  }
  
  @IBOutlet var containerView: UIView! {
    didSet {
      containerView.layer.cornerRadius = 8
      containerView.layer.masksToBounds = true
    }
  }
  
  /// These constraints are used to left- and right-align chat bubbles.
  @IBOutlet private(set) var leadingConstraint: NSLayoutConstraint!
  @IBOutlet private(set) var trailingConstraint: NSLayoutConstraint!
  
  /// The font used to display chat messages.
  /// This is the source of truth for the message font,
  /// overriding whatever is set in interface builder.
  static var messageFont: UIFont {
    return UIFont.systemFontOfSize(UIFont.systemFontSize())
  }
  
  /// Colors for messages (text and background) sent from the client.
  /// White text on a blue background, similar to the Messages app.
  static var selfColors: (background: UIColor, text: UIColor) {
    return (
      background: UIColor(red: 21 / 255, green: 60 / 255, blue: 235 / 255, alpha: 1),
      text: UIColor.whiteColor()
    )
  }
  
  /// Colors for messages received by the client.
  /// Black text on a light gray background, similar to the Messages app.
  static var othersColors: (background: UIColor, text: UIColor) {
    return (
      background: UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1),
      text: UIColor.blackColor()
    )
  }
  
  /// Sets the cell's contents and lays out the cell according
  /// to the contents set.
  func populateCellWithChat(chat: Chat, user: FIRUser?, maxWidth: CGFloat) {
    self.textLabel.text = chat.text
    
    let leftRightPadding: CGFloat = 24
    let rect = FIRChatCollectionViewCell.boundingRectForText(self.textLabel.text!,
                                                          maxWidth: maxWidth)
    
    let constant = max(maxWidth - rect.size.width - leftRightPadding, CGFloat.min)
    if chat.uid == user?.uid ?? "" {
      let colors = FIRChatCollectionViewCell.selfColors
      self.containerView.backgroundColor = colors.background
      self.textLabel.textColor = colors.text
      self.trailingConstraint.active = false
      self.leadingConstraint.constant = constant
      self.leadingConstraint.active = true
    } else {
      let colors = FIRChatCollectionViewCell.othersColors
      self.containerView.backgroundColor = colors.background
      self.textLabel.textColor = colors.text
      self.leadingConstraint.active = false
      self.trailingConstraint.constant = constant
      self.trailingConstraint.active = true
    }
  }
}
