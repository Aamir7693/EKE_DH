;; This is a minimal template for a CPSA input file.

;; Replace <TITLE> with the desired title and <PROTONAME>
;; with the desired name of your project.

;; The defrole template below may be copied and used as
;; a starting point for the roles of your protocol.
;; Change the <ROLENAME> field in each copy as desired.
;; Roles must have distinct names.

;; The basic cryptoalgebra is selected by default. If
;; your project requires the diffie-hellman algebra,
;; delete "basic" on the defprotocol line, uncomment
;; "diffie-hellman" on this same line and uncomment
;; the "(algebra diffie-hellman)" statement in the
;; herald.

;; Refer to the CPSA manual for more information
;; about syntax and additional features.

(herald "Encrypted Key Exchange - Diffie-Hellman"
	 (algebra diffie-hellman)
	 (reverse-nodes)
	 (try-old-strands)
	)

(defprotocol EKE_DH diffie-hellman

  (defrole client
    (vars (a b name) (sec rndx) (g base) (r1 r2 text) )
    (trace
	  (send (cat a (enc (exp (gen) sec) (ltk a b))))
	  (recv (cat (enc g (ltk a b)) (enc r1 (exp g sec))))
	  (send (enc r1 r2 (exp g sec)))
	  (recv (enc r2 (exp g sec)))
     )
	   (uniq-gen sec)
    )
	
	
	(defrole server
    (vars (a b name) (sec1 rndx) (h base) (r1 r2 text) )
    (trace
	  (recv (cat a (enc h (ltk a b))))
	  (send (cat (enc (exp (gen) sec1) (ltk a b)) (enc r1 (exp h sec1)) ))
	  (recv (enc r1 r2 (exp h sec1)))
	  (send (enc r2 (exp h sec1)))
     )
	   (uniq-gen sec1)
    )

)
  
  ;For Testing only
  (defskeleton EKE_DH
  (vars (a b name) (sec sec1 rndx) (r1 r2 text))
  (defstrand client 4 (a a) (b b) (sec sec) (r2 r2) )
  (defstrand server 4 (a a) (b b) (sec1 sec1) (r1 r1) )
  (uniq-orig r1 r2)
  (non-orig (ltk a b))
  (comment "---For Testing only Client and Server's point-of-view")
  )
  
  (defskeleton EKE_DH
  (vars (a b name) (x sec1 rndx) (r1 r2 text))
  (defstrand client 4 (a a) (b b) (sec sec) (r2 r2) )  
  (uniq-orig r2)
  (non-orig (ltk a b))
  (comment "---Client's point-of-view")
  )
  (defskeleton EKE_DH
  (vars (a b name) (sec sec1 rndx) (r1 r2 text))
  (defstrand server 4 (a a) (b b) (sec1 sec1) (r1 r1) )
  (uniq-orig r1)
  (non-orig (ltk a b))
  (comment "---Server's point-of-view")
  )
  
  ;For Testing only
  (defskeleton EKE_DH
  (vars (a b name) (sec sec1 rndx) (r1 r2 text))
  (defstrand client 4 (a a) (b b) (sec sec) (r2 r2) )
  (defstrand server 4 (a a) (b b) (sec1 sec1) (r1 r1) )
  (deflistener sec)
  (deflistener sec1)
  (uniq-orig r1 r2)
  (non-orig (ltk a b))
  (comment "For Testing only--- Client and Server's point-of-view")
  )
  
  (defskeleton EKE_DH
  (vars (a b name) (x sec1 rndx) (r1 r2 text))
  (defstrand client 4 (a a) (b b) (sec sec) (r2 r2) ) 
  (deflistener sec)
  (deflistener sec1) 
  (uniq-orig r2)
  (non-orig (ltk a b))
  (comment "Client's point-of-view.---Are the secrets sec & sec1 leaked?")
  )
  (defskeleton EKE_DH
  (vars (a b name) (sec sec1 rndx) (r1 r2 text))
  (defstrand server 4 (a a) (b b) (sec1 sec1) (r1 r1) )
  (deflistener sec)
  (deflistener sec1)
  (uniq-orig r1)
  (non-orig (ltk a b))
  (comment "Server's point-of-view.---Are the secrets sec & sec1 leaked?")
  )
