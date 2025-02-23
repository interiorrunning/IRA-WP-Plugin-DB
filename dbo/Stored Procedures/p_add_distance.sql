CREATE PROCEDURE dbo.`p_add_distance`(    
    in distance decimal(12,9),
    in is_miles bit
)
begin

declare
	distance_id tinyint unsigned;
    
select
	DistanceID into
    distance_id
from
	dbo.distances as d
where
	d.Distance = distance and
    d.IsMiles = is_miles;
    
if distance_id is null then
	insert into
		dbo.distances (
		Distance,
		IsMiles
	) values (
		distance,
		is_miles
	);

	select
		last_insert_id() into
		distance_id;
end if;

insert into
	dbo.factors (
    AgeGradeVersionID,
    IsMale,
    Age,
    DistanceID,
    IsCalculated,
    Factor
)
select
	f.AgeGradeVersionID,    
    f.IsMale,
    f.Age,
    d.DistanceID,
    1,
    case
		when
			f1.Factor is null then
            f2.Factor
		when
			f2.Factor is null then
            f1.Factor
		else
			cast((d.DistanceKm - f1.DistanceKm) /  (f2.DistanceKm - f1.DistanceKm) * f2.Factor +
			(f2.DistanceKm - d.DistanceKm) /  (f2.DistanceKm - f1.DistanceKm) * f1.Factor as decimal(5,4))
	end as Factor
from
	dbo.distances as d
cross join
(
	select distinct
		agv.AgeGradeVersionID,
        f.Age,        
        f.IsMale
    from
		dbo.age_grade_version as agv
	join
		dbo.factors as f on
        f.AgeGradeVersionID = agv.AgeGradeVersionID
) as f
left join lateral
(
	select
		f2.Factor,
		d2.DistanceKm
    from
		dbo.factors as f2
	join
		dbo.distances as d2 on
        d2.DistanceID = f2.DistanceID
	where
		f2.AgeGradeVersionID = f.AgeGradeVersionID and
        f2.IsMale = f.IsMale and
        f2.Age = f.Age and
        f2.IsCalculated = 0 and        
        d2.DistanceKm < d.DistanceKm        
	order by
		d2.DistanceKm desc
	limit 1
) as f1 on 1 = 1
left join lateral
(
	select
		f2.Factor,
		d2.DistanceKm
    from
		dbo.factors as f2
	join
		dbo.distances as d2 on
        d2.DistanceID = f2.DistanceID
	where
		f2.AgeGradeVersionID = f.AgeGradeVersionID and
        f2.IsMale = f.IsMale and
        f2.Age = f.Age and
        f2.IsCalculated = 0 and        
        d2.DistanceKm > d.DistanceKm        
	order by
		d2.DistanceKm 
	limit 1
) as f2 on 1 = 1
where
	d.DistanceID = distance_id and
    not exists (
		select 1
        from
			dbo.factors as f0
		where
			f0.AgeGradeVersionID = f.AgeGradeVersionID and
            f0.IsMale = f.IsMale and
            f0.Age = f.Age and
			f0.DistanceID = d.DistanceID
);

insert into
	dbo.standards (
    AgeGradeVersionID,
    IsMale,
    DistanceID,
    IsCalculated,
    Standard
)
select
	s.AgeGradeVersionID,    
    s.IsMale,  
    d.DistanceID,
    1,
	case
		when
			s1.Standard is null then
			floor(s2.Standard * (d.DistanceKm / s2.DistanceKm))
		when
			s2.Standard is null then
			ceiling(s1.Standard * (d.DistanceKm / s1.DistanceKm))
		else
			round
			(
				(d.DistanceKm - s1.DistanceKm) /  (s2.DistanceKm - s1.DistanceKm) * s2.Standard +
				(s2.DistanceKm - d.DistanceKm) /  (s2.DistanceKm - s1.DistanceKm) * s1.Standard
			)
	end as Standard
from
	dbo.distances as d
cross join
(
	select distinct
		agv.AgeGradeVersionID,        
        s.IsMale
    from
		dbo.age_grade_version as agv
	join
		dbo.standards as s on
        s.AgeGradeVersionID = agv.AgeGradeVersionID
) as s
left join lateral
(
	select
		s2.Standard,
		d2.DistanceKm
    from
		dbo.standards as s2
	join
		dbo.distances as d2 on
        d2.DistanceID = s2.DistanceID
	where
		s2.AgeGradeVersionID = s.AgeGradeVersionID and
        s2.IsMale = s.IsMale and        
        s2.IsCalculated = 0 and        
        d2.DistanceKm < d.DistanceKm        
	order by
		d2.DistanceKm desc
	limit 1
) as s1 on 1 = 1
left join lateral
(
	select
		s2.Standard,
		d2.DistanceKm
    from
		dbo.standards as s2
	join
		dbo.distances as d2 on
        d2.DistanceID = s2.DistanceID
	where
		s2.AgeGradeVersionID = s.AgeGradeVersionID and
        s2.IsMale = s.IsMale and
        s2.IsCalculated = 0 and        
        d2.DistanceKm > d.DistanceKm        
	order by
		d2.DistanceKm 
	limit 1
) as s2 on 1 = 1
where
	d.DistanceID = distance_id and
    not exists (
		select 1
        from
			dbo.standards as s0
		where
			s0.AgeGradeVersionID = s.AgeGradeVersionID and
            s0.IsMale = s.IsMale and            
			s0.DistanceID = d.DistanceID
);

end