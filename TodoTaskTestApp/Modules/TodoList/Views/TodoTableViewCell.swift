import UIKit

final class TodoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TodoTableViewCellIdentifier"
    
    private let containerView = UIView()
    private let textStackView = UIStackView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let radioButton = UIButton()
    private let separatorView = UIView()
    private let dateLabel = UILabel()
    
    var onToggleCompletion: ((Todo) -> Void)?
    private var todo: Todo?
    
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
        
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        radioButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        radioButton.contentVerticalAlignment = .fill
        radioButton.contentHorizontalAlignment = .fill
        radioButton.imageView?.contentMode = .scaleAspectFit
        radioButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
        separatorView.backgroundColor = ColorPalette.Outline.light
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            textStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            textStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            textStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: radioButton.leadingAnchor, constant: -12),
            
            radioButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            radioButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            radioButton.widthAnchor.constraint(equalToConstant: 44),
            radioButton.heightAnchor.constraint(equalToConstant: 44),
            
            separatorView.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 12),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            dateLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
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
        containerView.layer.cornerRadius = 12
        containerView.layer.cornerCurve = .continuous
        containerView.layer.masksToBounds = true
        containerView.applyShadow(color: .black)
    }
    
    // MARK: - Configure Cell
    func configure(with todo: Todo) {
        self.todo = todo
        nameLabel.text = todo.name
        if let description = todo.description, !description.isEmpty {
            descriptionLabel.text = todo.description
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
        dateLabel.text = formatDate(todo.dateCreated)
        
        updateAppearance(for: todo.isCompleted)
    }
    
    // MARK: - Update Appearance Based on Completion
    private func updateAppearance(for isCompleted: Bool) {
        UIView.performWithoutAnimation {
            if isCompleted {
                applyStrikethrough(to: nameLabel)
                radioButton.isSelected = true
                radioButton.tintColor = ColorPalette.Main.primaryBlue
            } else {
                removeStrikethrough(from: nameLabel)
                radioButton.isSelected = false
                radioButton.tintColor = ColorPalette.Text.tertiary
            }
        }
    }
    
    // MARK: - Radio Button Tap
    @objc private func radioButtonTapped() {
        guard var todo = self.todo else { return }

        todo.isCompleted.toggle()
        self.todo = todo
        
        updateAppearance(for: todo.isCompleted)
        onToggleCompletion?(todo)
    }
    
    // MARK: - Helper Methods
    private func applyStrikethrough(to label: UILabel) {
        guard let text = label.text else { return }
        let attributedString = NSAttributedString(string: text, attributes: [
            .font: label.font as Any,
            .foregroundColor: label.textColor as Any,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ])
        label.attributedText = attributedString
    }
    
    private func removeStrikethrough(from label: UILabel) {
        guard let text = label.text else { return }
        let attributedString = NSAttributedString(string: text, attributes: [
            .font: label.font as Any,
            .foregroundColor: label.textColor as Any
        ])
        label.attributedText = attributedString
    }
    
    private func formatDate(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
