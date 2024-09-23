import UIKit

final class TodoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TodoTableViewCellIdentifier"
    
    private let containerView = UIView()
    private let textStackView = UIStackView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let radioButton = TodoRadioButton()
    private let separatorView = UIView()
    private let dateLabel = UILabel()
    
    var onToggleCompletion: ((Todo) -> Void)?
    private var todo: Todo?
    
    // MARK: - Constants
    private enum Constants {
        static let containerVerticalPadding: CGFloat = 8
        static let containerHorizontalPadding: CGFloat = 16
        static let containerCornerRadius: CGFloat = 12
        static let textStackHeight: CGFloat = 44
        static let contentPadding: CGFloat = 16
        static let radioButtonPadding: CGFloat = -8
        static let radioButtonSize: CGFloat = 44
        static let separatorTopPadding: CGFloat = 12
        static let separatorHeight: CGFloat = 1
        static let dateLabelTopPadding: CGFloat = 12
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupCellAppearance()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(textStackView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(radioButton)
        containerView.addSubview(separatorView)
        
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.alignment = .leading
        textStackView.distribution = .fill
        
        descriptionLabel.font = TodoFont.Styles.footnote
        descriptionLabel.textColor = ColorPalette.Text.secondary
        descriptionLabel.numberOfLines = 1
        
        nameLabel.font = TodoFont.Styles.body
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakStrategy = .hangulWordPriority
        
        dateLabel.font = TodoFont.Styles.caption
        dateLabel.textColor = ColorPalette.Text.secondary
        
        separatorView.backgroundColor = ColorPalette.Outline.light
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.containerVerticalPadding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.containerHorizontalPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.containerHorizontalPadding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.containerVerticalPadding),
            
            textStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.textStackHeight),
            textStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.contentPadding),
            textStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.contentPadding),
            textStackView.trailingAnchor.constraint(equalTo: radioButton.leadingAnchor, constant: -12),
            
            radioButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.radioButtonPadding),
            radioButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.contentPadding),
            radioButton.widthAnchor.constraint(equalToConstant: Constants.radioButtonSize),
            radioButton.heightAnchor.constraint(equalToConstant: Constants.radioButtonSize),
            
            separatorView.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: Constants.separatorTopPadding),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.contentPadding),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.contentPadding),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            
            dateLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.dateLabelTopPadding),
            dateLabel.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.contentPadding),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.contentPadding)
        ])
        
        radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.attributedText = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        radioButton.isSelected = false
        todo = nil
    }
    
    // MARK: - Cell Appearance
    private func setupCellAppearance() {
        self.backgroundColor = .clear
        containerView.backgroundColor = ColorPalette.Background.layerTwo
        containerView.layer.cornerRadius = Constants.containerCornerRadius
        containerView.layer.cornerCurve = .continuous
        containerView.layer.masksToBounds = true
        containerView.applyShadow(color: .black)
    }
    
    // MARK: - Configure Cell
    func configure(with todo: Todo) {
        self.todo = todo
        nameLabel.text = todo.name
        if let description = todo.description, !description.isEmpty {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
        dateLabel.text = formatDate(todo.dateCreated)
        radioButton.configure(isCompleted: todo.isCompleted)
    }
    
    // MARK: - Radio Button Tap
    @objc private func radioButtonTapped() {
        guard var todo = self.todo else { return }
        todo.isCompleted.toggle()
        self.todo = todo
        
        radioButton.configure(isCompleted: todo.isCompleted)
        onToggleCompletion?(todo)
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
