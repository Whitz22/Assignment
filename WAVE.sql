--Question 1
SELECT COUNT (*) FROM users;
--Question 2
SELECT COUNT (transfer_id) FROM transfers WHERE send_amount_currency='CFA';
--Question 3
SELECT COUNT (Distinct u_id) FROM transfers WHERE send_amount_currency= 'CFA';
--Question 4
SELECT EXTRACT (MONTH FROM when_created) AS tx_MONTH,
COUNT (atx_id) FROM agent_transactions 
WHERE EXTRACT (YEAR FROM  when_created) = '2018' 
GROUP BY EXTRACT (MONTH FROM when_created);

-- Question 5
SELECT 
	COUNT(
		SELECT agent_id FROM agent_transactions
		WHERE when_created BETWEEN
			NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
    		AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER
		GROUP BY
			agent_id
		HAVING
			SUM(amount) > 0
	) as NET_DEPOSITORS,
	
	COUNT(
		SELECT agent_id FROM agent_transactions
		WHERE when_created BETWEEN
			NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
    		AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER
		GROUP BY
			agent_id
		HAVING
			SUM(amount) < 0
	) as NET_WITHDRAWERS;


-- Question 6
SELECT agents.city as City, sum(atx.amount) as Volume
FROM agent_transactions as atx
LEFT JOIN agents
	ON atx.agent_id = agents.agent_id
GROUP BY
	agents.city;
	
-- Question 7
SELECT 
	agents.country as Country, 
	agents.city as City, 
	sum(atx.amount) as Volume
FROM agent_transactions as atx
LEFT JOIN agents
	ON atx.agent_id = agents.agent_id
GROUP BY
	agents.city,
	agents.country;
	
-- Question 8
SELECT 
	wallets.ledger_location as Country,
	transfers.kind as Kind,
	sum(send_amount_scalar)
FROM
	transfers
LEFT JOIN wallets
	ON transfers.source_wallet_id = wallets.wallet_id
WHERE 
	when_created >= NOW() - '1 month'::interval
  	and when_created < NOW()
GROUP BY
	transfers.kind,
	wallets.ledger_location;
	
-- Question 9
SELECT 
	wallets.ledger_location as Country,
	transfers.kind as Kind,
	sum(send_amount_scalar) as Volume,
	count(transfer_id) as Tx_Count,
	count(DISTINCT u_id) as Senders_Count
FROM
	transfers
LEFT JOIN wallets
	ON transfers.source_wallet_id = wallets.wallet_id
WHERE 
	when_created >= NOW() - '1 month'::interval
  	and when_created < NOW()
GROUP BY
	transfers.kind,
	wallets.ledger_location;

-- Question 10
SELECT
	source_wallet_id as Wallet,
	sum(send_amount_scalar) as Amount_Sent
FROM 
	transfers
WHERE
	send_amount_currency = 'CFA'
GROUP BY
	source_wallet_id
HAVING
	sum(send_amount_scalar) > 10000000;









