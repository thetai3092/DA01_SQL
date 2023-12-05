select distinct advertising_channel from uber_advertising
WHERE money_spent > 100000
AND year IN (2019);
