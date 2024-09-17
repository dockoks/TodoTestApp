import UIKit

final class SegmentedControlButton: UIView {
    private let titleLabel = UILabel()
    private let countLabel = TagLabel()
    private let stackView = UIStackView()

    var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    init(title: String, count: Int) {
        super.init(frame: .zero)
        setupView()
        configure(title: title, count: count)
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        updateAppearance()
    }

    private func setupView() {
        // Настройка stackView
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Настройка titleLabel
        titleLabel.font = TodoFont.Styles.body
        titleLabel.textColor = ColorPalette.Text.tertiary
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        // Настройка countLabel
        countLabel.font = TodoFont.Styles.caption2
        countLabel.textColor = ColorPalette.Background.layerOne
        countLabel.backgroundColor = ColorPalette.Text.tertiary
        countLabel.layer.cornerRadius = 10
        countLabel.layer.masksToBounds = true
        countLabel.textAlignment = .center
        countLabel.setContentHuggingPriority(.required, for: .horizontal)
        countLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // Добавление subviews
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countLabel)
        addSubview(stackView)

        // Установка ограничений
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            countLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            countLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }

    private func configure(title: String, count: Int) {
        titleLabel.text = title
        countLabel.text = "\(count)"
    }

    private func updateAppearance() {
        if isSelected {
            titleLabel.textColor = ColorPalette.Main.primaryBlue
            countLabel.backgroundColor = ColorPalette.Main.primaryBlue
        } else {
            titleLabel.textColor = ColorPalette.Text.tertiary
            countLabel.backgroundColor = ColorPalette.Text.tertiary
        }
    }

    func updateCount(_ count: Int) {
        countLabel.text = "\(count)"
    }
}
