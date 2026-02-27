

/* Transaction
	Un ensemble d'instructions qui (souvent) modifient des données
	Faire en sorte que ces modifs soient faites dans certaines conditions
	- A Atomicité => tout ou rien
	- C Coherence => Data ok avant et après transaction
	- I Isolation => Verrouillage des données
	- Durabilite => une transaction validée doit rester
*/

SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- Defaut
SELECT * FROM Production.Products WHERE productid=10 --Lecture en attente

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT * FROM Production.Products WHERE productid=10 -- Lecture de la valeur non committee

SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SELECT * FROM Production.Products WHERE productid=10 -- Lecture dernière valeur committée

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SELECT * FROM Production.Products WHERE productid=10 -- Empeche les modifs sur les valeurs lues