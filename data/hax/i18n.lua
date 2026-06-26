local locale_aliases = {
  en = "en",
  br = "pt-br",
  cn = "zh-cn",
  de = "de",
  es = "es-es",
  ["es-es"] = "es-es",
  fr = "fr-fr",
  ["fr-fr"] = "fr-fr",
  it = "it",
  ja = "jp",
  jp = "jp",
  ko = "ko",
  pl = "pl",
  pt = "pt-br",
  ["pt-br"] = "pt-br",
  ru = "ru",
  ua = "uk",
  uk = "uk",
  zh = "zh-cn",
  ["zh-cn"] = "zh-cn"
}

local fallback_locale = "en"
local detected_locale = GameTextGet("x")
local current_locale = locale_aliases[detected_locale] or fallback_locale
local locale_path = "data/hax/i18n/"

local fallback_strings = dofile(locale_path .. fallback_locale .. ".lua")
local current_strings = fallback_strings

if current_locale ~= fallback_locale then
  current_strings = dofile(locale_path .. current_locale .. ".lua")
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

function get_cheatgui_locale()
  return current_locale
end
