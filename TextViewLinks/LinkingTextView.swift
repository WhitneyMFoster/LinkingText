//
//  LinkingTextView.swift
//  TextViewLinks
//
//  Created by Whitney Foster on 9/28/16.
//  Copyright © 2016 whitney.io. All rights reserved.
//

import Foundation

private class LinkingAttributedString: NSMutableAttributedString {
    private let attString = NSMutableAttributedString(string: "")
    private var linkName = ""
    private var link = ""
    private var foundChars = [String]()
    private var str = ""
    
    convenience init(text s: String?, attributes a: [String: Any] = [String: Any](), linkAttributes: [String: Any] = [String: Any]()) {
        self.init(string: "")
        self.append(self.formattedAttributedStringWithLinks(text: s ?? "", normalAttributes: a, linkAttributes: linkAttributes))
    }
    
    private func formattedAttributedStringWithLinks(text t: String, normalAttributes: [String: Any] = [String: Any](), linkAttributes: [String: Any] = [String: Any]()) -> NSAttributedString {
        var linkAtt = linkAttributes
        
        let defaultCase: (String) -> Void = {
            (c) in
            if self.foundChars == ["["] {
                // looking for linkName
                self.linkName.append(c)
            }
            else if self.foundChars == ["[", ":"] {
                // looking for space but no space given
            }
            else if self.foundChars == ["[", ":", " "] {
                // looking for link
                self.link.append(c)
            }
            else {
                self.str.append(c)
            }
        }
        for c in t.characters.map({"\($0)"}) {
            switch c {
            case "[":
                foundChars = [c]
                break
            case ":":
                if foundChars == ["["] {
                    // done finding linkName
                    foundChars.append(c)
                }
                else {
                    defaultCase(c)
                }
                break
            case "]":
                if foundChars == ["[", ":", " "] {
                    // done finding link
                    foundChars = [String]()
                    attString.append(NSAttributedString(string: str, attributes: normalAttributes))
                    linkAtt["WFInstructions"] = link
                    attString.append(NSAttributedString(string: linkName, attributes: linkAtt))
                    str = ""
                    link = ""
                    linkName = ""
                }
                else if foundChars == ["[", ":"] {
                    // no link, just underline
                    attString.append(NSAttributedString(string: str, attributes: normalAttributes))
                    linkAtt["WFInstructions"] = link
                    attString.append(NSAttributedString(string: linkName, attributes: linkAtt))
                    str = ""
                    link = ""
                    linkName = ""
                }
                else {
                    defaultCase(c)
                }
                break
            case " ":
                if foundChars == ["[", ":"] {
                    // start finding link
                    foundChars.append(c)
                }
                else {
                    defaultCase(c)
                }
                break
            default:
                defaultCase(c)
                break
            }
        }
        attString.append(NSAttributedString(string: str, attributes: normalAttributes))
        print(attString.string)
        return attString
    }
}

class LinkingTextView: UITextView {
    
    convenience init(string s: String?, attributes: [String: Any] = [String: Any](), linkAttributes: [String: Any] = [String: Any]()) {
        self.init()
        self.attributedText = LinkingAttributedString(text: s, attributes: attributes, linkAttributes: linkAttributes)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LinkingTextView.tappedTextView(gr:))))
    }
    
    internal func tappedTextView(gr: UITapGestureRecognizer) {
        let tap = gr.location(in: gr.view ?? self)
        if var pos1 = self.closestPosition(to: tap), var pos2 = self.position(from: pos1, offset: 1) {
            if let behindPos1 = self.position(from: pos1, offset: -1), let behindPos2 = self.position(from: pos2, offset: -1) {
                pos1 = behindPos1
                pos2 = behindPos2
                
                if let range = self.textRange(from: pos1, to: pos2) {
                    let startOffset = self.offset(from: self.beginningOfDocument, to: range.start)
                    let endOffset = self.offset(from: self.beginningOfDocument, to: range.end)
                    
                    let offsetRange = NSMakeRange(startOffset, endOffset-startOffset)
                    if offsetRange.location != NSNotFound && offsetRange.length != 0 && NSMaxRange(offsetRange) <= self.attributedText.length {
                        let attString = self.attributedText.attributedSubstring(from: offsetRange)
                        let instructions = attString.attribute("WFInstructions", at: 0, effectiveRange: nil)
                        print(instructions)
                    }
                }
            }
            
        }
    }
}
