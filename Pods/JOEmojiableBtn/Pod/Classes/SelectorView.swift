//
//  SelectorView.swift
//  JOEmojiableBtn
//
//  Created by Jorge Raul Ovalle Zuleta on 2/28/16.
//  Copyright © 2016 jorgeovalle. All rights reserved.
//

import UIKit

public protocol SelectorViewDelegate{
    func movedTo(_ point:CGPoint)
    func endTouch(_ point:CGPoint)
}

open class SelectorView: UIView {
    var delegate:SelectorViewDelegate?
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.movedTo((touches.first?.location(in: self))!)
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.endTouch((touches.first?.location(in: self))!)
    }
}
