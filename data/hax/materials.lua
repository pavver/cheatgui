materials_list = {}

local get_name = function(mat)
  return mat
end

if not DebugGetIsDevBuild() then
  -- Dev build likes to complain about translations
  get_name = function(mat)
    local n = GameTextGet("$mat_" .. mat)
    if n and n ~= "" then return n else return "[" .. mat .. "]" end
  end
end

local material_categories = {
  {"Liquids", "material.liquids"},
  {"Solids", "material.solids"},
  {"Sands", "material.sands"},
  {"Gases", "material.gases"},
  {"Fires", "material.fires"}
}

for _, category_info in ipairs(material_categories) do
  local category, category_key = unpack(category_info)
  local category_name = tr(category_key)
  table.insert(materials_list, {"-- " .. category_name .. " --", "-- " .. category_name .. " --"})
  local mats = getfenv()["CellFactory_GetAll" .. category]()
  print("Got " .. #mats .. " " .. category)
  table.sort(mats)
  for _, mat in ipairs(mats) do
    table.insert(materials_list, {mat, get_name(mat)})
  end
end

-- local getters = {
--   {"Fires", CellFactory_GetAllFires, 
--   CellFactory_GetAllGases,
--   CellFactory_GetAllSolids,
--   CellFactory_GetAllSands,
--   CellFactory_GetAllLiquids
-- }