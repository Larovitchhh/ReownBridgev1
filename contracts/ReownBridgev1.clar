;; v1 - Reown Bridge Final Fix
(define-map bridge-escrow
  { hash: (buff 32) }
  {
    amount: uint,
    timelock: uint,
    initiator: principal,
    claimPrincipal: principal,
  }
)

(define-public (reownLock (preimageHash (buff 32)) (amount uint) (timelock uint) (claimPrincipal principal))
  (begin
    ;; Verificaciones de seguridad
    (asserts! (> amount u0) (err u1004))
    (asserts! (is-none (map-get? bridge-escrow { hash: preimageHash })) (err u1005))
    
    ;; Transferencia al contrato (El motor de Hiro a veces falla aquí si no hay fondos)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    
    ;; Guardar en el mapa
    (map-set bridge-escrow { hash: preimageHash } {
      amount: amount,
      timelock: timelock,
      initiator: tx-sender,
      claimPrincipal: claimPrincipal,
    })
    
    ;; Retorno explícito
    (ok true)
  )
)

(define-read-only (get-bridge-data (preimageHash (buff 32)))
  (ok (map-get? bridge-escrow { hash: preimageHash }))
)
