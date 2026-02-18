-- schema.sql
CREATE TABLE IF NOT EXISTS match_scouting (
    id SERIAL PRIMARY KEY,
    match INTEGER,
    team INTEGER,
    alliance TEXT,
    
    -- Scoring
    auto_fuel INTEGER DEFAULT 0,
    fuel_balls INTEGER DEFAULT 0,
    alliance_pass INTEGER DEFAULT 0,
    
    -- Climb
    climb TEXT,
    auto_climb INTEGER DEFAULT 0,
    
    -- Capabilities
    is_turreted INTEGER DEFAULT 0,
    fits_trench INTEGER DEFAULT 0,
    defense INTEGER DEFAULT 0,
    
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);