;; v1 - Reown Bridge (Basado en LNSwap)
(define-constant ERR_SWAP_NOT_FOUND (err u1000))
(define-constant ERR_HASH_ALREADY_EXISTS (err u1005))

(define-map bridge-escrow
  { hash: (buff 32) }
  {
    amount: uint,
    timelock: uint,
    initiator: principal,
    claimPrincipal: principal,
  }
)

;; CAMBIO MÍNIMO: Nombre de función único para tu proyecto
(define-public (reownLock
    (preimageHash (buff 32))
    (amount uint)
    (timelock uint)
    (claimPrincipal principal)
  )
  (begin
    (asserts! (> amount u0) (err u1004))
    (asserts! (is-none (map-get? bridge-escrow { hash: preimageHash }))
      ERR_HASH_ALREADY_EXISTS
    )
    ;; Transferencia al contrato
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    
    (map-set bridge-escrow { hash: preimageHash } {
      amount: amount,
      timelock: timelock,
      initiator: tx-sender,
      claimPrincipal: claimPrincipal,
    })
    (ok true)
  )
)

(define-read-only (get-bridge-data (preimageHash (buff 32)))
  (map-get? bridge-escrow { hash: preimageHash })
)
