KipuBank — Contrato Inteligente en Solidity
Descripción del Proyecto

KipuBank es un contrato inteligente desarrollado en Solidity como parte del examen práctico del Módulo 2 del curso de ETH.KIPU.
El objetivo es demostrar la aplicación de los conceptos fundamentales de Solidity y las buenas prácticas de desarrollo seguro en la blockchain de Ethereum.

Este contrato permite a los usuarios:

Depositar tokens nativos (ETH) en una bóveda personal.
Retirar fondos respetando un límite máximo fijo por transacción.
Consultar su balance almacenado en el contrato.
El sistema mantiene además un límite global de depósitos (bankCap) definido durante el despliegue, y registra los eventos de depósito y retiro junto con la cantidad de operaciones realizadas.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Funcionalidades principales

Depósitos: Los usuarios pueden enviar ETH a su cuenta dentro del contrato usando la función deposit().
Retiros: Los usuarios pueden retirar una cantidad determinada mediante withdraw(amount) respetando el límite máximo por transacción (WITHDRAW_LIMIT).
Consulta de balance: Cualquier usuario puede consultar su saldo mediante getBalance(address).
Eventos: Se emiten eventos Deposited y Withdrawn para registrar operaciones exitosas.
Errores personalizados: El contrato usa errores como CapExceeded, WithdrawLimit, InsufficientFunds para revertir transacciones de forma clara y segura.
Contadores: Registra la cantidad total de depósitos y retiros realizados.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INTERACCIÓN CON EL CONTRATO 

Depositar ETH
En la sección “Value”, escribir el monto (por ejemplo 0.05) y seleccionar ether.
Ejecutar la función:
deposit()
Resultado: se emite el evento Deposited(user, amount).

Retirar ETH
Ejecutar:
withdraw(uint256 amount)
Ejemplo: 50000000000000000 (0.05 ETH)
Si se excede el límite o el saldo disponible, la transacción revierte.

Consultar balance
Ejecutar:
getBalance(address)
Ingresar tu dirección para ver tu saldo almacenado.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Autor

Juan Pablo — Desarrollador Web3 (Estudiante ETH-KIPU Módulo 2)
Repositorio: https://github.com/Roiger19/kipu-bank