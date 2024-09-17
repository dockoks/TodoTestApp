import UIKit

class TodoTextView: UITextView {

    // MARK: - Styles Enum

    enum Style {
        case primary
        case secondary
    }

    // MARK: - Properties

    private var textInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    /// Placeholder text shown when there is no other text
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    private let placeholderLabel = UILabel()

    // MARK: - Initialization

    init(style: Style) {
        super.init(frame: .zero, textContainer: nil)
        setupAppearance(style: style)
        setupTextContainer()
        setupPlaceholder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAppearance(style: .primary) // Default style
        setupTextContainer()
        setupPlaceholder()
    }

    // MARK: - Deinitialization

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Overrides

    override var text: String! {
        didSet {
            textDidChange()
        }
    }

    override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }

    // MARK: - Private Methods

    private func setupAppearance(style: Style) {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorPalette.Outline.light.cgColor
        self.layer.cornerRadius = 8
        self.layer.cornerCurve = .continuous
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .primary:
            self.font = TodoFont.Styles.body
            self.textColor = ColorPalette.Text.primary
        case .secondary:
            self.font = TodoFont.Styles.footnote
            self.textColor = ColorPalette.Text.secondary
        }
    }

    private func setupTextContainer() {
        // Adjust text container insets
        self.textContainerInset = textInsets
        self.textContainer.lineFragmentPadding = 0
    }

    private func setupPlaceholder() {
        placeholderLabel.font = self.font
        placeholderLabel.textColor = ColorPalette.Text.tertiary // Or use a predefined color
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)

        // Constraints to match the text insets
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: textInsets.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textInsets.left),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textInsets.right)
        ])

        // Observe text changes to hide/show placeholder
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)

        // Initial placeholder visibility
        placeholderLabel.isHidden = !self.text.isEmpty
    }

    @objc func textDidChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }

    // MARK: - Public Properties

    /// Allows customization of text insets
    var textPadding: UIEdgeInsets {
        get {
            return textContainerInset
        }
        set {
            textContainerInset = newValue
            updatePlaceholderConstraints()
        }
    }

    // MARK: - Private Methods

    private func updatePlaceholderConstraints() {
        // Update placeholder constraints when text insets change
        NSLayoutConstraint.deactivate(placeholderLabel.constraints)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textContainerInset.left),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textContainerInset.right)
        ])
    }
}
