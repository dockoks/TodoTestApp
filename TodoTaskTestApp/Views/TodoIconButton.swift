import UIKit

class TodoIconButton: UIButton {
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()
    private let stackView = UIStackView()
    
    enum Style {
        case newTodo
        case saveTodo
        case deleteTodo
        case cancelTodo
    }

    var spacing: CGFloat = 4 {
        didSet {
            stackView.spacing = spacing
        }
    }

    var contentPadding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20) {
        didSet {
            updateContentPadding()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        setupAppearance()
    }
    
    convenience init(_ style: Style) {
        self.init(frame: .zero)
        self.configure(with: style)
    }

    // MARK: - Private Methods

    private func setupViews() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.isUserInteractionEnabled = false

        textLabel.font = TodoFont.Styles.body
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.isUserInteractionEnabled = false
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentPadding.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentPadding.right),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: contentPadding.top),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentPadding.bottom)
        ])
    }

    private func setupAppearance() {
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        backgroundColor = ColorPalette.Main.secondaryBlue
        textLabel.textColor = ColorPalette.Main.primaryBlue
        iconImageView.tintColor = ColorPalette.Main.primaryBlue
        contentHorizontalAlignment = .center
    }

    private func updateContentPadding() {
        NSLayoutConstraint.deactivate(stackView.constraints)
        setupConstraints()
        layoutIfNeeded()
    }
    
    private func configure(with style: Style) {
        switch style {
        case .newTodo:
            configure(title: "New Task", icon: UIImage(systemName: "plus"))
        case .saveTodo:
            configure(title: "Save", icon: UIImage(systemName: "arrow.down"))
        case .deleteTodo:
            configure(title: "Delete", icon: UIImage(systemName: "trash"))
            backgroundColor = ColorPalette.Main.secondaryRed
            textLabel.textColor = ColorPalette.Main.primaryRed
            iconImageView.tintColor = ColorPalette.Main.primaryRed
        case .cancelTodo:
            configure(title: "Cancel", icon: UIImage(systemName: "arrow.left"))
        }
    }

    // MARK: - Public Methods

    func setTitle(_ text: String) {
        textLabel.text = text
    }

    func setIcon(_ image: UIImage?) {
        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
    }

    func configure(title: String, icon: UIImage?) {
        setTitle(title)
        setIcon(icon)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
    }
}

