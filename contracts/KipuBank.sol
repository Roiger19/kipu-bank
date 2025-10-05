// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title KipuBank
 * @author Juan Pablo Soto Roig (Estudiante)
 * @notice Banco básico para depositar y retirar ETH con límites de seguridad.
 */
contract KipuBank {
    /// @notice Límite máximo por retiro (inmutable)
    uint256 public immutable MAX_WITHDRAW;
    /// @notice Límite total de depósitos permitidos (inmutable)
    uint256 public immutable BANK_CAP;

    /// @notice Mapeo de cada usuario => balance de su bóveda
    mapping(address => uint256) private balances;

    /// @notice Total acumulado en el banco
    uint256 public totalDeposited;

    /// @notice Eventos para registrar depósitos y retiros
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    /// @notice Errores personalizados
    error CapExceeded(uint256 attempted, uint256 available);
    error InsufficientFunds(uint256 balance, uint256 attempted);
    error WithdrawLimit(uint256 attempted, uint256 max);
    error TransferFailed(address to, uint256 amount);

    /// @notice Protege contra reentradas
    bool private locked;
    modifier nonReentrant() {
        require(!locked, "Reentrancy");
        locked = true;
        _;
        locked = false;
    }

    /// @notice Constructor con los límites iniciales
    constructor(uint256 _maxWithdraw, uint256 _bankCap) {
        MAX_WITHDRAW = _maxWithdraw;
        BANK_CAP = _bankCap;
    }

    /// @notice Permite depositar ETH al contrato
    function deposit() external payable {
        uint256 amount = msg.value;
        if (totalDeposited + amount > BANK_CAP)
            revert CapExceeded(amount, BANK_CAP - totalDeposited);

        balances[msg.sender] += amount;
        totalDeposited += amount;

        emit Deposited(msg.sender, amount);
    }

    /// @notice Retira ETH del contrato, hasta el límite permitido
    function withdraw(uint256 amount) external nonReentrant {
        if (amount > MAX_WITHDRAW)
            revert WithdrawLimit(amount, MAX_WITHDRAW);
        uint256 bal = balances[msg.sender];
        if (amount > bal) revert InsufficientFunds(bal, amount);

        balances[msg.sender] -= amount;
        totalDeposited -= amount;
        _safeTransfer(msg.sender, amount);

        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Devuelve el balance de una cuenta
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    /// @notice Envía ETH de forma segura
    function _safeTransfer(address to, uint256 amount) private {
        (bool ok, ) = to.call{value: amount}("");
        if (!ok) revert TransferFailed(to, amount);
    }

    /// @notice Permite recibir ETH directamente
    receive() external payable {
    uint256 amount = msg.value;
    if (totalDeposited + amount > BANK_CAP)
        revert CapExceeded(amount, BANK_CAP - totalDeposited);

    balances[msg.sender] += amount;
    totalDeposited += amount;

    emit Deposited(msg.sender, amount);
}
}
