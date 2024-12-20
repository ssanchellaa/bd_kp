DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public' LOOP
        EXECUTE format('DROP TABLE IF EXISTS %I CASCADE', r.tablename);
    END LOOP;
END $$;

