local torch = require 'torch'
local driver, postgres
local json = require 'cjson'

--- @module Experiment
-- Experiment container that is backed up to a Postgres instance.
-- 
-- Example:
-- 
-- Suppose we have already made a postgres database called `myexp`.
-- 
-- @code
-- local c = Experiment.new('myexp')
-- local run = c:create_run{dataset='foobar', lr=1.0, n_hid=10}
-- print(run:info())
-- run:submit_scores(1, {macro={f1=0.53, precision=0.52, recall=0.54}, micro={f1=0.10, precision=0.10, recall=0.10}})
-- run:submit_scores(2, {macro={f1=0.55, precision=0.55, recall=0.55}, micro={f1=0.10, precision=0.10, recall=0.10}})
-- print(run:scores())
-- 
-- run:submit_prediction(1, 'person', 'thing', {dataset='foobar'})
-- run:submit_prediction(2, 'person', 'person', {dataset='foobar'})
-- run:submit_prediction(3, 'person', 'thing', {dataset='foobar'})
-- run:submit_prediction(4, 'thing', 'thing', {dataset='foobar'})
-- print(run:predictions())
local Experiment = torch.class('tl.Experiment')

--- Constructor.
-- 
-- @arg {string} name - name of the experiment
-- @arg {username=} - username for postgres
-- @arg {hostname=} - hostname for postgres
-- @arg {port=} - port for postgres
-- 
-- It is assumed that a database with this name also exists and the user has permission to connect to it.
-- For more information on the parameters for postgres, see:
-- 
-- http://keplerproject.github.io/luasql/manual.html#postgres_extensions
function Experiment:__init(name, username, password, hostname, port)
  self.name = assert(name, 'name must be given')

  -- lazily load driver and postgres
  if not driver then
    driver = assert(require('luasql.postgres'), 'could not load luasql.postgres. luarocks install luasql-postgres')
    postgres = assert(driver.postgres(), 'could not load driver.postgres')
  end

  -- connect to the database
  self.conn = assert(postgres:connect(self.name, username, password, hostname, port), 'cannot connect to database '..self.name)

  -- check whether needed table exist
  if not pcall(function()
      self:query('select * from runs limit 1')
      self:query('select * from scores limit 1')
      self:query('select * from predictions limit 1')
    end) then
    self:setup()
  end
end

--- Creates relevant tables.
function Experiment:setup()
  self:query([[
    CREATE TABLE runs (
      id SERIAL PRIMARY KEY,
      opt JSONB NOT NULL,
      timestamp TIMESTAMP DEFAULT current_timestamp
    )]])
  self:query([[
    CREATE TABLE scores (
      run_id INTEGER,
      epoch INTEGER NOT NULL,
      scores JSONB NOT NULL,
      timestamp TIMESTAMP DEFAULT current_timestamp,
      FOREIGN KEY (run_id) REFERENCES runs(id),
      PRIMARY KEY (run_id, epoch)
    )]])
  self:query([[
    CREATE TABLE predictions (
      id SERIAL PRIMARY KEY,
      example_id INTEGER NOT NULL,
      run_id INTEGER,
      info JSONB,
      gold TEXT,
      pred TEXT NOT NULL,
      FOREIGN KEY (run_id) REFERENCES runs(id)
    )]])
end

--- Drops tables for this experiment.
function Experiment:delete()
  self:query('DROP TABLE IF EXISTS runs CASCADE')
  self:query('DROP TABLE IF EXISTS scores')
  self:query('DROP TABLE IF EXISTS predictions')
end

local convert_row = function(row, names, types)
  local ret = {}
  for i, name in ipairs(names) do
    if string.startswith(types[i], 'int') or string.startswith(types[i], 'dec') or string.startswith(types[i], 'float') then
      row[i] = tonumber(row[i])
    end
    if string.startswith(types[i], 'json') then
      row[i] = json.decode(row[i])
    end
    ret[name] = row[i]
  end
  return ret
end

--- Submits a query to the database and returns the result.
-- @arg {string} query - query to run
-- @arg {boolean=} iterator - whether to return the result as an iterator or as a table
-- @returns {conditional} if `true`, then an iterator will be returned. Otherwise, a table will be returned
-- 
-- If the result is not a number, then results will be returned. If the result is a number, then no result will
-- be returned.
--
-- If the query fails, then an error will be raised.
function Experiment:query(query, iterator)
  local cursor = assert(self.conn:execute(query), 'Query failed: '..query)
  if type(cursor) ~= 'number' then
    local types = cursor:getcoltypes()
    local names = cursor:getcolnames()
    local row = {}
    if iterator then
      return function()
        if cursor:fetch(row, 'n') == nil then return nil end
        return convert_row(row, names, types)
      end
    else
      local ret = {}
      while cursor:fetch(row, 'n') do
        table.insert(ret, convert_row(row, names, types))
      end
      return ret
    end
  end
