(define-map stakes { account: principal } { amount: uint, start-block: uint })
(define-constant REWARD_RATE 100) ; Reward rate per block
(define-constant ADMIN tx-sender)
(define-data-var total-staked uint u0)
(define-data-var reward-pool uint u1000000) ; Initial reward pool
(define-data-var min-stake uint u10) ; Minimum staking amount
(define-data-var lock-period uint u10) ; Lock period before unstaking

(define-public (stake (amount uint))
  (begin
    (asserts! (> amount (var-get min-stake)) (err "Amount must be greater than minimum stake"))
    (let ((existing (map-get? stakes { account: tx-sender })))
      (if existing
        (begin
          (map-set stakes { account: tx-sender }
            { amount: (+ amount (get amount existing)),
              start-block: block-height })
          (var-set total-staked (+ (var-get total-staked) amount))
          (ok "Stake updated"))
        (begin
          (map-set stakes { account: tx-sender }
            { amount: amount, start-block: block-height })
          (var-set total-staked (+ (var-get total-staked) amount))
          (ok "Stake added"))))))