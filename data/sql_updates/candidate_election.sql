drop materialized view if exists ofec_candidate_election_mv_tmp;
create materialized view ofec_candidate_election_mv_tmp as
with years as (
    select
        candidate_id,
        unnest(election_years) as cand_election_year
    from ofec_candidate_detail_mv_tmp
)
select distinct on (years.candidate_id, years.cand_election_year)
    years.candidate_id,
    years.cand_election_year,
    greatest(
        prev.cand_election_year,
        years.cand_election_year - election_duration(substr(years.candidate_id, 1, 1))
    ) as prev_election_year
from years
left join years prev on
    years.candidate_id = prev.candidate_id and
    prev.cand_election_year < years.cand_election_year
order by
    years.candidate_id,
    years.cand_election_year,
    prev.cand_election_year desc
;

create unique index on ofec_candidate_election_mv_tmp (candidate_id, cand_election_year);

create index on ofec_candidate_election_mv_tmp (candidate_id);
create index on ofec_candidate_election_mv_tmp (cand_election_year);
create index on ofec_candidate_election_mv_tmp (prev_election_year);