end


--- Creates a new run for the experiment.
-- 
-- @arg {table[any:any]} opt - options for the run
-- 
-- @returns {table} a Run object
--
-- The Run object returned has the following functions:
-- 
-- - `run.id`: the id for this run
-- 
-- - `run:info()`: retrieves the row in the runs table.
-- 
-- - `run:scores()`: retrieves the scores in the scores table.
-- 
-- - `run:submit_scores(epoch, scores)`: submits scores.
-- 
-- - `run:predictions(example_id)`: retrieves the predictions.
-- 
-- - `run:submit_prediction(example_id, pred, gold, info)`: submits a single prediction.
-- 
-- These are merely convenience functions mapping to corresponding methods in `Experiment`.
-- They are convienient in the sense that one does not have to memorize the `id` of the Run to use them.
function Experiment:create_run(opt)
  local json_opt = json.encode(assert(opt))
  local id = self:query("INSERT INTO runs (opt) VALUES ('"..self.conn:escape(json_opt).."') RETURNING id")[1].id

  return {
    id = id,
    info = function(r) return self:get_run_info(id) end,
    scores = function(r) return self:get_run_scores(id) end,
    submit_scores = function(r, epoch, scores) return self:submit_scores(id, epoch, scores) end,
    predictions = function(r, example_id) return self:get_predictions(id, example_id) end,
    submit_prediction = function(r, example_id, pred, gold, info)
      return self:submit_prediction(id, example_id, pred, gold, info)
    end,
  }
end

--- Retrieves the options for the requested run.
-- @arg {int} id - ID of the run to retrieve.
function Experiment:get_run_info(id)
  local rows = self:query("SELECT * FROM runs WHERE id = "..id)
  assert(#rows > 0, 'run with id '..id..' not found!')
  return rows[1]
end

--- Submits a score for the run.
-- @arg {int} run_id - ID of the run to submit scores for
-- @arg {int} epoch - epoch of the score
-- @arg {table[string:number]} scores - scores to submit
function Experiment:submit_scores(run_id, epoch, scores)
  local json_opt = json.encode(assert(scores))
  local query = string.format("INSERT INTO scores (run_id, epoch, scores) VALUES (%s, %s, '%s')",
                              assert(run_id),
                              assert(epoch),
                              self.conn:escape(json_opt))
  self:query(query)
end

--- Retrieves the scores for the requested run.
--
-- @arg {int} id - ID of the run to retrieve.
function Experiment:get_run_scores(id)
  return self:query("SELECT * FROM scores WHERE run_id = "..id.." ORDER BY epoch ASC")
end

--- Submits the prediction for a single example for a run.
-- 
-- @arg {int} run_id - ID for the run
-- @arg {int} example_id - ID for the example
-- @arg {any} pred - prediction
-- @arg {any=} gold - ground truth
-- @arg {table=} info - information for the run
function Experiment:submit_prediction(run_id, example_id, pred, gold, info)
  local fields = 'run_id, example_id, pred'
  local filler = "%s, %s, '%s'"
  local args = {assert(run_id), assert(example_id), assert(pred)}
  if gold then
    fields = fields .. ', gold'
    filler = filler .. ", '%s'"
    table.insert(args, gold)
  end
  if info then
    fields = fields .. ', info'
    filler = filler .. ", '%s'"
    table.insert(args, json.encode(info))
  end
  table.insert(args, 1, "INSERT INTO predictions ("..fields..") VALUES ("..filler..")")
  local query = string.format(table.unpack(args))
  self:query(query)
end


--- Retrieves the prediction a run.
-- @arg {int} run_id - ID for the run
-- @arg {int=} example_id - ID for the example. If this is given then only the prediction for this example is returned
function Experiment:get_predictions(run_id, example_id)
  if example_id then
    return self:query('SELECT * FROM predictions WHERE run_id = '..run_id..' AND example_id = '..example_id)
  else
    return self:query('SELECT * FROM predictions WHERE run_id = '..run_id..' ORDER BY example_id ASC')
  end
end
