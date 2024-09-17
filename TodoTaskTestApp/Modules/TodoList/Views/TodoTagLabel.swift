import UIKit

final class TagLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .systemGray
        self.textColor = .systemBackground
        self.font = TodoFont.Styles.caption2
        self.textAlignment = .center
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return textRect.inset(by: UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right))
    }

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let adjustedWidth = size.width + textInsets.left + textInsets.right
        let adjustedHeight = size.height + textInsets.top + textInsets.bottom
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

