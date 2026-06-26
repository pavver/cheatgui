local locale_aliases = {
  en = "en",
  English = "en",
  br = "pt-br",
  cn = "zh-cn",
  de = "de",
  Deutsch = "de",
  es = "es-es",
  ["es-es"] = "es-es",
  ["Español"] = "es-es",
  fr = "fr-fr",
  ["fr-fr"] = "fr-fr",
  ["Français"] = "fr-fr",
  it = "it",
  Italiano = "it",
  ja = "jp",
  jp = "jp",
  ["日本語"] = "jp",
  ko = "ko",
  ["한국어"] = "ko",
  pl = "pl",
  Polska = "pl",
  pt = "pt-br",
  ["pt-br"] = "pt-br",
  ["Português (Brasil)"] = "pt-br",
  ru = "ru",
  ["русский"] = "ru",
  ua = "uk",
  uk = "uk",
  ["Українська"] = "uk",
  ["українська"] = "uk",
  zh = "zh-cn",
  ["zh-cn"] = "zh-cn",
  ["简体中文"] = "zh-cn"
}

local fallback_locale = "en"
local detected_locale = GameTextGet("$current_language")
local current_locale = locale_aliases[detected_locale] or fallback_locale
local locale_path = "data/hax/i18n/"

local fallback_strings = dofile(locale_path .. fallback_locale .. ".lua")
local current_strings = fallback_strings
local english_game_strings = {}

if current_locale ~= fallback_locale then
  current_strings = dofile(locale_path .. current_locale .. ".lua")
end

local function read_second_csv_field(line)
  local field_start = line:find(",", 1, true)
  if field_start == nil then return nil, nil end

  local key = line:sub(1, field_start - 1)
  field_start = field_start + 1

  if line:sub(field_start, field_start) ~= '"' then
    local field_end = line:find(",", field_start, true)
    return key, line:sub(field_start, (field_end or (#line + 1)) - 1)
  end

  local value = {}
  local index = field_start + 1
  while index <= #line do
    local character = line:sub(index, index)
    if character == '"' then
      if line:sub(index + 1, index + 1) == '"' then
        value[#value + 1] = '"'
        index = index + 2
      else
        break
      end
    else
      value[#value + 1] = character
      index = index + 1
    end
  end
  return key, table.concat(value)
end

local mod_text_file_get_content =
    cheatgui_stash and cheatgui_stash.ModTextFileGetContent
if mod_text_file_get_content then
  local translations = mod_text_file_get_content("data/translations/common.csv")
  for line in (translations or ""):gmatch("[^\r\n]+") do
    local key, english_text = read_second_csv_field(line)
    if key and key ~= "" and english_text and english_text ~= "" then
      english_game_strings["$" .. key] = english_text
    end
  end
end

local function interpolate(text, values)
  if values == nil then return text end
  return (text:gsub("{([%w_]+)}", function(name)
    local value = values[name]
    if value == nil then return "{" .. name .. "}" end
    return tostring(value)
  end))
end

function tr(key, values)
  local text = current_strings[key] or fallback_strings[key]
  if text == nil then return "[[" .. key .. "]]" end
  return interpolate(text, values)
end

function tr_english(key, values)
  local text = fallback_strings[key]
  if text == nil then return "[[" .. key .. "]]" end
  return interpolate(text, values)
end

function resolve_english_name(text_or_key, default)
  if type(text_or_key) ~= "string" then return default end
  if text_or_key:sub(1, 1) ~= "$" then return text_or_key end
  return english_game_strings[text_or_key] or default or text_or_key
end

function get_cheatgui_locale()
  return current_locale
end
