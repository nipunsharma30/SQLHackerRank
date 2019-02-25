select max(minimum_rooms_required) 
from 
(
select 
count(*) minimum_rooms_required 
from meetings t 
left join meetings y 
on 
(t.start_time >= y.start_time and t.start_time < y.end_time) 
group by t.id) z;










with
	t1 as (
		select first_player , sum(first_score) as s1 from matches group by first_player
	),
	t2 as (
		select second_player, sum(second_score) as s2 from matches group by second_player
	),
	t3 as (
		select p.* , a.s1 , b.s2 , coalesce(a.s1,0) + coalesce(b.s2,0) as total
		from players p
		left join t1 as a
			on p.player_id = a.first_player 
		left join t2 as b
			on p.player_id = b.second_player
	),
	t4 as (
		select * , row_number() over(partition by group_id order by total desc , player_id asc ) as rn from t3
	)
	select group_id , player_id as winner_id from t4 where rn=1 ;