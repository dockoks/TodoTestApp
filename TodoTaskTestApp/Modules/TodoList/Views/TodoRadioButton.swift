import UIKit

final class TodoRadioButton: UIButton {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setImage(UIImage(systemName: "circle"), for: .normal)
        setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        addTarget(self, action: #selector(toggleSelectedState), for: .touchUpInside)
    }
    
    // MARK: - Toggle Button State
    @objc private func toggleSelectedState() {
        isSelected.toggle()
        updateAppearance()
    }
    
    // MARK: - Update Appearance Based on State
    private func updateAppearance() {
        tintColor = isSelected ? ColorPalette.Main.primaryBlue : ColorPalette.Text.tertiary
    }
    
    // MARK: - Configure for External Use
    func configure(isCompleted: Bool) {
        isSelected = isCompleted
        updateAppearance()
    }
}
