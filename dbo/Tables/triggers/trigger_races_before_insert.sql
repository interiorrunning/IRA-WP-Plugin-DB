CREATE TRIGGER
    trigger_races_before_insert BEFORE INSERT ON
    dbo.races FOR EACH ROW
BEGIN
    call
        dbo.p_add_distance(NEW.Distance, NEW.IsMiles);
    
    set
        NEW.DistanceID = (		
        select
            d.DistanceID
        from
            dbo.distances as d
        where
            d.Distance = NEW.Distance and
            d.IsMiles = NEW.IsMiles
    );		
END