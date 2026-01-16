//  Created by Marcin Krzyzanowski
//  https://github.com/krzyzanowskim/STTextView/blob/main/LICENSE.md

import AppKit
import STTextKitPlus

extension STTextView {

    func setSelectedTextRange(_ textRange: NSTextRange, updateLayout: Bool) {
        guard isSelectable, textRange.endLocation <= textLayoutManager.documentRange.endLocation else {
            return
        }

        textLayoutManager.textSelections = [
            NSTextSelection(range: textRange, affinity: .downstream, granularity: .character)
        ]

        updateTypingAttributes(at: textRange.location)

        if updateLayout {
            needsLayout = true
        }
    }

    func setSelectedRange(_ range: NSRange) {
        guard let textRange = NSTextRange(range, in: textContentManager) else {
            logger.warning("Invalid range \(range) \(#function)")
            return
        }
        setSelectedTextRange(textRange, updateLayout: true)
    }

    override open func selectAll(_ sender: Any?) {

        guard isSelectable else {
            return
        }

        textLayoutManager.textSelections = [
            NSTextSelection(range: textLayoutManager.documentRange, affinity: .downstream, granularity: .character)
        ]

        updateTypingAttributes()
        updateSelectedRangeHighlight()
        updateSelectedLineHighlight()
        layoutGutter()
    }

    override open func selectLine(_ sender: Any?) {
        guard isSelectable, let enclosingSelection = textLayoutManager.textSelections.last else {
            return
        }

        textLayoutManager.textSelections = [
            textLayoutManager.textSelectionNavigation.textSelection(
                for: .line,
                enclosing: enclosingSelection
            )
        ]

        updateTypingAttributes()
        needsScrollToSelection = true
        needsDisplay = true
    }

    override open func selectWord(_ sender: Any?) {
        guard isSelectable, let enclosingSelection = textLayoutManager.textSelections.last else {
            return
        }

        textLayoutManager.textSelections = [
            textLayoutManager.textSelectionNavigation.textSelection(
                for: .word,
                enclosing: enclosingSelection
            )
        ]

        updateTypingAttributes()
        needsScrollToSelection = true
        needsDisplay = true
    }

    override open func selectParagraph(_ sender: Any?) {
        guard isSelectable, let enclosingSelection = textLayoutManager.textSelections.last else {
            return
        }

        textLayoutManager.textSelections = [
            textLayoutManager.textSelectionNavigation.textSelection(
                for: .paragraph,
                enclosing: enclosingSelection
            )
        ]

        updateTypingAttributes()
        needsScrollToSelection = true
        needsDisplay = true

    }

    override open func moveLeft(_ sender: Any?) {
        setTextSelections(
            direction: .left,
            destination: .character,
            extending: false,
            confined: false
        )
    }

