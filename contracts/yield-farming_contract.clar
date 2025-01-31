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

          (define-public (unstake)
  (let ((existing (map-get? stakes { account: tx-sender })))
    (if existing
      (let ((rewards (calculate-rewards tx-sender)))
        (if (>= (- block-height (get start-block existing)) (var-get lock-period))
          (begin
            (map-delete stakes { account: tx-sender })
            (var-set total-staked (- (var-get total-staked) (get amount existing)))
            (ok { amount: (get amount existing), rewards: rewards }))
          (err "Stake is locked. Wait for lock period to end")))
      (err "No stake found"))))

(define-read-only (calculate-rewards (user principal))
  (let ((existing (map-get? stakes { account: user })))
    (if existing
      (min (* REWARD_RATE (- block-height (get start-block existing))) (var-get reward-pool))
      u0)))

(define-public (withdraw-rewards)
  (let ((rewards (calculate-rewards tx-sender)))
    (if (> rewards u0)
      (begin
        (var-set reward-pool (- (var-get reward-pool) rewards))
        (ok { recipient: tx-sender, amount: rewards }))
      (err "No rewards available"))))

(define-public (set-reward-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender ADMIN) (err "Only admin can update reward rate"))
    (define-constant REWARD_RATE new-rate)
    (ok "Reward rate updated"))))

(define-public (set-min-stake (new-min uint))
  (begin
    (asserts! (is-eq tx-sender ADMIN) (err "Only admin can update min stake"))
    (var-set min-stake new-min)
    (ok "Minimum stake updated"))))
