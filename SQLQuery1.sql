select * from  MATCH_RESULTS


;with matches
as(
select team_a as team , result from MATCH_RESULTS
union all
select team_b as team , result from MATCH_RESULTS)
select  team,
        count(team) as matches_played,
		sum(case when result = team then 1 else 0 end  ) as wins,
		sum(case when result  is null then 1 else 0 end  ) as tied,
		sum(case when result != team then 1 else 0 end  ) as loss
 from matches
group by team