    override open func moveLeftAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .left,
            destination: .character,
            extending: true,
            confined: false
        )
    }

    override open func moveRight(_ sender: Any?) {
        setTextSelections(
            direction: .right,
            destination: .character,
            extending: false,
            confined: false
        )
    }

    override open func moveRightAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .right,
            destination: .character,
            extending: true,
            confined: false
        )
    }

    override open func moveUp(_ sender: Any?) {
        setTextSelections(
            direction: .up,
            destination: .character,
            extending: false,
            confined: false
        )
    }

    override open func moveUpAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .up,
            destination: .character,
            extending: true,
            confined: false
        )
    }

    override open func moveDown(_ sender: Any?) {
        setTextSelections(
            direction: .down,
            destination: .character,
            extending: false,
            confined: false
        )
    }

    override open func moveDownAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .down,
            destination: .character,
            extending: true,
            confined: false
        )
    }

    override open func moveForward(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .character,
            extending: false,
            confined: false
        )
    }

    override open func moveForwardAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .character,
            extending: true,
            confined: false
        )
    }

    override open func moveBackward(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .character,
            extending: false,
            confined: false
        )
    }

    override open func moveBackwardAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .character,
            extending: true,
            confined: false
        )
    }

    override open func moveWordLeft(_ sender: Any?) {
        setTextSelections(
            direction: .left,
            destination: .word,
            extending: false,
            confined: false
        )
    }

    override open func moveWordLeftAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .left,
            destination: .word,
            extending: true,
            confined: false
        )
    }

    override open func moveWordRight(_ sender: Any?) {
        setTextSelections(
            direction: .right,
            destination: .word,
            extending: false,
            confined: false
        )
    }

    override open func moveWordRightAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .right,
            destination: .word,
            extending: true,
            confined: false
        )
    }

    override open func moveWordForward(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .word,
            extending: false,
            confined: false
        )
    }

    override open func moveWordForwardAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .word,
            extending: true,
            confined: false
        )
    }

    override open func moveWordBackward(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .word,
            extending: false,
            confined: false
        )
    }

    override open func moveWordBackwardAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .word,
            extending: true,
            confined: false
        )
    }

    override open func moveToBeginningOfLine(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .line,
            extending: false,
            confined: true
        )
    }

    override open func moveToBeginningOfLineAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .line,
            extending: true,
            confined: true
        )
    }

    override open func moveToLeftEndOfLine(_ sender: Any?) {
        setTextSelections(
            direction: .left,
            destination: .line,
            extending: false,
            confined: true
        )
    }

    override open func moveToLeftEndOfLineAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .left,
            destination: .line,
            extending: true,
            confined: true
        )
    }

    override open func moveToEndOfLine(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .line,
            extending: false,
            confined: true
        )
    }

    override open func moveToEndOfLineAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .line,
            extending: true,
            confined: true
        )
    }

    override open func moveToRightEndOfLine(_ sender: Any?) {
        setTextSelections(
            direction: .right,
            destination: .line,
            extending: false,
            confined: true
        )
    }

    override open func moveToRightEndOfLineAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .right,
            destination: .line,
            extending: true,
            confined: true
        )
    }

    override open func moveParagraphForwardAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .paragraph,
            extending: true,
            confined: false
        )
    }

    override open func moveParagraphBackwardAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .paragraph,
            extending: true,
            confined: false
        )
    }

    override open func moveToBeginningOfParagraph(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .paragraph,
            extending: false,
            confined: true
        )
    }

    override open func moveToBeginningOfParagraphAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .paragraph,
            extending: true,
            confined: true
        )
    }

    override open func moveToEndOfParagraph(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .paragraph,
            extending: false,
            confined: true
        )
    }

    override open func moveToEndOfParagraphAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .paragraph,
            extending: true,
            confined: true
        )
    }

    override open func moveToBeginningOfDocument(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .document,
            extending: false,
            confined: false
        )
    }

    override open func moveToBeginningOfDocumentAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .backward,
            destination: .document,
            extending: true,
            confined: false
        )
    }

    override open func moveToEndOfDocument(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .document,
            extending: false,
            confined: false
        )
    }

    override open func moveToEndOfDocumentAndModifySelection(_ sender: Any?) {
        setTextSelections(
            direction: .forward,
            destination: .document,
            extending: true,
            confined: false
        )
    }

    private func setTextSelections(
        direction: NSTextSelectionNavigation.Direction,
        destination: NSTextSelectionNavigation.Destination,
        extending: Bool,
        confined: Bool
    ) {
        guard isSelectable else { return }

        textLayoutManager.textSelections = textLayoutManager.textSelections.compactMap { textSelection in
            textLayoutManager.textSelectionNavigation.destinationSelection(
                for: textSelection,
                direction: direction,
                destination: destination,
                extending: extending,
                confined: confined
            )
        }

        updateTypingAttributes()
        needsScrollToSelection = true
        needsDisplay = true
    }

    func updateTextSelection(
        interactingAt point: CGPoint,
        inContainerAt location: NSTextLocation,
        anchors: [NSTextSelection] = [],
        extending: Bool,
        isDragging: Bool = false,
        visual: Bool = false
    ) {
        guard isSelectable else { return }

        var modifiers: NSTextSelectionNavigation.Modifier = []
        if extending {
            modifiers.insert(.extend)
        }
        if visual {
            modifiers.insert(.visual)
        }

        let newSelections = textLayoutManager.textSelectionNavigation.textSelections(
            interactingAt: point,
            inContainerAt: location,
            anchors: anchors,
            modifiers: modifiers,
            selecting: isDragging,
            bounds: textLayoutManager.usageBoundsForTextContainer
        )

        if !newSelections.isEmpty {
            textLayoutManager.textSelections = newSelections
        }

        updateTypingAttributes()
        updateSelectedRangeHighlight()
        updateSelectedLineHighlight()
        layoutGutter()
        needsDisplay = true
    }

    public func indentSelection(indent: String = "  ") {
        guard let text = text as NSString? else { return }

        let sel = selectedRange()
        let hadSelection = sel.length > 0
        let caretLocation = sel.location

        let (firstLine, lastLine) = selectedLineSpan(in: text, selection: sel)
        let starts = lineStarts(in: text, fromLine: firstLine, toLine: lastLine)

        guard
            let start = lineStart(in: text, lineIndex: firstLine),
            let end = lineContentsEnd(in: text, lineIndex: lastLine)
        else { return }

        let indentWidth = indent.count
        let totalAdded = indentWidth * starts.count

        textContentManager.performEditingTransaction {
            for loc in starts.sorted(by: >) {
                replaceCharacters(in: NSRange(location: loc, length: 0), with: indent)
            }

            if hadSelection {
                // Preserve block selection
                textSelection = NSRange(
                    location: start,
                    length: max(0, end - start + totalAdded)
                )
            } else {
                // Move caret with the text
                let newCaret = caretLocation + indentWidth
                textSelection = NSRange(location: newCaret, length: 0)
            }
        }
    }

    public func outdentSelection(indent: String = "  ") {
        guard let text = text as NSString? else { return }

        let sel = selectedRange()
        let hadSelection = sel.length > 0
        let caretLocation = sel.location

        let (firstLine, lastLine) = selectedLineSpan(in: text, selection: sel)
        let starts = lineStarts(in: text, fromLine: firstLine, toLine: lastLine)

        var removedFromCaretLine = 0

        undoManager?.beginUndoGrouping()

        textContentManager.performEditingTransaction {
            for (index, start) in starts.sorted(by: >).enumerated() {
                let maxLen = min(indent.count, text.length - start)
                guard maxLen > 0 else { continue }

                let prefix = text.substring(with: NSRange(location: start, length: maxLen))

                let removed: Int
                if prefix.hasPrefix(indent) {
                    removed = indent.count
                    replaceCharacters(in: NSRange(location: start, length: indent.count), with: "")
                } else if prefix.hasPrefix(" ") {
                    removed = 1
                    replaceCharacters(in: NSRange(location: start, length: 1), with: "")
                } else {
                    removed = 0
                }

                // If this is the caret’s line and no selection, track removal
                if !hadSelection && index == 0 {
                    removedFromCaretLine = removed
                }
            }
        }

        undoManager?.endUndoGrouping()

        if hadSelection {
            reselectLines(firstLine: firstLine, lastLine: lastLine)
        } else {
            let newCaret = max(0, caretLocation - removedFromCaretLine)
            textSelection = NSRange(location: newCaret, length: 0)
        }
    }

    private func selectedLineSpan(in ns: NSString, selection: NSRange) -> (Int, Int) {
        if ns.length == 0 { return (0, 0) }
        if selection.length == 0 {
            let line = lineIndex(in: ns, at: selection.location)
            return (line, line)
        }

        let startLine = lineIndex(in: ns, at: selection.location)
        let endPos = max(0, selection.location + selection.length - 1)
        let endLine = lineIndex(in: ns, at: endPos)
        return (startLine, endLine)
    }

    private func lineIndex(in ns: NSString, at location: Int) -> Int {
        var idx = 0
        var pos = 0

        while pos < ns.length {
            var ls = 0, le = 0, ce = 0
            ns.getLineStart(&ls, end: &le, contentsEnd: &ce, for: NSRange(location: pos, length: 0))
            if location >= ls && location < le { return idx }
            idx += 1
            if le <= pos { break }
            pos = le
        }

        return max(0, idx - 1)
    }

    private func lineStarts(in ns: NSString, fromLine first: Int, toLine last: Int) -> [Int] {
        var out: [Int] = []
        var idx = 0
        var pos = 0

        while pos < ns.length {
            var ls = 0, le = 0, ce = 0
            ns.getLineStart(&ls, end: &le, contentsEnd: &ce, for: NSRange(location: pos, length: 0))

            if idx >= first && idx <= last { out.append(ls) }
            if idx > last { break }

            idx += 1
            if le <= pos { break }
            pos = le
        }

        return out
    }

    private func lineStart(in ns: NSString, lineIndex: Int) -> Int? {
        var idx = 0
        var pos = 0

        while pos < ns.length {
            var ls = 0, le = 0, ce = 0
            ns.getLineStart(&ls, end: &le, contentsEnd: &ce, for: NSRange(location: pos, length: 0))
            if idx == lineIndex { return ls }
            idx += 1
            if le <= pos { break }
            pos = le
        }

        return nil
    }

    private func lineContentsEnd(in ns: NSString, lineIndex: Int) -> Int? {
        var idx = 0
        var pos = 0

        while pos < ns.length {
            var ls = 0, le = 0, ce = 0
            ns.getLineStart(&ls, end: &le, contentsEnd: &ce, for: NSRange(location: pos, length: 0))
            if idx == lineIndex { return ce }
            idx += 1
            if le <= pos { break }
            pos = le
        }

        return nil
    }

    func reselectLines(firstLine: Int, lastLine: Int) {
        guard let ns = text as NSString? else { return }
        
        guard
            let start = lineStart(in: ns, lineIndex: firstLine),
            let end   = lineContentsEnd(in: ns, lineIndex: lastLine)
        else { return }

        textSelection = NSRange(
            location: start,
            length: max(0, end - start)
        )

        updateTypingAttributes()
        needsScrollToSelection = true
        needsDisplay = true
    }
}
