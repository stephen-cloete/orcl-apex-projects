--------------------------------------------------------------------------------
-- apex-inventory-control : remove all INV_* objects (DESTRUCTIVE, dev only)
--------------------------------------------------------------------------------
begin
  for r in (select object_name, object_type from user_objects
             where object_name like 'INV\_%' escape '\'
               and object_type in ('PACKAGE','VIEW','TABLE')
             order by decode(object_type,'PACKAGE',1,'VIEW',2,'TABLE',3))
  loop
    execute immediate 'drop ' || r.object_type || ' ' || r.object_name
                      || case r.object_type when 'TABLE' then ' cascade constraints purge' end;
  end loop;
end;
/
